package com.gorani.vroom.errand.post;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ErrandMapper {

    /**
     * 심부름 게시글 목록 조회
     * @param param 검색/필터/정렬/페이징 파라미터
     * @return 심부름 목록
     */
    List<ErrandListVO> selectErrandList(Map<String, Object> param);

    /**
     * 심부름 게시글 전체 개수
     * @param param 검색/필터 파라미터
     * @return 총 개수
     */
    int countErrandList(Map<String, Object> param);
    int insertErrand(ErrandCreateVO vo);
    
    ErrandDetailVO selectErrandDetail(@Param("errandsId") Long errandsId);
    List<ErrandListVO> selectRelatedErrands(@Param("errandsId") Long errandsId,
            @Param("dongCode") String dongCode,
            @Param("categoryId") Long categoryId,
            @Param("limit") int limit);
    
    List<CategoryVO> selectCategories();
    List<Map<String, Object>> selectDongs();
}
