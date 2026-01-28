package com.gorani.vroom.vroompay;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class VroomPayServiceImpl implements VroomPayService {

    private final RestTemplate restTemplate;

    @Value("${vroompay.api.url}")
    private String vroomPayApiUrl;

    @Value("${vroompay.api.key}")
    private String vroomPayApiKey;

    @Value("${vroompay.api.create-url}")
    private String vroomPayApiCreateUrl;

    @Value("${vroompay.api.charge-url}")
    private String vroomPayApiChargeUrl;

    @Value("${vroompay.api.withdraw-url}")
    private String vroomPayApiWithdrawUrl;

    @Override
    public Map<String, Object> getAccountStatus(Long userId) {
        String url = vroomPayApiUrl + "/users/" + userId;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
            result.put("success", true);
            if (response.getBody() != null) {
                result.put("linked", true);
                result.put("account", response.getBody());
            } else {
                result.put("linked", false);
            }
        } catch (HttpClientErrorException.NotFound e) {
            result.put("success", true);
            result.put("linked", false);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "계좌 정보 조회 중 오류가 발생했습니다.");
        }
        return result;
    }

    @Override
    public Map<String, Object> linkAccount(Long userId, String username) {
        String url = vroomPayApiCreateUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        // 임시 랜덤 계좌번호 생성
        String randomAccountNumber = "3333-" + String.format("%02d", new Random().nextInt(100)) + "-" + String.format("%06d", new Random().nextInt(1000000));

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", userId);
        requestBody.put("username", username);
        requestBody.put("realAccount", randomAccountNumber);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            result.put("success", true);
            result.put("account", response.getBody());
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
        requestBody.put("memo", memo); // 은행 이름 등

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        Map<String, Object> result = new HashMap<>();
        try {
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
            // VroomPay 서버가 성공 시 업데이트된 계좌 정보를 반환한다고 가정
            result.put("success", true);
            result.put("message", amount + "원이 충전되었습니다.");
            
            // 응답에 잔액 정보가 포함되어 있다면 갱신
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
    public Map<String, Object> withdraw(Long userId, BigDecimal amount) {
        String url = vroomPayApiWithdrawUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", userId);
        requestBody.put("amount", amount);

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

    // TODO: VroomPay 연동 후 재구현 필요
    @Override
    public Map<String, Object> getTransactionHistory(Long userId, int page, int size) {
        // 이 로직은 VroomPay API의 거래 내역 조회 기능을 호출하도록 재구현되어야 합니다.
        return null;
    }
}
