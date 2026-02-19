package com.gorani.vroom.community;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaginationVO {
    private Long totalPosts; // 총 게시글 수
    private Long size; // 페이지당 게시글 수
    private Long totalPages; // 총 페이지 수
    private Long page; // 현재 페이지
    private List<CommunityPostVO> content; // 게시글 리스트


}
