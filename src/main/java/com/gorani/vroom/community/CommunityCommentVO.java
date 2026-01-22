package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommunityCommentVO {
    private Long commentId;
    private String content;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;

    private Long postId;
    private String nickname;
    private Long userId;

    // 대댓글 관련 필드
    private Long parentCommentId;
    private Long groupId;
    private Long depth;

    // 세션 유저 정보 가져와 본인 확인
    private boolean isUser = false;
}
