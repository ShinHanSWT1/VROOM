package com.gorani.vroom.batch;

import com.gorani.vroom.vroompay.VroomPayService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.batch.MyBatisBatchItemWriter;
import org.mybatis.spring.batch.MyBatisPagingItemReader;
import org.mybatis.spring.batch.builder.MyBatisBatchItemWriterBuilder;
import org.mybatis.spring.batch.builder.MyBatisPagingItemReaderBuilder;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;
import java.util.Map;

@Slf4j
@Configuration
@EnableBatchProcessing
@RequiredArgsConstructor
public class SettlementBatchConfig {

    private static final int CHUNK_SIZE = 10;

    private final JobBuilderFactory jobBuilderFactory;
    private final StepBuilderFactory stepBuilderFactory;
    private final VroomPayService vroomPayService;

    // --- Job 정의 ---
    @Bean
    public Job settlementJob(SqlSessionFactory sqlSessionFactory) {
        return jobBuilderFactory.get("settlementJob")
                .start(settlementStep(sqlSessionFactory))
                .build();
    }

    // --- Step 정의 ---
    @Bean
    public Step settlementStep(SqlSessionFactory sqlSessionFactory) {
        return stepBuilderFactory.get("settlementStep")
                .<Map<String, Object>, Map<String, Object>>chunk(CHUNK_SIZE)
                .reader(settlementReader(sqlSessionFactory))     // 1. 읽기
                .processor(settlementProcessor())                // 2. 처리 (API 호출)
                .writer(settlementWriter(sqlSessionFactory))     // 3. 쓰기 (상태 변경)
                .build();
    }

    // --- 1. Reader: DB에서 정산 대상 조회 ---
    @Bean
    public MyBatisPagingItemReader<Map<String, Object>> settlementReader(SqlSessionFactory sqlSessionFactory) {
        return new MyBatisPagingItemReaderBuilder<Map<String, Object>>()
                .sqlSessionFactory(sqlSessionFactory)
                .queryId("com.gorani.vroom.admin.settlement.AdminSettlementMapper.getAutoSettlementTargets")
                .pageSize(CHUNK_SIZE)
                .build();
    }

    // --- 2. Processor: 외부 API 호출 및 비즈니스 로직 ---
    @Bean
    public ItemProcessor<Map<String, Object>, Map<String, Object>> settlementProcessor() {
        return item -> {
            try {
                Long errandId = Long.valueOf(String.valueOf(item.get("id"))); // Mapper에서 조회한 컬럼명 (errand_id alias id)
                Long erranderId = Long.valueOf(String.valueOf(item.get("erranderId"))); // Mapper 조회 컬럼명 확인 필요
                BigDecimal amount = new BigDecimal(String.valueOf(item.get("rewardAmount")));
                Long payerId = 1L; // 시스템 공통 계좌 ID 등

                log.info("정산 처리 시작 - ErrandID: {}, Amount: {}", errandId, amount);

                // (1) 외부 API 호출 (VroomPayService)
                Map<String, Object> result = vroomPayService.settleErrand(
                        errandId,
                        payerId,
                        erranderId,
                        amount
                );

                // (2) API 성공 여부 확인
                if (result != null && Boolean.TRUE.equals(result.get("success"))) {
                    log.info("정산 API 성공 - ErrandID: {}", errandId);

                    // Writer로 넘길 파라미터 세팅 (상태 업데이트용)
                    // 여기서 반환된 map이 Writer로 넘어갑니다.
                    item.put("errandStatus", "COMPLETED");
                    item.put("assignmentStatus", "COMPLETED");
                    item.put("memo", "시스템 자동 정산 완료");

                    return item; // Writer로 전달
                } else {
                    log.error("정산 API 실패 - ErrandID: {}, Msg: {}", errandId, result != null ? result.get("message") : "null");
                    return null; // null을 반환하면 Writer로 넘어가지 않고 해당 건은 건너뜁니다.
                }

            } catch (Exception e) {
                log.error("정산 처리 중 예외 발생 - Item: {}", item, e);
                return null; // 예외 발생 시 스킵 (필요 시 SkipPolicy 적용 가능)
            }
        };
    }

    // --- 3. Writer: DB 상태 업데이트 (API 성공한 건만 도달) ---
    @Bean
    public MyBatisBatchItemWriter<Map<String, Object>> settlementWriter(SqlSessionFactory sqlSessionFactory) {
        return new MyBatisBatchItemWriterBuilder<Map<String, Object>>()
                .sqlSessionFactory(sqlSessionFactory)
                /* 주의: MyBatisBatchItemWriter는 하나의 statementId만 실행 가능합니다.
                   만약 두 테이블(ERRANDS, ASSIGNMENTS)을 모두 업데이트해야 한다면,
                   1) Mapper XML에서 프로시저를 호출하거나
                   2) CompositeItemWriter를 사용하여 Writer를 두 개 묶어야 합니다.

                   여기서는 Service 로직(processSettlement)처럼 두 테이블을 업데이트하는 로직이
                   Mapper XML 하나에 구현되어 있거나, 핵심 테이블(ERRANDS)을 업데이트한다고 가정합니다.
                */
                .statementId("com.gorani.vroom.admin.settlement.AdminSettlementMapper.updateErrandAndAssignmentStatus")
                .build();
    }
}