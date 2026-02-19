package com.gorani.vroom.admin.users;

import lombok.Data;
import java.util.Date;

@Data
public class UserActivityVO {
    private String type;
    private String description;
    private Date occurredAt;
}
