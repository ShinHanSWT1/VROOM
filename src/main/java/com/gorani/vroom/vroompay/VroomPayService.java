package com.gorani.vroom.vroompay;

import java.math.BigDecimal;
import java.util.Map;

public interface VroomPayService {

    // 계좌 조회
    Map<String, Object> getAccountStatus(Long userId);

    // 계좌 연결
    Map<String, Object> linkAccount(Long userId, String username);

    // 계좌 충전
    Map<String, Object> charge(Long userId, BigDecimal amount, String memo);

    // 계좌 인출
    Map<String, Object> withdraw(Long userId, BigDecimal amount, String memo);

    // 심부름 정산
    Map<String, Object> settleErrand(Long errandId, Long payerId, Long payeeId, BigDecimal amount);
}
