package com.gorani.vroom.notification;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/notification")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService service;

    // 안 읽은 개수 조회 (헤더 빨간점용)
    @GetMapping("/unread")
    public int getUnreadCount(HttpSession session) {
        // 세션에서 로그인한 유저 정보 가져오기
        UserVO user = (UserVO) session.getAttribute("loginSess");
        if (user == null) return 0;
        Long userId = user.getUserId();

        return service.getUnreadCount(userId);
    }

    // 알림 목록 조회 (종 눌렀을 때)
    @GetMapping("/list")
    public Map<String, Object> getList(HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("loginSess");
        if (user == null) return null;
        Long userId = user.getUserId();

        Map<String, Object> result = new HashMap<>();
        result.put("list", service.getMyList(userId));
        return result;
    }

    // 읽음 처리
    @PostMapping("/read/{id}")
    public String read(@PathVariable Long id) {
        service.readOne(id);
        return "success";
    }
}