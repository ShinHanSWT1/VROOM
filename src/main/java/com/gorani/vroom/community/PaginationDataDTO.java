package com.gorani.vroom.community;

import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Data
@RequiredArgsConstructor
public class PaginationDataDTO {
    private final List<CommunityPostVO> postList;
    private final long totalCount;
    private final long totalPages;
}
