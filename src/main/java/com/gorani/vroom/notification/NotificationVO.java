package com.gorani.vroom.notification;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class NotificationVO {
    private Long notificationId;
    private Long userId;
    private String type;
    private String message;
    private String url;
    private Boolean isRead;
    private Timestamp createdAt;

}