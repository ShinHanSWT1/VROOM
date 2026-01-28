package com.gorani.vroom.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocketMessageBroker // STOMP 메시지 브로커 기능을 켠다(= STOMP 지원 시작)
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // ws 엔드포인트 (SockJS fallback 포함)
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 클라가 구독할 topic
        registry.enableSimpleBroker("/topic");

        // 클라 -> 서버로 보낼 prefix
        registry.setApplicationDestinationPrefixes("/app");
    }
}