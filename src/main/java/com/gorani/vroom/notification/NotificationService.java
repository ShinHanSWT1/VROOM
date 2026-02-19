package com.gorani.vroom.notification;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationMapper mapper;

    /**
     * 알림 전송 (이 메서드를 다른 서비스에서 호출하세요)
     * @param userId 받는 사람 ID
     * @param type 알림 유형 (SETTLEMENT, CHAT 등)
     * @param message 알림 메시지
     * @param url 클릭 시 이동할 페이지 (없으면 null)
     */
    public void send(Long userId, String type, String message, String url) {
        NotificationVO vo = new NotificationVO();
        vo.setUserId(userId);
        vo.setType(type);
        vo.setMessage(message);
        vo.setUrl(url);
        mapper.insertNotification(vo);
    }

    public int getUnreadCount(Long userId) {
        return mapper.countUnread(userId);
    }

    public List<NotificationVO> getMyList(Long userId) {
        return mapper.selectMyNotifications(userId);
    }

    public void readOne(Long notificationId) {
        mapper.updateReadStatus(notificationId);
    }

    public void readAll(Long userId) {
        mapper.updateAllRead(userId);
    }
}