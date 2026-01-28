package com.gorani.vroom.vroompay;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class VroomPayServiceImpl implements VroomPayService {

    private final RestTemplate restTemplate;

    @Value("${vroompay.api.key}")
    private String vroomPayApiKey;

    @Value("${vroompay.api.create-url}")
    private String vroomPayApiCreateUrl;

    @Override
    public Map<String, Object> getAccountStatus(Long userId) {
        // TODO: 계좌 상태 조회 API 경로 확인 후 구현 필요
        // 현재는 무조건 '연결 안 됨'으로 반환
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("linked", false); 
        return result;
    }

    @Override
    public Map<String, Object> linkAccount(Long userId, String username) {
        String url = vroomPayApiCreateUrl;
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);
        headers.set("x-api-key", vroomPayApiKey);

        // [재수정] VroomPay 서버에서 'nickname'으로 받으므로, 키 값을 'nickname'으로 전송
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("userId", userId);
        requestBody.put("nickname", username); // Key: nickname, Value: 닉네임

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

}
