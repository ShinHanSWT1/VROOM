package com.gorani.vroom.admin.auth;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class AdminVO {
    private int id;
    private String loginId;
    private String password;
    private String name;
    private String position;
    private Timestamp createdAt;
    private Timestamp lastLoginAt;
}
