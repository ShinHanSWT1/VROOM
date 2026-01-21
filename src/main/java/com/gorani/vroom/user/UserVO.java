package com.gorani.vroom.user;

import lombok.Data;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class UserVO {

    // ===== PK =====
    private Long userId;              // user_id (PK)

    // ===== Auth =====
    private String email;
    private String pwd;
    private String snsId;
    private String provider;           // LOCAL / SOCIAL

    // ===== Profile =====
    private String nickname;
    private String phone;
    private String profileImage;

    // ===== Role / Status =====
    private String role;               // USER / ERRANDER
    private String status;             // ACTIVE / SUSPENDED / BANNED ...

    // ===== Metrics =====
    private BigDecimal mannerScore;
    private BigDecimal cancelRate;

    // ===== Location =====
    private String dongCode1;
    private String dongCode2;

    // ===== Audit =====
    private Timestamp createdAt;
    private Timestamp lastLoginAt;
    private Timestamp deletedAt;
}