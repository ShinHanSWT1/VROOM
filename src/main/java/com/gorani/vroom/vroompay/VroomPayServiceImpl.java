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

@Service
@RequiredArgsConstructor
public class VroomPayServiceImpl implements VroomPayService {

    private final RestTemplate restTemplate = new RestTemplate();

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
}
