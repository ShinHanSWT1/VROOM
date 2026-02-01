package com.gorani.vroom.errand.assignment;

public interface ErrandAssignmentService {
    Long requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId);

    Long assignErranderByAdmin(Long errandsId, Long erranderId, Long adminId, String reason);
}
