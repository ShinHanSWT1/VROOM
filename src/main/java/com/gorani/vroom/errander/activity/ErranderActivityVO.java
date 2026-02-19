package com.gorani.vroom.errander.activity;

import lombok.Data;

@Data
public class ErranderActivityVO {
    // 날짜
    private String earnDate;
    // 하루 수익 합계 (COMPLETED만)
    private Long dailyEarning;
    // 진행중 건수 (MATCHED, CONFIRMED1, CONFIRMED2)
    private int inProgressCount;
}
