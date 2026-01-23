package com.gorani.vroom.errand.post;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.gorani.vroom.common.util.CategoryImageUtil;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ErrandServiceImpl implements ErrandService {

    private final ErrandMapper errandMapper;


    @Override
    public List<ErrandListVO> getErrandList(String q, Long categoryId, String dongCode, String sort, int page, int size) {

        // 방어: page/size 기본값
        int safePage = (page <= 0) ? 1 : page;
        int safeSize = (size <= 0) ? 9 : size;

        // sort 기본값
        String safeSort = (sort == null || sort.isBlank()) ? "latest" : sort;

        // offset 계산 (page는 1부터)
        int offset = (safePage - 1) * safeSize;

        Map<String, Object> param = new HashMap<>();
        param.put("q", q);
        param.put("categoryId", categoryId);
        param.put("dongCode", dongCode);
        param.put("sort", safeSort);
        param.put("limit", safeSize);
        param.put("offset", offset);
        
        List<ErrandListVO> list = errandMapper.selectErrandList(param);
        
        if (list != null) {
            for (ErrandListVO e : list) {
                String url = e.getImageUrl(); // selectErrandList에서 AS imageUrl 로 내려온 값

                if (url == null || url.isBlank()) {
                    url = CategoryImageUtil.getDefaultImage(e.getCategoryId()); // "/static/img/category/xxx.png"
                }

                e.setDisplayImageUrl(url);
            }
        }

        return list;
    }
    
    public List<ErrandListVO> getRelatedErrands(ErrandDetailVO errand) {
        if (errand == null) return List.of();
        if (errand.getDongCode() == null || errand.getCategoryId() == null) return List.of();

        return errandMapper.selectRelatedErrands(
            errand.getErrandsId(),
            errand.getDongCode(),
            errand.getCategoryId(),
            6
        );
    }

    @Override
    public int getErrandTotalCount(String q, Long categoryId, String dongCode) {

        Map<String, Object> param = new HashMap<>();
        param.put("q", q);
        param.put("categoryId", categoryId);
        param.put("dongCode", dongCode);

        return errandMapper.countErrandList(param);
    }
    
    @Override
    public ErrandDetailVO getErrandDetail(Long errandsId) {
    	ErrandDetailVO errand = errandMapper.selectErrandDetail(errandsId);
        if (errand == null) return null;
        String mainImageUrl = errandMapper.selectMainImageUrl(errandsId);

        if (mainImageUrl == null || mainImageUrl.isBlank()) {
            // 이미지 없으면 카테고리 기본 이미지
            mainImageUrl = CategoryImageUtil.getDefaultImage(errand.getCategoryId());
        }

        errand.setMainImageUrl(mainImageUrl);

        return errand;
    }
    
    @Override
    public List<ErrandListVO> getRelatedErrands(Long currentErrandsId, String dongCode, Long categoryId, int limit) {

        if (dongCode == null || categoryId == null) return List.of();

        int safeLimit = (limit <= 0) ? 6 : limit;

        return errandMapper.selectRelatedErrands(currentErrandsId, dongCode, categoryId, safeLimit);
    }
    
    @Override
    public Long createErrand(ErrandCreateVO errandCreateVO) {

        if (errandCreateVO == null) {
            throw new IllegalArgumentException("errandCreateVO is null");
        }

        // 필수값 최소 검증 (원하면 더 빡세게 가능)
        if (errandCreateVO.getTitle() == null || errandCreateVO.getTitle().isBlank()) {
            throw new IllegalArgumentException("title is required");
        }
        if (errandCreateVO.getCategoryId() == null) {
            throw new IllegalArgumentException("categoryId is required");
        }
        if (errandCreateVO.getDongCode() == null || errandCreateVO.getDongCode().isBlank()) {
            throw new IllegalArgumentException("dongCode is required");
        }

        // 1) ERRANDS insert
        //    - 이미지 없는 경우: 여기서 끝
        //    - 중요: insert 후 생성된 PK(errands_id)를 받아와야 함
        int inserted = errandMapper.insertErrand(errandCreateVO);
        if (inserted != 1) {
            throw new IllegalStateException("insertErrand failed");
        }

        // 2) MyBatis에서 generated key를 VO에 주입받는 방식이면 여기서 꺼내서 리턴
        //    (VO에 errandsId 필드가 있어야 함)
        if (errandCreateVO.getErrandsId() == null) {
            // 생성키를 VO로 못 받는 설정이면 다른 방식(selectKey / LAST_INSERT_ID())로 바꿔야 함
            throw new IllegalStateException("errandsId was not generated/assigned to VO");
        }

        return errandCreateVO.getErrandsId();
    }
    
    @Override
    public List<CategoryVO> getCategories() {
        return errandMapper.selectCategories();
    }
    
    @Override
    public List<Map<String, Object>> getDongs() {
        return errandMapper.selectDongs();
    }
}
