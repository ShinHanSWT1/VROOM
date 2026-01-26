package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommunityImageVO {

    private Long imageId;
    private String imageUrl;
    private Integer sortOrder;
    private Timestamp registAt;
    private Long postId;
}
