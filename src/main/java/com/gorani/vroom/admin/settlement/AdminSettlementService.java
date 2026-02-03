package com.gorani.vroom.admin.settlement;

import com.gorani.vroom.admin.issue.AdminIssueMapper;
import com.gorani.vroom.vroompay.VroomPayService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class AdminSettlementService {

    @Autowired
    private AdminSettlementMapper mapper;

    @Autowired
    private VroomPayService vroomPayService;

    Map<String, Object> getKpi() {
        return mapper.getSummary();
    }

    // 정산 목록 검색
    public Map<String, Object> getSettlementList(int page, String keyword, String status, String startDate, String endDate) {
        int size = 10; // 페이지당 개수
        int offset = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("status", "WAITING".equals(status) ? "CONFIRMED2" : status); // 화면의 WAITING을 DB의 CONFIRMED2로 변환
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("limit", size);
        params.put("offset", offset);

        // 1. DB 조회
        List<AdminSettlementVO> list = mapper.selectSettlementList(params);
        int totalCount = mapper.countSettlements(params);

        // 2. 화면용 데이터 가공
        List<Map<String, Object>> displayList = new ArrayList<>();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (AdminSettlementVO vo : list) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", vo.getErrandId());
            item.put("errandId", vo.getErrandId());
            item.put("errandTitle", vo.getErrandTitle()); // 제목도 툴팁 등으로 보여주면 좋음

            // [추가] 요청자 닉네임
            item.put("requester", vo.getRequesterNickname());

            // [기존] 부름이 닉네임
            item.put("errander", vo.getErranderNickname());

            // [추가] 정산 예정 금액 (사용자 결제 금액)
            item.put("orderAmount", vo.getOrderAmount());

            // [기존] 실제 정산 금액 (지급 예정 금액)
            item.put("settlementAmount", vo.getSettlementAmount());

            // 날짜 포맷팅
            if (vo.getRequestDate() != null) {
                item.put("date", vo.getRequestDate().format(dtf));
            } else {
                item.put("date", "-");
            }

            // 상태 변환
            String dbStatus = vo.getStatus();
            if ("CONFIRMED2".equals(dbStatus)) {
                item.put("status", "WAITING");
            } else {
                item.put("status", dbStatus);
            }

            item.put("reason", vo.getMemo() != null ? vo.getMemo() : "-");
            displayList.add(item);
        }

//            심부름/정산 정보 =
//            AdminSettlementVO
//            (errandId=8, assignmentId=9, paymentId=10,
//            errandTitle=바선생 잡아주세요,
//            requesterNickname=분당고라니, memo=null,
//            erranderNickname=잔망루피, erranderUserId=4,
//            erranderProfileId=2, orderAmount=1000.00,
//            settlementAmount=1000.00, status=COMPLETED,
//            requestDate=2026-02-03T18:14:18,
//            settledDate=2026-02-03T18:15:05)


        // 3. 페이지네이션 정보 계산
        int totalPages = (int) Math.ceil((double) totalCount / size);
        int pageBlock = 5;
        int startPage = ((page - 1) / pageBlock) * pageBlock + 1;
        int endPage = startPage + pageBlock - 1;
        if (endPage > totalPages) endPage = totalPages;

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("totalPage", totalPages);

        Map<String, Object> result = new HashMap<>();
        result.put("settlementList", displayList);
        result.put("pageInfo", pageInfo);
        result.put("totalCount", totalCount);

        return result;
    }

    // 상세 정보 조회
    public Map<String, Object> getSettlementDetail(Long errandId) {
        Map<String, Object> detail = mapper.getSettlementDetail(errandId);

        // 상태 코드 변환 (View용)
        if (detail != null && "CONFIRMED2".equals(detail.get("status"))) {
            detail.put("status", "WAITING"); // 화면엔 '정산 대기'로 표시
        }

        return detail;
    }

    // 정산 처리(일단 보류는 제외한다)
    // COMPLETE : 부름이 전체 정산, 일부 정산
    // REJECT : 사용자에게 100프로 환불
    @Transactional
    public void processSettlement(Long errandId, String action, String memo, BigDecimal amount) {

        // 현재 정보 조회 (금액 및 ID 확인용)
        Map<String, Object> detail = mapper.getSettlementDetail(errandId);
        if (detail == null) {
            throw new IllegalArgumentException("존재하지 않는 심부름입니다.");
        }

        log.info("관리자 정산 처리 - 현재 정보={}", detail);

        String dbStatus;
        // 정산 확정
        if ("COMPLETED".equals(action)) {
            dbStatus = "COMPLETED";

            // Map에서 꺼낼 때 타입 캐스팅 주의 (BigDecimal 등)
            //{errandId=26, errandContent=제발여, completedAt=2026-02-04 00:17:55.0, requesterId=2, requesterNickname=군침이사악Dono, proofImageUrl=/uploads/proof/da940e2aa1d846e7b7a672b1baa043da.png, orderAmount=20000.00, erranderUserId=1, erranderNickname=릉부릉부, erranderProfileId=1, requestDate=2026-02-04 00:17:55.0, errandTitle=티엔미미 줄서주세요 진짜 진심으로., settlementAmount=20000.00, status=CONFIRMED2}

            Long userId = Long.parseLong(detail.get("requesterId").toString());
            Long erranderId = Long.parseLong(detail.get("erranderProfileId").toString());

            // VroomPayService 호출
            Map<String, Object> payResult = vroomPayService.settleErrandManual(
                    errandId,
                    userId,
                    erranderId,
                    amount
            );

            log.info("관리자 수동 정산 - 결과={}", payResult);
            if (!Boolean.TRUE.equals(payResult.get("success"))) {
                throw new RuntimeException("정산 지급 실패: " + payResult.get("message"));
            }

        } else if ("HOLD".equals(action)) {
            // [보류]
            dbStatus = "HOLD";
        } else if ("REJECTED".equals(action)) {
            // [거절] -> 100프로 사용자에게 환불
            dbStatus = "REJECTED";
            // TODO: 거절 시 예치금 환불 로직이 필요하다면 여기에 추가
        } else {
            throw new IllegalArgumentException("잘못된 요청입니다.");
        }

        // 2. DB 상태 업데이트
//        mapper.updateSettlementStatus(errandId, dbStatus, memo);
    }
}
