package com.gorani.vroom.main;

import lombok.Data;

@Data
public class MainReviewVO {
    private String reviewerName;
    private double rating;
    private String taskCategory;
    private String content;
}
