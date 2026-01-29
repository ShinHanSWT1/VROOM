package com.gorani.vroom.vroompay;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WalletTransactionVO {
    private Long id;
    private String txnType;
    private BigDecimal amount;
    private String memo;
    private Timestamp createdAt;
    private Long errandId;
    private Long paymentId;
    private Long userId;
    private Long erranderId;

}
