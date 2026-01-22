package com.gorani.vroom.errand.post;

import java.util.List;
import java.util.Map;

public interface ErrandService {

    /**
     * 심부름 게시글 목록 조회
     *
     * @param q 검색어(제목/내용)
     * @param categoryId 카테고리 필터
     * @param dongCode 동네코드 필터
     * @param sort latest | price_asc | price_desc | desired_at
     * @param page 1부터 시작
     * @param size 한 페이지당 개수
     */
    List<ErrandListVO> getErrandList(String q, Long categoryId, String dongCode, String sort, int page, int size);

    // 심부름 게시글 총 개수(페이징용)
    int getErrandTotalCount(String q, Long categoryId, String dongCode);
    
    // 심부름 게시글 상세 조회
    // @param errandsId 게시글 ID
    ErrandDetailVO getErrandDetail(Long errandsId);
    List<ErrandListVO> getRelatedErrands(Long currentErrandsId, String dongCode, Long categoryId, int limit);
    
    // 심부름 게시글 등록 (이미지 없어도 가능)
    // @param errandCreateVO 게시글 생성 정보
    // @return 생성된 심부름 게시글 ID (PK)
    Long createErrand(ErrandCreateVO errandCreateVO);
    
    // 작성폼에서 카테고리 셀렉트 옵션용
    List<CategoryVO> getCategories();
    List<Map<String, Object>> getDongs();

}
