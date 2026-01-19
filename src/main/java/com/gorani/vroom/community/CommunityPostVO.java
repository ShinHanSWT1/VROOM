package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.w3c.dom.Text;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommunityPostVO {
    private Long postId;
    private String title;
    private Text content;
    private Long viewCount;
    private Long likeCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;
    private Long userId;
    private String nickname;
    private String dongCode;
    private Long categoryId;
    private String categoryName;
    private Double mannerScore;
    private String dongName;
}
