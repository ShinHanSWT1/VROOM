package com.gorani.vroom.user.profile;

import lombok.Data;

@Data
public class UserProfileVO {

    private Long userId; // 사용자 아이디
    private String nickname; // 닉네임
    private String profileImage; // 프로필 사진
    private Double mannerTemp; // 매너점수(당근 온도)

}
