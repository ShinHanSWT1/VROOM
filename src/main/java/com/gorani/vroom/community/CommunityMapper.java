package com.gorani.vroom.community;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommunityMapper {
    // 카테고리 목록 조회
    List<CategoryVO> selectCategoryList();

    // 게시글 목록 조회(카테고리 필터 추가)
    List<CommunityPostVO> selectPostList(
            @Param("dongCode") String dongCode,
            @Param("categoryId") Long categoryId,
            @Param("searchKeyword") String searchKeyword,
            @Param("startIdx") Long startIdx
    );

    // 인기 게시글 조회
    List<CommunityPostVO> selectPopularPostList(
            @Param("dongCode") String dongCode,
            @Param("searchKeyword") String searchKeyword,
            @Param("startIdx") Long startIdx
    );

    // 게시글 상세 정보 조회
    CommunityPostVO selectPostDetail(Long postId);

    //  pagination 페이지 수 조회
    Long selectPostCount(
            @Param("dongCode") String dongCode,
            @Param("categoryId") Long categoryId,
            @Param("searchKeyword") String searchKeyword
    );

    // 댓글 수 조회
    Long selectCommentCount(Long postId);

    // 게시글 댓글 수 업데이트
    int updatePostCommentCount(@Param("postId") Long postId);

    // 게시글에 대한 댓글 조회
    List<CommunityCommentVO> selectPostComments(Long postId);

    // 댓글 삽입
    int insertComment(CommunityCommentVO commentVO);

    // 댓글의 group_id 업데이트
    int updateCommentGroupId(@Param("commentId") Long commentId, @Param("groupId") Long groupId);

    // 댓글 수정
    int updateComment(@Param("commentId") Long commentId, @Param("content") String content, @Param("userId") Long userId);

    // 댓글 삭제 (soft delete)
    int deleteComment(@Param("commentId") Long commentId, @Param("userId") Long userId);

    // 댓글의 postId 조회
    Long selectPostIdByCommentId(@Param("commentId") Long commentId);

    // 부모 댓글의 depth 조회
    Long selectCommentDepth(@Param("commentId") Long commentId);

    // 조회수 증가
    int updateViewCount(@Param("postId") Long postId);

    // 좋아요 여부 확인
    int checkLikeExists(@Param("postId") Long postId, @Param("userId") Long userId);

    // 좋아요 추가
    int insertLike(@Param("postId") Long postId, @Param("userId") Long userId);

    // 좋아요 삭제
    int deleteLike(@Param("postId") Long postId, @Param("userId") Long userId);

    // 좋아요 수 증가
    int incrementLikeCount(@Param("postId") Long postId);

    // 좋아요 수 감소
    int decrementLikeCount(@Param("postId") Long postId);

    // 게시글 작성
    int insertCommunityPost(CommunityPostVO communityPostVO);
}
