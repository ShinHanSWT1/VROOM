package com.gorani.vroom.vroompay;

import org.apache.ibatis.annotations.Mapper;
import java.util.Map;

@Mapper
public interface VroomPayMapper {
    
    // 결제/거래 내역 기록
    void insertPaymentOrder(Map<String, Object> params);
}
