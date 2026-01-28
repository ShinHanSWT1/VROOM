package com.gorani.vroom.vroompay;

import java.util.Map;

public interface VroomPayService {

    Map<String, Object> getAccountStatus(Long userId);

    Map<String, Object> linkAccount(Long userId, String username);

}
