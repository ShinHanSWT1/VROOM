package com.gorani.vroom.vroompay;

import com.gorani.vroom.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
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

    @Value("${vroompay.api.match-url}")
    private String vroomPayApiMatchUrl;

    @Value("${vroompay.api.cancel-url}")
    private String vroomPayApiCancelUrl;

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
    @Transactional
    public Map<String, Object> settleErrand(Long errandId, Long userId, Long erranderId, BigDecimal amount) {

        // 정산 완료하기 위해 orderId를 가져와야함
        Long orderId = vroomPayMapper.getPaymentIdForSettlement(errandId, erranderId);
        log.info("정산 처리 paymentID: " + orderId);

        // 예외 처리: orderId가 없는 경우 처리 필요
        if (orderId == null) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "정산할 대기 상태의 주문(Payment)을 찾을 수 없습니다.");
            return errorResult;
        }

        String url = vroomPayApiSettleUrl.replace("{orderId}", orderId.toString());
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("x-api-key", vroomPayApiKey);

        HttpEntity<String> entity = new HttpEntity<>(headers);

//        Map<String, Object> requestBody = new HashMap<>();
//        requestBody.put("errandId", errandId);
//        requestBody.put("payerId", userId);     // 보내는 사람 (User)
//        requestBody.put("payeeId", erranderId); // 받는 사람 (Errander)
//        requestBody.put("amount", amount);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<PaymentOrderVO> response = restTemplate.exchange(url, HttpMethod.POST, entity, PaymentOrderVO.class);

            log.info("정산 로직 - " + response);
            result.put("success", true);
            result.put("message", "정산이 완료되었습니다.");

            PaymentOrderVO resBody = response.getBody();
//            log.info("정산 로직 - " + resBody);
            if (resBody != null) {
                result.put("data", resBody);

                // 정산 완료에 따라 TRANSACTION PAYOUT
                WalletTransactionVO transactionVO = new WalletTransactionVO();
                transactionVO.setPaymentId(resBody.getId());
                transactionVO.setAmount(resBody.getAmount());
                transactionVO.setTxnType("PAYOUT");
                transactionVO.setErrandId(resBody.getErrandsId());
                transactionVO.setErranderId(resBody.getErranderId());

                insertWalletTransactions(transactionVO);

                // WALLET_ACCOUNT
                Long erranderUserId = vroomPayMapper.getErranderUserIdByErranderId(resBody.getErranderId());
                syncWalletAccount(erranderUserId);

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
        headers.setContentType(MediaType.APPLICATION_JSON);
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
            ResponseEntity<PaymentOrderVO> response = restTemplate.exchange(url, HttpMethod.POST, httpEntity, PaymentOrderVO.class);
            result.put("success", true);
            result.put("message", "PENDING으로 변경되었습니다");
            PaymentOrderVO resBody = response.getBody();

            if (resBody != null) {
                result.put("data", resBody);

                // vroom.Payment에 status = PENDING으로 업데이트
                vroomPayMapper.updatePaymentStatus(resBody.getId(), "PENDING");

                // TRANSACTION 에 HOLD 추가
                WalletTransactionVO transactionVO = new WalletTransactionVO();
                transactionVO.setPaymentId(resBody.getId());
                transactionVO.setAmount(resBody.getAmount());
                transactionVO.setTxnType("HOLD");
                transactionVO.setErrandId(resBody.getErrandsId());
                transactionVO.setUserId(resBody.getUserId());

                insertWalletTransactions(transactionVO);

                // WALLET_ACOCOUNT 정합성 유지
                syncWalletAccount(resBody.getUserId());

            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "출금에 실패했습니다: " + e.getMessage());
        }

        return result;


    }

    // payment 취소로 업데이트
    @Override
    @Transactional
    public Map<String, Object> cancelPayment(Long errandsId) {
        // orderId를 구해야함
        Long orderId = vroomPayMapper.getOrderIdByErrandsId(errandsId);

        String url = vroomPayApiCancelUrl.replace("{orderId}", orderId.toString());
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("x-api-key", vroomPayApiKey);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(headers);

        Map<String, Object> result = new HashMap<>();
        try {
            // API 호출
            ResponseEntity<PaymentOrderVO> response = restTemplate.exchange(url, HttpMethod.POST, entity, PaymentOrderVO.class);
            result.put("success", true);
            result.put("message", "정상 업데이트 되었습니다");

            PaymentOrderVO resBody = response.getBody();

            if (resBody != null) {
                result.put("data", resBody);
                result.put("orderId", resBody.getId());

                // 정합성을 위해 로컬 payment도 업데이트
                int res = vroomPayMapper.updatePaymentStatus(orderId, "CANCELED");

                // TRANSACTION RELEASE 추가
                WalletTransactionVO transactionVO = new WalletTransactionVO();
                transactionVO.setPaymentId(resBody.getId());
                transactionVO.setAmount(resBody.getAmount());
                transactionVO.setTxnType("RELEASE");
                transactionVO.setErrandId(resBody.getErrandsId());
                transactionVO.setUserId(resBody.getUserId());

                insertWalletTransactions(transactionVO);

                // 주문서 재생성
//                PaymentOrderVO paymentVO = vroomPayMapper.getPaymentById(orderId);  // 이전 주문서
                PaymentOrderVO newPaymentVO = new PaymentOrderVO();                 // 새 주문서 생성
                newPaymentVO.setErrandsId(resBody.getErrandsId());
                newPaymentVO.setUserId(resBody.getUserId());
                newPaymentVO.setMerchantUid("ORDER_" + errandsId + "_" + LocalDateTime.now());
                newPaymentVO.setAmount(resBody.getAmount());
                createAndHoldPaymentOrder(newPaymentVO);

                // WALLET


            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "출금에 실패했습니다: " + e.getMessage());
        }

        return result;

    }

    // payment erranderId 업데이트
    @Override
    @Transactional
    public Map<String, Object> updatePaymentErranderMatched(Long errandsId, Long erranderId) {
        log.info("심부름({}) 매칭됨: {}", errandsId, erranderId);
        // orderId를 구해야함
        Long orderId = vroomPayMapper.getOrderIdByErrandsId(errandsId);
        Long erranderUserId = vroomPayMapper.getErranderUserIdByErranderId(erranderId);

        String url = vroomPayApiMatchUrl.replace("{orderId}", orderId.toString());
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("x-api-key", vroomPayApiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("erranderUserId", erranderUserId);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        log.info("심부름 매칭 entity - {}", entity);
        Map<String, Object> result = new HashMap<>();
        try {
            // API 호출
            ResponseEntity<PaymentOrderVO> response = restTemplate.exchange(url, HttpMethod.POST, entity, PaymentOrderVO.class);
            result.put("success", true);
            result.put("message", "정상 업데이트 되었습니다");

            log.info("매칭 후 PAYMENT 업데이트 - {}", response);

            if (response.getBody() != null) {
                result.put("data", response.getBody());
                result.put("orderId", response.getBody().getId());

                // 정합성을 위해 로컬 payment도 업데이트
                int res = vroomPayMapper.updatePaymentErranderId(orderId, erranderId);

            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "업데이트 실패했습니다: " + e.getMessage());
        }

        log.info("심부름 매칭 PAYMENT 결과 - {}", result);
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
    @Transactional
    public int updateWalletAccount(VroomPayVO vroomPayVO) {
        int result = vroomPayMapper.updateWalletAccount(vroomPayVO);
        log.info("지갑 업데이트: " + vroomPayVO + " / " + result);

        return result;
    }

    @Override
    @Transactional
    public int syncWalletAccount(Long userId) {
        Map<String, Object> data = getAccountStatus(userId);
        log.info("페이 계좌: " + data);

        if (Boolean.TRUE.equals(data.get("success")) && data.get("account") != null) {
            Map<String, Object> account = (Map<String, Object>) data.get("account");

            VroomPayVO payVO = new VroomPayVO();
            payVO.setUserId(Long.parseLong(String.valueOf(account.get("userId"))));
            payVO.setBalance(new BigDecimal(String.valueOf(account.get("balance"))));
            payVO.setAvailBalance(new BigDecimal(String.valueOf(account.get("availBalance"))));
            payVO.setRealAccount(account.get("realAccount").toString());

            // 지갑 업데이트
            return updateWalletAccount(payVO);
        }
        return 0;
    }

}
