package com.gorani.vroom.errand.post;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ErrandImageVO {

    private Long imageId;
    private String imageUrl;
    private Integer sortOrder;
    private Timestamp registAt;
    private Long errandsId;
}