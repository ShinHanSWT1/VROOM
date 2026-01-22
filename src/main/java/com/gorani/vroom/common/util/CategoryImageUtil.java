package com.gorani.vroom.common.util;

public class CategoryImageUtil {

    public static String getDefaultImage(Long categoryId) {
        if (categoryId == null) {
        	return "/static/img/category/noimage.png";
        }

        switch (categoryId.intValue()) {
            case 1: // 배달/장보기
                return "/static/img/category/delivery.png";
            case 2: // 청소/집안일
                return "/static/img/category/cleaning.png";
            case 3: // 벌레퇴치
                return "/static/img/category/bug.png";
            case 4: // 설치/조립
                return "/static/img/category/install.png";
            case 5: // 동행/돌봄
                return "/static/img/category/care.png";
            case 6: // 줄서기/예약
                return "/static/img/category/queue.png";
            case 7: // 서류/비즈니스
                return "/static/img/category/document.png";
            default:
                return "/static/img/category/default.png";
        }
    }
}
