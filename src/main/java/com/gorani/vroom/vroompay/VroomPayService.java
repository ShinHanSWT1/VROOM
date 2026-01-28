package com.gorani.vroom.vroompay;

import java.math.BigDecimal;
import java.util.Map;

public interface VroomPayService {

    Map<String, Object> getAccountStatus(Long userId);

    Map<String, Object> linkAccount(Long userId, String username);

    Map<String, Object> charge(Long userId, BigDecimal amount, String memo);

    Map<String, Object> withdraw(Long userId, BigDecimal amount, String memo);
}
