package com.gorani.vroom.vroompay;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class VroomPayVO {
    // Wallet Account
    private Long userId;
    private String username;
    private BigDecimal balance;
    private BigDecimal availBalance;
    private String realAccount;
    private Timestamp joinedAt;
    private Timestamp updatedAt;

    // Transaction
    private Long txnId;
    private String txnType;
    private BigDecimal amount;
    private String memo;
    private Timestamp txnDate;
}
