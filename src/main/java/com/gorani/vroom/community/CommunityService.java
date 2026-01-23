package com.gorani.vroom.community;

import java.util.List;

public interface CommunityService {
    // 카테고리 목록 조회
    List<CategoryVO> getCategoryList();

    // 게시글 목록 조회 (필터링 포함)
    List<CommunityPostVO> getPostList(String dongCode, Long categoryId, String searchKeyword, Long startIdx);

    // 인기글 조회
    List<CommunityPostVO> getPopularPostList(String dongCode, String searchKeyword, Long startIdx);

    // 게시글 상세 데이터 조회
    CommunityPostVO getPostDetail(Long postId);

    // pagination 페이지 수 조회
    Long getPostCount(String dongCode, Long categoryId, String searchKeyword);


    // 댓글 수 조회
    Long getCommentCount(Long postId);

    // 게시글에 대한 댓글 조회
    List<CommunityCommentVO> getPostComments(Long postId);

    // 댓글 삽입
    boolean addComment(CommunityCommentVO commentVO);

    // 댓글 수정
    boolean updateComment(Long commentId, String content, Long userId);

    // 댓글 삭제
    boolean deleteComment(Long commentId, Long userId);

    // 조회수 증가
    void increaseViewCount(Long postId);

    // 좋아요 토글 (좋아요 했으면 취소, 안했으면 추가)
    boolean toggleLike(Long postId, Long userId);

    // 좋아요 여부 확인
    boolean isLiked(Long postId, Long userId);

    // 게시글 작성
    boolean createPost(CommunityPostVO communityPostVO);
}
