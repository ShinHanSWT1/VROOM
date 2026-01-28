package com.gorani.vroom.vroompay;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VroomPayMapper {
    // 아래 메서드들은 VroomPay 시스템으로 대체되었으므로 더 이상 사용되지 않습니다.
    // 필요시 Vroom 프로젝트 내의 다른 데이터 처리를 위해 유지할 수 있으나,
    // VroomPay 잔액/계좌 관련 기능에서는 사용하지 않습니다.

    // VroomPayVO getAccountByUserId(@Param("userId") Long userId);
    // void createAccount(VroomPayVO account);
    // void addBalance(Map<String, Object> params);
    // int subtractBalance(Map<String, Object> params);
    // void insertTransaction(VroomPayVO transaction);
    // List<VroomPayVO> getTransactions(Map<String, Object> params);
    // int getTransactionCount(@Param("userId") Long userId);
}
