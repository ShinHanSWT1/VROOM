package com.gorani.vroom.vroompay;

import com.gorani.vroom.batch.SettlementTargetVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface VroomPayMapper {
    int insertWalletTransactions(WalletTransactionVO walletTransactionVO);

    List<WalletTransactionVO> selectWalletTransactions(@Param("userId") Long userId,
                                                       @Param("offset") int offset,
                                                       @Param("limit") int limit);

    int countWalletTransactions(@Param("userId") Long userId);

    int insertWalletAccount(VroomPayVO vroomPayVO);

    VroomPayVO selectWalletAccount(@Param("userId") Long userId);

    int updateWalletAccount(VroomPayVO vroomPayVO);

    List<SettlementTargetVO> selectSettlementTargets(@Param("day") int day);

    int updateAssignmentStatusToComplete(@Param("assignmentId") Long assignmentId);

    Long getPaymentIdForSettlement(
            @Param("errandsId") Long errandsId,
            @Param("erranderId") Long erranderId);
}
