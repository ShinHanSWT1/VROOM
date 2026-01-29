package com.gorani.vroom.vroompay;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class VroomPayVO {
    private Long userId;
    private BigDecimal balance;
    private BigDecimal availBalance;
    private String realAccount;
    private Timestamp updatedAt;
}
