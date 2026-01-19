package com.gorani.vroom.errand.post;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ErrandServiceImpl implements ErrandService {

    private final ErrandMapper errandMapper;


//    @Override
//    public List<ErrandListVO> getErrandList(String q, Long categoryId, String dongCode, String sort, int page, int size) {
//
//        // 방어: page/size 기본값
//        int safePage = (page <= 0) ? 1 : page;
//        int safeSize = (size <= 0) ? 20 : size;
//
//        // sort 기본값
//        String safeSort = (sort == null || sort.isBlank()) ? "latest" : sort;
//
//        // offset 계산 (page는 1부터)
//        int offset = (safePage - 1) * safeSize;
//
//        Map<String, Object> param = new HashMap<>();
//        param.put("q", q);
//        param.put("categoryId", categoryId);
//        param.put("dongCode", dongCode);
//        param.put("sort", safeSort);
//        param.put("limit", safeSize);
//        param.put("offset", offset);
//
//        return errandMapper.selectErrandList(param);
//    }
//
//    @Override
//    public int getErrandTotalCount(String q, Long categoryId, String dongCode) {
//
//        Map<String, Object> param = new HashMap<>();
//        param.put("q", q);
//        param.put("categoryId", categoryId);
//        param.put("dongCode", dongCode);
//
//        return errandMapper.countErrandList(param);
//    }
    
    
    
    
    
    
    
    
    
    @Override
    public List<ErrandListVO> getErrandList(String q, Long categoryId, String dongCode, String sort, int page, int size) {

        // DB 붙기 전 임시 더미 데이터
        List<ErrandListVO> dummy = new ArrayList<>();

        ErrandListVO e1 = new ErrandListVO();
        e1.setErrandsId(1L);
        e1.setTitle("스벅 자허블 픽업 해주세요");
        e1.setRewardAmount(new BigDecimal("4000"));
        e1.setDongCode("1168010100");
        dummy.add(e1);

        ErrandListVO e2 = new ErrandListVO();
        e2.setErrandsId(2L);
        e2.setTitle("집 청소 도와주실 분");
        e2.setRewardAmount(new BigDecimal("15000"));
        e2.setDongCode("1168010200");
        dummy.add(e2);

        return dummy;
    }

    @Override
    public int getErrandTotalCount(String q, Long categoryId, String dongCode) {
        return 2;
    }
}
