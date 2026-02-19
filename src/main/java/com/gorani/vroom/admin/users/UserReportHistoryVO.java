package com.gorani.vroom.admin.users;

import lombok.Data;
import java.util.Date;

@Data
public class UserReportHistoryVO {
    private Long ticketId;
    private String type;
    private String status;
    private String reason;
    private Date createdAt;
}
