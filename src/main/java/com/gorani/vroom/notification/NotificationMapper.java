package com.gorani.vroom.notification;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface NotificationMapper {
    // 알림 생성
    void insertNotification(NotificationVO vo);

    // 안 읽은 알림 개수 조회 (빨간 점 표시용)
    int countUnread(Long userId);

    // 내 알림 목록 조회 (최신순)
    List<NotificationVO> selectMyNotifications(Long userId);

    // 알림 읽음 처리
    void updateReadStatus(Long notificationId);

    // 알림 전체 읽음 처리
    void updateAllRead(Long userId);
}