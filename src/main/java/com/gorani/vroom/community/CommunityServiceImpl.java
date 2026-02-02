package com.gorani.vroom.community;

import com.gorani.vroom.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class CommunityServiceImpl implements CommunityService{

    private final CommunityMapper communityMapper;
    private final NotificationService notificationService;

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

    // 게시글에 대한 댓글 조회 (계층구조 정렬)
    @Override
    public List<CommunityCommentVO> getPostComments(Long postId) {
        List<CommunityCommentVO> allComments = communityMapper.selectPostComments(postId);
        return sortCommentsHierarchically(allComments);
    }

    // 댓글을 부모-자식 계층구조로 정렬
    private List<CommunityCommentVO> sortCommentsHierarchically(List<CommunityCommentVO> comments) {
        if (comments == null || comments.isEmpty()) {
            return comments;
        }

        // commentId로 빠르게 찾기 위한 맵
        Map<Long, CommunityCommentVO> commentMap = new HashMap<>();
        for (CommunityCommentVO comment : comments) {
            commentMap.put(comment.getCommentId(), comment);
        }

        // 부모 commentId별 자식 목록
        Map<Long, List<CommunityCommentVO>> childrenMap = new HashMap<>();
        List<CommunityCommentVO> rootComments = new ArrayList<>();

        for (CommunityCommentVO comment : comments) {
            if (comment.getParentCommentId() == null || comment.getDepth() == 0) {
                // 최상위 댓글
                rootComments.add(comment);
            } else {
                // 대댓글 - 부모별로 그룹화
                childrenMap.computeIfAbsent(comment.getParentCommentId(), k -> new ArrayList<>()).add(comment);
            }
        }

        // 최상위 댓글을 최신순으로 정렬
        rootComments.sort((a, b) -> Long.compare(b.getGroupId(), a.getGroupId()));

        // 자식 댓글 시간순 정렬
        for (List<CommunityCommentVO> children : childrenMap.values()) {
            children.sort(Comparator.comparing(CommunityCommentVO::getCreatedAt));
        }

        // dfs
        List<CommunityCommentVO> result = new ArrayList<>();
        for (CommunityCommentVO root : rootComments) {
            addCommentWithChildren(root, childrenMap, result);
        }

        return result;
    }

    // 재귀적으로 댓글과 자식 댓글 추가
    private void addCommentWithChildren(CommunityCommentVO comment,
                                        Map<Long, List<CommunityCommentVO>> childrenMap,
                                        List<CommunityCommentVO> result) {
        result.add(comment);
        List<CommunityCommentVO> children = childrenMap.get(comment.getCommentId());
        if (children != null) {
            for (CommunityCommentVO child : children) {
                addCommentWithChildren(child, childrenMap, result);
            }
        }
    }

    // 댓글/대댓글 삽입
    @Override
    @Transactional
    public boolean addComment(CommunityCommentVO commentVO) {
        // 대댓글인 경우
        if (commentVO.getParentCommentId() != null) {
            // 부모 댓글의 depth를 조회해서 +1
            Long parentDepth = communityMapper.selectCommentDepth(commentVO.getParentCommentId());
            commentVO.setDepth(parentDepth != null ? parentDepth + 1 : 1L);
        } else { // 최상위 댓글인 경우
            commentVO.setDepth(0L);
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

            // 알림 전송
            sendCommentNotification(commentVO);

            return true;
        }
        return false;
    }

    // 댓글 알림 전송
    private void sendCommentNotification(CommunityCommentVO commentVO) {
        Long commentWriterId = commentVO.getUserId();
        String url = "/community/detail/" + commentVO.getPostId();

        if (commentVO.getParentCommentId() != null) {
            // 대댓글인 경우 → 부모 댓글 작성자에게 알림
            Long parentCommentUserId = communityMapper.selectCommentUserId(commentVO.getParentCommentId());
            if (parentCommentUserId != null && !parentCommentUserId.equals(commentWriterId)) {
                notificationService.send(parentCommentUserId, "REPLY", "회원님의 댓글에 답글이 달렸습니다.", url);
            }
        } else {
            // 일반 댓글인 경우 → 게시글 작성자에게 알림
            Long postOwnerId = communityMapper.selectPostUserId(commentVO.getPostId());
            if (postOwnerId != null && !postOwnerId.equals(commentWriterId)) {
                notificationService.send(postOwnerId, "COMMENT", "회원님의 게시글에 댓글이 달렸습니다.", url);
            }
        }
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

    // 조회수 증가
    @Override
    public void increaseViewCount(Long postId) {
        communityMapper.updateViewCount(postId);
    }

    // 좋아요 토글
    @Override
    @Transactional
    public boolean toggleLike(Long postId, Long userId) {
        int exists = communityMapper.checkLikeExists(postId, userId);
        if (exists > 0) {
            // 이미 좋아요 했으면 취소
            communityMapper.deleteLike(postId, userId);
            communityMapper.decrementLikeCount(postId);
            return false;
        } else {
            // 좋아요 추가
            communityMapper.insertLike(postId, userId);
            communityMapper.incrementLikeCount(postId);

            // 좋아요 알림 전송 (게시글 작성자에게, 본인 제외)
            Long postOwnerId = communityMapper.selectPostUserId(postId);
            if (postOwnerId != null && !postOwnerId.equals(userId)) {
                String url = "/community/detail/" + postId;
                notificationService.send(postOwnerId, "LIKE", "회원님의 게시글에 좋아요가 눌렸습니다.", url);
            }

            return true;
        }
    }

    // 좋아요 여부 확인
    @Override
    public boolean isLiked(Long postId, Long userId) {
        return communityMapper.checkLikeExists(postId, userId) > 0;
    }

    // 게시글 작성
    @Override
    public boolean createPost (CommunityPostVO communityPostVO) {
        return communityMapper.insertCommunityPost(communityPostVO) > 0;
    }

    // 게시글 업데이트
    @Override
    public boolean updatePost(CommunityPostVO communityPostVO) {
        return communityMapper.updateCommunityPost(communityPostVO) > 0;
    }

    // 게시글 삭제
    @Override
    public boolean deletePost(CommunityPostVO communityPostVO) {
        return communityMapper.deleteCommunityPost(communityPostVO) > 0;
    }

    // 근처 동네 인기글 조회
    @Override
    public List<CommunityPostVO> getNearbyPopularPostList(String dongCode, Long currentPostId) {
        return communityMapper.selectNearbyPopularPostList(dongCode, currentPostId);
    }

    // 이미지 저장
    @Override
    public void saveImages(Long postId, List<String> imageUrls) {
        if (imageUrls == null || imageUrls.isEmpty()) {
            return;
        }
        for (int i = 0; i < imageUrls.size(); i++) {
            CommunityImageVO imageVO = new CommunityImageVO();
            imageVO.setPostId(postId);
            imageVO.setImageUrl(imageUrls.get(i));
            imageVO.setSortOrder(i + 1);
            communityMapper.insertCommunityImage(imageVO);
        }
    }

    // 이미지 목록 조회
    @Override
    public List<CommunityImageVO> getImages(Long postId) {
        return communityMapper.selectImages(postId);
    }

    // 이미지 수정 (keepImageIds 제외한 나머지 삭제 + 새 이미지 추가)
    @Override
    @Transactional
    public void updateImages(Long postId, List<Long> keepImageIds, List<String> newImageUrls) {
        // keepImageIds에 없는 기존 이미지 soft delete
        communityMapper.deleteImages(postId, keepImageIds);

        // 새 이미지 추가 (sort_order는 기존 이미지 다음부터)
        int startOrder = (keepImageIds != null) ? keepImageIds.size() + 1 : 1;
        if (newImageUrls != null) {
            for (int i = 0; i < newImageUrls.size(); i++) {
                CommunityImageVO imageVO = new CommunityImageVO();
                imageVO.setPostId(postId);
                imageVO.setImageUrl(newImageUrls.get(i));
                imageVO.setSortOrder(startOrder + i);
                communityMapper.insertCommunityImage(imageVO);
            }
        }
    }

    // 내가 작성한 글 목록 조회
    @Override
    public List<CommunityPostVO> getMyPosts(Long userId) {
        return communityMapper.selectMyPosts(userId);
    }

    // 내가 댓글 단 글 목록 조회
    @Override
    public List<CommunityPostVO> getMyCommentedPosts(Long userId) {
        return communityMapper.selectMyCommentedPosts(userId);
    }

    // 내가 좋아요한 글 목록 조회
    @Override
    public List<CommunityPostVO> getMyLikedPosts(Long userId) {
        return communityMapper.selectMyLikedPosts(userId);
    }
}
