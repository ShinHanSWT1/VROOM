package com.gorani.vroom.errand.assignment;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ErrandAssignmentMapper {

    Long selectOwnerUserId(@Param("errandsId") Long errandsId);
    Long selectErranderIdByUserId(@Param("userId") Long userId);
    boolean canChat(@Param("errandsId") Long errandsId);


    int updateErrandStatusWaitingToMatched(@Param("errandsId") Long errandsId);
    
    int updateErrandStatusToWaiting(@Param("errandsId") Long errandsId);

    int insertMatchedAssignment(@Param("userId") Long userId,
                                @Param("errandsId") Long errandsId,
                                @Param("erranderId") Long erranderId);

    int insertStatusHistory(@Param("errandsId") Long errandsId,
                            @Param("fromStatus") String fromStatus,
                            @Param("toStatus") String toStatus,
                            @Param("changedByType") String changedByType,
                            @Param("changedById") Long changedById);
}
