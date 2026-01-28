package com.gorani.vroom.vroompay;

import java.math.BigDecimal;
import java.util.Map;

public interface VroomPayService {

    Map<String, Object> getAccountStatus(Long userId);

    Map<String, Object> linkAccount(Long userId, String username);

    // TODO: VroomPay 연동 후 재구현 필요
    Map<String, Object> charge(Long userId, BigDecimal amount, String memo);

    // TODO: VroomPay 연동 후 재구현 필요
    Map<String, Object> withdraw(Long userId, BigDecimal amount);

    // TODO: VroomPay 연동 후 재구현 필요
    Map<String, Object> getTransactionHistory(Long userId, int page, int size);
}
