package com.gorani.vroom.user.auth;

import lombok.Data;

@Data
public class KakaoUserInfo {

    private String id;        // 카카오 사용자 고유 ID (sns_id)
    private String email;     // nullable
    private String nickname;  // nullable
}