package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommunityPostVO {
    private Long postId;
    private String title;
    private String content;
    private Long viewCount;
    private Long likeCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;
    private Long userId;
    private String nickname;
    private String dongCode;
    private String dongName;
    private Long categoryId;
    private String categoryName;
    private Double mannerScore;
}
