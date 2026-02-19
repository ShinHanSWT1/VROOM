package com.gorani.vroom.user.auth;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Component
public class KakaoOAuthClient {

    // =========================
    // OAuth 설정 값 (외부 분리)
    // =========================

    @Value("${kakao.client-id}")
    private String clientId;

    @Value("${kakao.client-secret}")
    private String clientSecret;

    // =========================
    // redirectUri 동적 생성
    // =========================

    public String buildRedirectUri(HttpServletRequest request) {
        return request.getScheme() + "://"
                + request.getServerName() + ":"
                + request.getServerPort()
                + "/vroom/auth/kakao/callback";
    }

    // =========================
    // 1️⃣ 카카오 로그인 URL 생성
    // =========================
    public String getKakaoAuthUrl(String redirectUri) {
        return "https://kauth.kakao.com/oauth/authorize"
                + "?response_type=code"
                + "&client_id=" + clientId
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8);
    }

    // ==================================================
    // 2️⃣ 인가 코드(code) → access_token → 사용자 정보
    // ==================================================
    public KakaoUserInfo getUserInfo(String code, String redirectUri) {

        try {
            // -----------------------------
            // 2-1. access_token 요청
            // -----------------------------
            String tokenUrl = "https://kauth.kakao.com/oauth/token";
            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            String body =
                    "grant_type=authorization_code"
                            + "&client_id=" + clientId
                            + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                            + "&code=" + code;

            if (clientSecret != null && !clientSecret.isBlank()) {
                body += "&client_secret=" + clientSecret;
            }

            HttpEntity<String> tokenRequest = new HttpEntity<>(body, headers);

            ResponseEntity<Map> tokenResponse =
                    restTemplate.postForEntity(tokenUrl, tokenRequest, Map.class);

            // ✅ 최소단위 방어 ① access_token null 체크
            Map tokenBody = tokenResponse.getBody();
            if (tokenBody == null || tokenBody.get("access_token") == null) {
                throw new RuntimeException("카카오 토큰 발급 실패: access_token 없음");
            }

            String accessToken = (String) tokenBody.get("access_token");

            // -----------------------------
            // 2-2. 사용자 정보 요청
            // -----------------------------
            HttpHeaders userHeaders = new HttpHeaders();
            userHeaders.setBearerAuth(accessToken);

            HttpEntity<Void> userRequest = new HttpEntity<>(userHeaders);

            ResponseEntity<Map> userResponse =
                    restTemplate.exchange(
                            "https://kapi.kakao.com/v2/user/me",
                            HttpMethod.GET,
                            userRequest,
                            Map.class
                    );

            // ✅ 최소단위 방어 ② body / id null 체크
            Map bodyMap = userResponse.getBody();
            if (bodyMap == null || bodyMap.get("id") == null) {
                throw new RuntimeException("카카오 유저 조회 실패: id 없음");
            }

            // -----------------------------
            // 2-3. 응답 파싱
            // -----------------------------
            String id = String.valueOf(bodyMap.get("id"));

            Map kakaoAccount = (Map) bodyMap.get("kakao_account");
            Map profile = kakaoAccount != null ? (Map) kakaoAccount.get("profile") : null;

            String email = kakaoAccount != null ? (String) kakaoAccount.get("email") : null;
            String nickname = profile != null ? (String) profile.get("nickname") : null;

            KakaoUserInfo userInfo = new KakaoUserInfo();
            userInfo.setId(id);
            userInfo.setEmail(email);
            userInfo.setNickname(nickname);

            return userInfo;

        }
        // ✅ 최소단위 방어 ③ 카카오 API 400/401/500 처리
        catch (RestClientResponseException e) {
            throw new RuntimeException(
                    "카카오 API 호출 실패: HTTP " + e.getRawStatusCode(), e
            );
        }
        // 그 외 (NPE, 파싱 오류 등)
        catch (Exception e) {
            throw new RuntimeException("카카오 로그인 처리 중 오류", e);
        }
    }
}