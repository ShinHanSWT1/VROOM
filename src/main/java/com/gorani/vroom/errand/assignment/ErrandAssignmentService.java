package com.gorani.vroom.errand.assignment;

public interface ErrandAssignmentService {
    void requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId);
}
