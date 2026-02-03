package com.gorani.vroom.admin.notice;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class NoticeVO {
    private Long id;
    private String title; // 공지 제목
    private String content; // 공지 내용
    private String target; // 누구에게 보여줄건지
    private String status; // 즉시, 예약 등등
    private String isImportant; // 일반 공지 or 상단 공지
    private Timestamp startAt; // 공지 시작일
    private Timestamp endAt; // 공지 종료일
    private Timestamp createdAt; // 공지 최초 생성 시각
    private  Timestamp updatedAt; // 공지 수정 시각
    private Long adminId; // 관지라 아이디
}
