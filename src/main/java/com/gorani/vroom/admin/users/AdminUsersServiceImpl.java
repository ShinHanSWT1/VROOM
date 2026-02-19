package com.gorani.vroom.admin.users;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Primary
public class AdminUsersServiceImpl implements AdminUsersService {

    @Autowired
    private AdminUsersMapper mapper;

    @Override
    public Map<String, Object> getSummary() {
        return mapper.getSummary();
    }

    @Override
    public Map<String, Object> searchUsers(String keyword, String status, String role, Integer reportCount, int page) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("status", status);
        param.put("role", role);
        param.put("reportCount", reportCount);
        param.put("limit", pageSize);
        param.put("offset", offset);

        List<Map<String, Object>> userList = mapper.searchUsers(param);
        int totalCount = mapper.countUsers(param);

        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((page - 1) / 10) * 10 + 1;
        int endPage = Math.min(startPage + 9, totalPage);

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("pageSize", pageSize);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("userList", userList);
        dataMap.put("totalCount", totalCount);
        dataMap.put("pageInfo", pageInfo);

        return dataMap;
    }

    @Override
    public void updateUserStatus(Map<String, Object> params) {
        String status = (String) params.get("status");

        // 일시정지인 경우 추가 로직
        if ("SUSPENDED".equals(status)) {
            Map<String, Object> extraData = (Map<String, Object>) params.get("extraData");

            if (extraData != null && extraData.containsKey("days")) {
                int days = Integer.parseInt(String.valueOf(extraData.get("days")));
                String reason = (String) extraData.get("reason");

                // 종료일 계산 (현재 시간 + 일수)
                LocalDateTime endDate = LocalDateTime.now().plusDays(days);

                // 파라미터에 추가
                params.put("suspensionEndAt", endDate);
                params.put("suspensionNote", reason);
            }
        } else {
            // 정상이나 영구정지로 바꿀 땐 정지 정보를 초기화
            params.put("suspensionEndAt", null);
            params.put("suspensionNote", null);
        }

        // DB 업데이트 호출
        mapper.updateUserStatus(params);
    }

    // 사용자 상세 페이지 정보 조회
    @Override
    public AdminUserDetailDTO getUserDetail(Long userId) {
        // 기본 정보 + 통계 조회
        AdminUserDetailDTO detail = mapper.getUserInfoDetail(userId);

        if (detail != null) {
            // 신고 이력 리스트 조회 및 저장
            List<UserReportHistoryVO> reports = mapper.getUserReportHistory(userId);
            detail.setReportHistory(reports);

            // 최근 활동 리스트 조회 및 저장
            List<UserActivityVO> activities = mapper.getUserActivityHistory(userId);
            detail.setActivityHistory(activities);
        }

        return detail;
    }

    // 관리자 메모 저장
    @Override
    public void updateAdminMemo(Long userId, String memo) {
        mapper.updateAdminMemo(userId, memo);
    }
}
