package com.gorani.vroom.community;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommunityServiceImpl implements CommunityService{

    private final CommunityMapper communityMapper;

    // 카테고리 목록 조회
    @Override
    public List<CategoryVO> getCategoryList() {
        return communityMapper.selectCategoryList();
    }

    // 게시글 목록 조회
    @Override
    public List<CommunityPostVO> getPostList(String dongCode, Long categoryId, String searchKeyword, Long startIdx) {
        return communityMapper.selectPostList(dongCode, categoryId, searchKeyword, startIdx);
    }

    // 인기글 조회
    @Override
    public List<CommunityPostVO> getPopularPostList(String dongCode, String searchKeyword, Long startIdx) {
        return communityMapper.selectPopularPostList(dongCode, searchKeyword, startIdx);
    }

    // 게시글 상세 데이터 조회
    @Override
    public CommunityPostVO getPostDetail(Long postId) {
        return communityMapper.selectPostDetail(postId);
    }

    // pagination 페이지 수 조회
    @Override
    public Long getPostCount(String dongCode, Long categoryId, String searchKeyword) {
        return communityMapper.selectPostCount(dongCode, categoryId, searchKeyword);
    }

    // 댓글 수 조회
    @Override
    public Long getCommentCount(Long postId) {
        return communityMapper.selectCommentCount(postId);
    }

    // 게시글에 대한 댓글 조회
    @Override
    public List<CommunityCommentVO> getPostComments(Long postId) {
        return communityMapper.selectPostComments(postId);
    }

    // 댓글/대댓글 삽입
    @Override
    @Transactional
    public boolean addComment(CommunityCommentVO commentVO) {
        // 대댓글인 경우
        if (commentVO.getParentCommentId() != null) {
            commentVO.setDepth(1L); // Integer 타입으로 설정
        } else { // 최상위 댓글인 경우
            commentVO.setDepth(0L); // Integer 타입으로 설정
            commentVO.setGroupId(0L); // 임시값
        }

        int insertedRows = communityMapper.insertComment(commentVO);

        if (insertedRows > 0) {
            if (commentVO.getDepth() == 0L) {
                commentVO.setGroupId(commentVO.getCommentId());
                communityMapper.updateCommentGroupId(commentVO.getCommentId(), commentVO.getGroupId());
            }

            // 게시글의 전체 댓글 수 업데이트
            communityMapper.updatePostCommentCount(commentVO.getPostId());
            return true;
        }
        return false;
    }

    // 댓글 수정
    @Override
    public boolean updateComment(Long commentId, String content, Long userId) {
        int result = communityMapper.updateComment(commentId, content, userId);
        return result > 0;
    }

    // 댓글 삭제
    @Override
    @Transactional
    public boolean deleteComment(Long commentId, Long userId) {
        // 삭제 전에 postId 조회
        Long postId = communityMapper.selectPostIdByCommentId(commentId);

        int result = communityMapper.deleteComment(commentId, userId);
        if (result > 0 && postId != null) {
            // 게시글의 댓글 수 업데이트
            communityMapper.updatePostCommentCount(postId);
            return true;
        }
        return false;
    }
}
