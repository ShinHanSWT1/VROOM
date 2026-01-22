package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LikeResponseDTO {
    private boolean liked;
    private Long likeCount;
}