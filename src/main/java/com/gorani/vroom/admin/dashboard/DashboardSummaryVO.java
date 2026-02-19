package com.gorani.vroom.admin.dashboard;

import lombok.Data;

@Data
public class DashboardSummaryVO {

    // 총 사용자
    private int totalUserCount;
    private int totalUserDelta;

    // 일간 활성 사용자 수
    private int dauToday;
    private int dauYesterday;
    private int dauDelta;

    // 오늘 주문
    private int errandsToday;
    private int errandsYesterday;
    private Integer errandsDiffRate;

    // 완료율
    private int completionRate;

    // 활성 부름이
    private int activeErranderToday;
    private int activeErranderYesterday;
    private int activeErranderDelta;
}
