package com.gorani.vroom.user.auth;

import lombok.Data;

@Data
public class LegalDongVO {

    private String dongCode;  // 동 코드 (DB 저장)
    private String dongName;  // 동 이름 (화면 표시)

}