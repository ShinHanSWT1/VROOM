package com.gorani.vroom.errander.profile;


import lombok.Data;

//부름이 요약정보에 대한 VO
//이번 달 총 수익 관련 통계 데이터

@Data
public class ErranderProfileVO {

    // 식별
    private Long userId; // 사용자 아이디
    private Long erranderId; // 부름이 아이디

    // MEMBERS 테이블에서 가져올 정보
    private String nickname; // 닉네임
    private String profileImage; // 프로필 이미지
    private Double mannerTemp; // 매너온도 (manner_score)

    // 노란색 바 정보
    private  Double completeRate; // 완료률

    // 서브쿼리로 계산할 통계
    private int inProgressCount; // 수행 중
    private int completedCount; // 완료
    private Long thisMonthEarning; // 이번 달 돈


    // 라이더 등급
    private String grade;
    // 화면에 등급 이름 출력 할거
    private String memberTypeLabel;

    private String approvalStatus; // 인증 상태 (PENDING 승인 대기 , APPROVED 승인 완료 , REJECTED 승인 거절)
    private String activeStatus; // 활성 상태 (ACTIVE 현재 활동 중, INACTIVE 현재 비활성)


    // 평균 평점 구하기
    private Double ratingAvg; // 평균 평점
    private int reviewCount; // 총 리뷰 개수


    private String dongCode1; // 동네1
    private String dongCode2; // 동네2

}
