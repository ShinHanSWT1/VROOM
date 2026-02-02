package com.gorani.vroom.batch;

import lombok.RequiredArgsConstructor;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class JobLauncherController {

    private final JobLauncher jobLauncher;
    private final Job settlementJob; // Config에 정의된 Bean 이름

    @GetMapping("/test/batch/settlement")
    public String runSettlementJob() {
        try {
            // 배치는 동일한 파라미터로 두 번 실행될 수 없으므로, 현재 시간을 파라미터로 넣어 매번 실행되게 함
            JobParameters jobParameters = new JobParametersBuilder()
                    .addLong("time", System.currentTimeMillis())
                    .toJobParameters();

            jobLauncher.run(settlementJob, jobParameters);

            return "배치 실행 완료! 로그와 DB를 확인하세요.";
        } catch (Exception e) {
            e.printStackTrace();
            return "배치 실행 실패: " + e.getMessage();
        }
    }
}