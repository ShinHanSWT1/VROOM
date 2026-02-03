package com.gorani.vroom.errand.review;

public interface ReviewService {
    void writeReview(Long errandsId, Long reviewerUserId, int rating, String comment);
    
    boolean existsReview(Long errandsId, Long reviewerUserId);
}