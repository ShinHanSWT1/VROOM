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

    @Override
    public Map<String, Object> getAccountStatus(Long userId) {
        // URL의 {userId}를 실제 값으로 치환
        String url = vroomPayApiStatusUrl.replace("{userId}", userId.toString());
        
        HttpHeaders headers = new HttpHeaders();
        headers.set("x-api-key", vroomPayApiKey);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        Map<String, Object> result = new HashMap<>();
        try {
            // GET 요청 전송
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
            
            // 응답이 있고, 내용이 비어있지 않다면 연결된 것으로 간주
            if (response.getBody() != null && !response.getBody().isEmpty()) {
                result.put("success", true);
                result.put("linked", true);
                result.put("account", response.getBody()); // 계좌 정보(잔액 등) 포함
            } else {
                result.put("success", true);
                result.put("linked", false);
            }
        } catch (HttpClientErrorException.NotFound e) {
            // 404 에러는 계좌가 없는 경우이므로 정상적인 '미연결' 상태로 처리
            result.put("success", true);
            result.put("linked", false);
        } catch (Exception e) {
            // 그 외 에러는 실제 오류
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
        // memo는 필요하다면 추가
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
}
