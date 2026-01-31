package com.gorani.vroom.errand.assignment;
import org.springframework.web.multipart.MultipartFile;

public interface ErrandAssignmentService {
    Long requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId);

    void uploadCompleteProof(Long errandsId, Long roomId, Long runnerUserId, MultipartFile proofImage);
}


