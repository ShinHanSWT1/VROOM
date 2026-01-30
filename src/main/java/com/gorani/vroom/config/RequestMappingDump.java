package com.gorani.vroom.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;
import org.springframework.context.event.ContextRefreshedEvent;

@Component
public class RequestMappingDump {

    @Autowired
    private RequestMappingHandlerMapping handlerMapping;

    @EventListener(ContextRefreshedEvent.class)
    public void dump() {
        System.out.println("===== [MAPPING DUMP START] =====");
        handlerMapping.getHandlerMethods().forEach((info, method) -> {
            String s = info.toString();
            // errand/chat 관련만 필터
            if (s.contains("/errand/chat")) {
                System.out.println("[MAPPING] " + s + " -> " + method);
            }
        });
        System.out.println("===== [MAPPING DUMP END] =====");
    }
}
