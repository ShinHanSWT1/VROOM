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
import org.springframework.batch.item.support.CompositeItemWriter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Configuration
@EnableBatchProcessing
@RequiredArgsConstructor
public class SettlementBatchConfig {

    private static final int CHUNK_SIZE = 10;
    private static final int DELAY_DAYS = 8;

    private final JobBuilderFactory jobBuilderFactory;
    private final StepBuilderFactory stepBuilderFactory;
    private final VroomPayService vroomPayService;

    //  Job 정의 
    @Bean
    public Job settlementJob(SqlSessionFactory sqlSessionFactory) {
        return jobBuilderFactory.get("settlementJob")
                .start(settlementStep(sqlSessionFactory))
                .build();
    }

    //  Step 정의 
    @Bean
    public Step settlementStep(SqlSessionFactory sqlSessionFactory) {
        return stepBuilderFactory.get("settlementStep")
                .<SettlementTargetVO, Map<String, Object>>chunk(CHUNK_SIZE)
                .reader(settlementReader(sqlSessionFactory))
                .processor(settlementProcessor())
                .writer(compositeSettlementWriter(sqlSessionFactory))
                .build();
    }

    //  Reader: DB에서 정산 대상 조회 
    @Bean
    public MyBatisPagingItemReader<SettlementTargetVO> settlementReader(SqlSessionFactory sqlSessionFactory) {
        Map<String, Object> params = new HashMap<>();
        params.put("days", DELAY_DAYS);

        return new MyBatisPagingItemReaderBuilder<SettlementTargetVO>()
                .sqlSessionFactory(sqlSessionFactory)
                .queryId("com.gorani.vroom.vroompay.VroomPayMapper.selectSettlementTargets")
                .parameterValues(params)
                .pageSize(CHUNK_SIZE)
                .build();
    }

    //  Processor: 외부 API 호출 및 비즈니스 로직 
    @Bean
    public ItemProcessor<SettlementTargetVO, Map<String, Object>> settlementProcessor() {
        return item -> {
            try {
                log.info("정산 처리 시작 - AssignmentID: {}", item);

                // VroomPay 정산
                Map<String, Object> result = vroomPayService.settleErrand(
                        item.getErrandsId(),
                        item.getUserId(),
                        item.getErranderId(),
                        item.getAmount()
                );

                // API 성공 여부 확인
                if (result != null && Boolean.TRUE.equals(result.get("success"))) {
                    log.info("정산 결과 - " + result);
                    log.info("정산 API 성공 - ErrandID: {}", item.getErrandsId());

                    // Writer로 넘길 Map 생성
                    Map<String, Object> updateParams = new HashMap<>();

                    updateParams.put("item", item);
                    updateParams.put("errandStatus", "COMPLETED");
                    updateParams.put("assignmentStatus", "COMPLETED");
                    updateParams.put("memo", "시스템 자동 정산 완료");

                    return updateParams; // Writer로 전달
                } else {
                    log.error("정산 API 실패 - ErrandID: {}, Msg: {}", item.getErrandsId(), result != null ? result.get("message") : "null");
                    return null; // null을 반환하면 Writer로 넘어가지 않고 해당 건은 건너뜁니다.
                }

            } catch (Exception e) {
                log.error("정산 처리 중 예외 발생 - Item: {}", item, e);
                return null; // 예외 발생 시 스킵 (필요 시 SkipPolicy 적용 가능)
            }
        };
    }

    //  Writer: DB 상태 업데이트 (API 성공한 건만 도달)
    @Bean
    public CompositeItemWriter<Map<String, Object>> compositeSettlementWriter(SqlSessionFactory sqlSessionFactory) {
        CompositeItemWriter<Map<String, Object>> writer = new CompositeItemWriter<>();
        // 두 개의 Writer를 리스트로 묶어서 등록 (순서대로 실행됨)
        writer.setDelegates(Arrays.asList(
                updateErrandWriter(sqlSessionFactory),
                updateAssignmentWriter(sqlSessionFactory),
                insertErrandHistory(sqlSessionFactory)
        ));
        return writer;
    }

    @Bean
    public MyBatisBatchItemWriter<Map<String, Object>> updateErrandWriter(SqlSessionFactory sqlSessionFactory) {
        return new MyBatisBatchItemWriterBuilder<Map<String, Object>>()
                .sqlSessionFactory(sqlSessionFactory)
                .statementId("com.gorani.vroom.errand.assignment.ErrandAssignmentMapper.updateErrandStatusConfirmed2ToCompleted")
                .assertUpdates(false)
                .build();
    }

    @Bean
    public MyBatisBatchItemWriter<Map<String, Object>> updateAssignmentWriter(SqlSessionFactory sqlSessionFactory) {
        return new MyBatisBatchItemWriterBuilder<Map<String, Object>>()
                .sqlSessionFactory(sqlSessionFactory)
                .statementId("com.gorani.vroom.errand.assignment.ErrandAssignmentMapper.updateErrandAssignmentStatusToCompleted")
                .assertUpdates(false)
                .build();
    }

    @Bean
    public MyBatisBatchItemWriter<Map<String, Object>> insertErrandHistory(SqlSessionFactory sqlSessionFactory) {
        return new MyBatisBatchItemWriterBuilder<Map<String, Object>>()
                .sqlSessionFactory(sqlSessionFactory)
                .statementId("com.gorani.vroom.errand.assignment.ErrandAssignmentMapper.insertErrandHistoryToCompletedBySystem")
                .assertUpdates(false)
                .build();
    }
}