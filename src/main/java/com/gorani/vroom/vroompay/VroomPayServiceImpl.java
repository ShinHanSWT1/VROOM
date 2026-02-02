package com.gorani.vroom.vroompay;

import com.gorani.vroom.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class VroomPayServiceImpl implements VroomPayService {

    private final RestTemplate restTemplate = new RestTemplate();
    private final VroomPayMapper vroomPayMapper;
    private final NotificationService notificationService;

    @Value("${vroompay.api.key}")
    private String vroomPayApiKey;

    @Value("${vroompay.api.create-url}")
    private String vroomPayApiCreateUrl;

    @Value("${vroompay.api.status-url}")
    private String vroomPayApiStatusUrl;

    @Value("${vroompay.api.charge-url}")
    private String vroomPayApiChargeUrl;

    @Value("${vroompay.api.withdraw-url}")
    private String vroomPayApiWithdrawUrl;

    @Value("${vroompay.api.settle-url}")
    private String vroomPayApiSettleUrl;

    @Value("${vroompay.api.order-url}")
    private String vroomPayApiOrderUrl;

    @Value("${vroompay.api.hold-url}")
    private String vroomPayApiHoldUrl;

    @Override
    public Map<String, Object> getAccountStatus(Long userId) {
        String url = vroomPayApiStatusUrl.replace("{userId}", userId.toString());

        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);

            if (response.getBody() != null && !response.getBody().isEmpty()) {
                result.put("success", true);
                result.put("linked", true);
                result.put("account", response.getBody());
            } else {
                result.put("success", true);
                result.put("linked", false);
            }
        } catch (HttpClientErrorException.NotFound e) {
            result.put("success", true);
            result.put("linked", false);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "계좌 정보 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> linkAccount(Long userId, String nickname) {
        String url = vroomPayApiCreateUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", userId);
        requestBody.put("nickname", nickname);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            result.put("success", true);
            if (response.getBody() != null) {
                result.putAll(response.getBody());
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "계좌 연결에 실패했습니다: " + e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> charge(Long userId, BigDecimal amount, String memo) {
        String url = vroomPayApiChargeUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", userId);
        requestBody.put("amount", amount);
        if (memo != null) {
            requestBody.put("memo", memo);
        }

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            result.put("success", true);
            result.put("message", amount + "원이 충전되었습니다.");

            if (response.getBody() != null) {
                result.putAll(response.getBody());
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "충전에 실패했습니다: " + e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> withdraw(Long userId, BigDecimal amount, String memo) {
        String url = vroomPayApiWithdrawUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", userId);
        requestBody.put("amount", amount);
        if (memo != null) {
            requestBody.put("memo", memo);
        }

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            result.put("success", true);
            result.put("message", amount + "원이 출금되었습니다.");

            if (response.getBody() != null) {
                result.putAll(response.getBody());
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "출금에 실패했습니다: " + e.getMessage());
        }
        return result;
    }

    @Override
    public Map<String, Object> settleErrand(Long errandId, Long userId, Long erranderId, BigDecimal amount) {

        // 정산 완료하기 위해 orderId를 가져와야함
        Long orderId = vroomPayMapper.getPaymentIdForSettlement(errandId, erranderId);

        // 예외 처리: orderId가 없는 경우 처리 필요
        if (orderId == null) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "정산할 대기 상태의 주문(Payment)을 찾을 수 없습니다.");
            return errorResult;
        }

        String url = vroomPayApiSettleUrl.replace("{orderId}", orderId.toString());
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        HttpEntity<String> entity = new HttpEntity<>(headers);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("errandId", errandId);
        requestBody.put("payerId", userId);     // 보내는 사람 (User)
        requestBody.put("payeeId", erranderId); // 받는 사람 (Errander)
        requestBody.put("amount", amount);

//        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);


        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

            result.put("success", true);
            result.put("message", "정산이 완료되었습니다.");

            if (response.getBody() != null) {
                result.putAll(response.getBody());

                // TODO: 정산 완료에 따라 transaction에 추가
                // TODO: updateLocalBalance

                // 알림
                notificationService.send(
                        erranderId,
                        "PAY",
                        "심부름값을 받았습니다!(" + amount + "원)",
                        "/errander/mypage/pay"

                );

                log.info("정산 정보" + response.getBody());
            }
        } catch (Exception e) {
            log.error("정산 API 호출 실패", e);
            result.put("success", false);
            result.put("message", "정산 처리에 실패했습니다: " + e.getMessage());
        }
        return result;
    }

    // 주문서 생성
    @Transactional
    @Override
    public Map<String, Object> createAndHoldPaymentOrder(PaymentOrderVO payment) {

        String url = vroomPayApiOrderUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        // 전달할 값 저장
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", payment.getUserId());
        requestBody.put("amount", payment.getAmount());
        requestBody.put("errandsId", payment.getErrandsId());
        requestBody.put("merchantUid", payment.getMerchantUid());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        // 결과값 저장
        Map<String, Object> result = new HashMap<>();
        try {
            // API 호출
            ResponseEntity<PaymentOrderVO> response = restTemplate.exchange(url, HttpMethod.POST, entity, PaymentOrderVO.class);
            result.put("success", true);
            result.put("message", "주문서가 발급되었습니다");

            if (response.getBody() != null) {
                result.put("data", response.getBody());
                result.put("orderId", response.getBody().getId());
                // vroom의 payment에 저장
                vroomPayMapper.insertPaymentOrder(response.getBody());
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "출금에 실패했습니다: " + e.getMessage());
        }

        // payment 돈 바로 pending으로 상태 변화
        url = vroomPayApiHoldUrl.replace("{orderId}", result.get("orderId").toString());
        requestBody = new HashMap<>();
        requestBody.put("orderId", result.get("orderId").toString());
        HttpEntity<Map<String, Object>> httpEntity = new HttpEntity<>(requestBody, headers);

        try {
            ResponseEntity<PaymentOrderVO> response = restTemplate.exchange(url, HttpMethod.POST, entity, PaymentOrderVO.class);
            result.put("success", true);
            result.put("message", "PENDING으로 변경되었습니다");

            if (response.getBody() != null) {
                result.put("data", response.getBody());
                // 로컬 Payment에 status를 PENDING으로 업데이트
                vroomPayMapper.updatePaymentStatus(response.getBody().getId(), "PENDING");
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "출금에 실패했습니다: " + e.getMessage());
        }

        return result;


    }

    // 계좌 변경 이력 등록
    @Override
    public void insertWalletTransactions(WalletTransactionVO walletTransactionVO) {
        vroomPayMapper.insertWalletTransactions(walletTransactionVO);
    }

    // 계좌 변경 이력 조회
    @Override
    public List<WalletTransactionVO> getWalletTransactions(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        return vroomPayMapper.selectWalletTransactions(userId, offset, size);
    }

    // 계좌 변경 이력 총 개수
    @Override
    public int countWalletTransactions(Long userId) {
        return vroomPayMapper.countWalletTransactions(userId);
    }

    // 로컬 지갑 계좌 생성
    @Override
    public void insertWalletAccount(VroomPayVO vroomPayVO) {
        vroomPayMapper.insertWalletAccount(vroomPayVO);
    }

    // 로컬 지갑 계좌 조회
    @Override
    public VroomPayVO getWalletAccount(Long userId) {
        return vroomPayMapper.selectWalletAccount(userId);
    }

    // 로컬 지갑 계좌 잔액 업데이트
    @Override
    public void updateWalletAccount(VroomPayVO vroomPayVO) {
        vroomPayMapper.updateWalletAccount(vroomPayVO);
    }

}
