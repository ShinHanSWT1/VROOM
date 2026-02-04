package com.gorani.vroom.errand.assignment;
import org.springframework.web.multipart.MultipartFile;

public interface ErrandAssignmentService {
    Long requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId);

    String uploadCompleteProof(Long errandsId, Long roomId, Long erranderUserId, MultipartFile proofImage);
    
    Long createCompletionProof(Long errandsId, Long erranderId, String fileUrl);
    Long assignErranderByAdmin(Long errandsId, Long erranderId, Long adminId, String reason);
    boolean isMatchedErrander(Long errandsId, Long userId);
    
    boolean isCanceledErrander(Long errandsId, Long userId);
    
    void rejectErrander(Long errandsId, Long erranderId, Long changedByUserId);
    
    Long getMatchedErranderId(Long errandsId);
    Long getErranderIdByUserId(Long userId);
}