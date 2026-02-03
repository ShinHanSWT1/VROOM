package com.gorani.vroom.errand.assignment;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ErrandAssignmentMapper {

    Long selectOwnerUserId(@Param("errandsId") Long errandsId);
    Long selectErranderIdByUserId(@Param("userId") Long userId);
    boolean canChat(@Param("errandsId") Long errandsId);
    String selectErrandStatus(@org.apache.ibatis.annotations.Param("errandsId") Long errandsId);

    int updateErrandStatusToWaiting(@Param("errandsId") Long errandsId);

    int updateErrandStatusMatchedToConfirmed1(@Param("errandsId") Long errandsId);
    int updateErrandStatusConfirmed1ToConfirmed2(@Param("errandsId") Long errandsId);
    int updateErrandStatusMatchedToWaiting(@Param("errandsId") Long errandsId);

    int insertMatchedAssignment(
            @Param("adminId") Long adminId,
    	    @Param("userId") Long userId,
    	    @Param("errandsId") Long errandsId,
    	    @Param("erranderId") Long erranderId,
            @Param("type") String type,
            @Param("status") String status,
            @Param("reason") String reason
    	);

    int insertStatusHistory(@Param("errandsId") Long errandsId,
                            @Param("fromStatus") String fromStatus,
                            @Param("toStatus") String toStatus,
                            @Param("changedByType") String changedByType,
                            @Param("changedById") Long changedById);

    int validateRunnerAndStatus(@Param("errandsId") Long errandsId,
            @Param("erranderUserId") Long erranderUserId);

	int insertCompletionProof(@Param("errandsId") Long errandsId,
            @Param("erranderId") Long erranderId,
            @Param("fileUrl") String fileUrl);

	Long selectLastInsertedProofId();

	int insertProofMedia(@Param("proofId") Long proofId, @Param("fileUrl") String fileUrl);

    String getErranderActiveStatus(@Param("erranderId") Long erranderId);

    Long selectUserIdByErranderId(@Param("erranderId") Long erranderId);

    int countMatchedByErrandAndErrander(@Param("errandsId") Long errandsId, @Param("erranderId") Long erranderId);

    int existsCanceledAssignment(@Param("errandsId") Long errandsId, @Param("erranderId") Long erranderId);

    int updateAssignmentStatusMatchedToCanceled(@Param("errandsId") Long errandsId, @Param("erranderId") Long erranderId);

    int insertRejectHistory(@Param("errandsId") Long errandsId, @Param("erranderId") Long erranderId);

    int existsRejectHistory(@Param("errandsId") Long errandsId, @Param("erranderId") Long erranderId);

    Long selectMatchedErranderIdByErrandsId(@Param("errandsId") Long errandsId);

    int updateErrandWaitingToMatchedWithErrander(@Param("errandsId") Long errandsId, @Param("erranderId") Long erranderId);

    int updateErrandMatchedToWaitingClearErrander(@Param("errandsId") Long errandsId);
}