package com.gorani.vroom.admin.erranders;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminErrandersMapper {
    Map<String, Object> getSummary();

    List<Map<String, Object>> searchErranders(Map<String, Object> param);

    int countErranders(Map<String, Object> param);

    Map<String, Object> getErranderApprovalDetail(
            @Param("erranderId") Long erranderId
    );

    int updateErranderApprovalStatus(
            @Param("erranderId") Long erranderId,
            @Param("status") String status
    );

    int updateErranderActiveStatus(
            @Param("erranderId") Long erranderId,
            @Param("status") String status
    );

    Map<String, Object> getErranderDetail(
            @Param("erranderId") Long erranderId
    );

    Map<String, Object> getActivitySummary(
            @Param("erranderId") Long erranderId
    );

    List<Map<String, Object>> getRecentErrands(
            @Param("erranderId") Long erranderId,
            @Param("limit") int limit
    );

    List<Map<String, Object>> getRecentErrandsWithProof(
            @Param("erranderId") Long erranderId,
            @Param("limit") int limit
    );

    Map<String, Object> getSettlementSummary(
            @Param("erranderId") Long erranderId
    );

    double getErranderRatingAvg(
            @Param("erranderId") Long erranderId
    );

    List<Map<String, Object>> getRecentReviews(
            @Param("erranderId") Long erranderId,
            @Param("limit") int limit
    );

    String getAdminMemo(
            @Param("erranderId") Long erranderId
    );

    int updateAdminMemo(
            @Param("erranderId") Long erranderId,
            @Param("adminMemo") String adminMemo
    );

    List<Map<String, Object>> getDocuments(
            @Param("erranderId") Long erranderId
    );

    long getUserIdByErranderId(
            @Param("erranderId") Long erranderId
    );

    int updateDocumentStatus(
            @Param("erranderId") Long erranderId,
            @Param("status") String status
    );
}
