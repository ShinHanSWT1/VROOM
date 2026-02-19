package com.gorani.vroom.errand.review;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReviewMapper {

    int existsReview(@Param("errandsId") Long errandsId,
                     @Param("reviewerUserId") Long reviewerUserId);

    int insertReview(@Param("errandsId") Long errandsId,
                     @Param("rating") int rating,
                     @Param("comment") String comment,
                     @Param("reviewerUserId") Long reviewerUserId,
                     @Param("revieweeUserId") Long revieweeUserId);
}
