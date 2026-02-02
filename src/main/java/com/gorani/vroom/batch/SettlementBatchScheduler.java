package com.gorani.vroom.batch;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
@EnableScheduling
public class SettlementBatchScheduler {

    private final JobLauncher jobLauncher;
    private final Job settlementJob; // 위에서 만든 Job Bean

    // 매일 새벽 3시에 실행 (초 분 시 일 월 요일)
    @Scheduled(cron = "0 0 3 * * *")
    public void runSettlementJob() {
        try {
            log.info("정산 배치 스케줄러 시작");

            // JobParameter에 현재 시간을 넣어 매번 새로운 JobInstance로 실행되게 함
            JobParameters jobParameters = new JobParametersBuilder()
                    .addLong("time", System.currentTimeMillis())
                    .toJobParameters();

            jobLauncher.run(settlementJob, jobParameters);

        } catch (Exception e) {
            log.error("정산 배치 실행 중 오류 발생", e);
        }
    }
}
