package com.gorani.vroom.admin.erranders;


import java.util.Map;

public interface AdminErrandersService {
    Map<String, Object> getSummary();

    Map<String, Object> searchErranders(String keyword, String approveStatus, String activeStatus, Integer reviewScope, int page);

    Map<String, Object> getErranderApprovalDetail(Long id);

    Map<String, Object> approveErrander(Long erranderId, String status, String reason);

    Map<String, Object> changeErranderStatus(Long erranderId, String status);

    Map<String, Object> getDetailSummary(Long erranderId);   // 부름이 상세 - 기본 정보 + 활동 요약

    Map<String, Object> getDetailAllInfo(Long erranderId, int limit);   // 부름이 상세 - 수행 심부름 목록, 정산내역, 리뷰평점, 관리자메모, 제출서류

    Map<String, Object> saveAdminMemo(Long erranderId, String text);
}
