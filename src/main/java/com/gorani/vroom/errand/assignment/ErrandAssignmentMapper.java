package com.gorani.vroom.errand.assignment;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ErrandAssignmentMapper {

    Long selectOwnerUserId(@Param("errandsId") Long errandsId);
    Long selectErranderIdByUserId(@Param("userId") Long userId);
    boolean canChat(@Param("errandsId") Long errandsId);
    String selectErrandStatus(@org.apache.ibatis.annotations.Param("errandsId") Long errandsId);



    int updateErrandStatusWaitingToMatched(@Param("errandsId") Long errandsId);
    int updateErrandStatusToWaiting(@Param("errandsId") Long errandsId);
    
    int updateErrandStatusMatchedToConfirmed1(@Param("errandsId") Long errandsId);
    int updateErrandStatusConfirmed1ToConfirmed2(@Param("errandsId") Long errandsId);
    int updateErrandStatusMatchedToWaiting(@Param("errandsId") Long errandsId);

    int insertMatchedAssignment(
    	    @org.apache.ibatis.annotations.Param("userId") Long userId,
    	    @org.apache.ibatis.annotations.Param("errandsId") Long errandsId,
    	    @org.apache.ibatis.annotations.Param("erranderId") Long erranderId
    	);

    int insertStatusHistory(@Param("errandsId") Long errandsId,
                            @Param("fromStatus") String fromStatus,
                            @Param("toStatus") String toStatus,
                            @Param("changedByType") String changedByType,
                            @Param("changedById") Long changedById);
    
    int validateRunnerAndStatus(@Param("errandsId") Long errandsId,
            @Param("runnerUserId") Long runnerUserId);

    int insertProof(Long errandsId, Long runnerUserId, Long roomId, String filePath);

    int updateStatusConfirmed1ToConfirmed2(Long errandsId);

}