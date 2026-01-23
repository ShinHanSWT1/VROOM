package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommunityPostVO {

    // --- COMMUNITY 테이블 ---
    private Long postId;
    private String title;
    private String content;
    private Long viewCount;
    private Long likeCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;
    private Long userId;
    private String dongCode;
    private Long categoryId;
    private Long commentCount;

    // --- MEMBERS 테이블 (JOIN) ---
    private String nickname;
    private Double mannerScore;

    // --- LEGAL_DONG 테이블 (JOIN) ---
    private String dongName;
    private String gunguName;

    // --- COMMUNITY_CATEGORY 테이블 (JOIN) ---
    private String categoryName;
}
