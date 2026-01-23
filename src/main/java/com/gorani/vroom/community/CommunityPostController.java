package com.gorani.vroom.community;

import com.gorani.vroom.location.LocationService;
import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/community")
@RequiredArgsConstructor
public class CommunityPostController {

    private static final int PAGE_SIZE = 8;

    private final LocationService locationService;
    private final CommunityService communityService;
    
    @ModelAttribute
    private void addCommonModel(@RequestParam(required = false)  String dongCode,
                                @RequestParam(required = false)  Long categoryId,
                                @RequestParam(required = false)  String guName,
                                Model model) {
        // 구 목록 필터 
        List<String> gunguList = locationService.getGuList();
        model.addAttribute("gunguList", gunguList);

        // 카테고리 목록 필터
        List<CategoryVO> categoryList = communityService.getCategoryList();
        model.addAttribute("categoryList", categoryList);

         // 현재 필터 상태 유지 (jsp에서 selected/active 표시용)
         model.addAttribute("selectedDongCode", dongCode);
         model.addAttribute("selectedCategoryId", categoryId);
         model.addAttribute("selectedGuName", guName);
        
    }

    // 모든 커뮤니티 페이지 요청 시 로그인 사용자 정보를 모델에 추가
    @ModelAttribute("loginUser")
    public UserVO addLoginUserToModel(HttpSession session) {
        return (UserVO) session.getAttribute("loginSess");
    }

    // 커뮤니티 게시글 목록
    @GetMapping("")
    public String list(@RequestParam(required = false)  String dongCode,
                       @RequestParam(required = false)  Long categoryId,
                       @RequestParam(required = false)  String guName,
                       @RequestParam(required = false)  String searchKeyword,
                       @RequestParam(defaultValue = "1") Long page,
                       Model model) {
        addCommonModel(dongCode, categoryId, guName, model);
        model.addAttribute("searchKeyword", searchKeyword);

        PaginationDataDTO paginationData = getPaginationData(dongCode, categoryId, searchKeyword, page);

        model.addAttribute("postList", paginationData.getPostList());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", paginationData.getTotalPages());
        model.addAttribute("totalPosts", paginationData.getTotalCount());

        return "community/main";
    }

    // 게시글 상세 페이지
    @GetMapping("/detail/{postId}")
    public String detail(@PathVariable Long postId,
                         @RequestParam(required = false)  String dongCode,
                         @RequestParam(required = false)  Long categoryId,
                         @RequestParam(required = false)  String guName,
                         HttpSession session,
                         Model model) {
        addCommonModel(dongCode, categoryId, guName, model);

        // 조회수 증가
        communityService.increaseViewCount(postId);

        // 게시글 상세
        CommunityPostVO communityPostDetail = communityService.getPostDetail(postId);
        if(communityPostDetail == null) {
            return "redirect:/community";
        }
        model.addAttribute("postDetail", communityPostDetail);
        if (dongCode == null)
            model.addAttribute("selectedDongCode", communityPostDetail.getDongCode());
        if (categoryId == null)
            model.addAttribute("selectedCategoryId", communityPostDetail.getCategoryId());
        if (guName == null)
            model.addAttribute("selectedGuName", communityPostDetail.getGunguName());

        // 댓글 목록 및 총 댓글 수 조회
        List<CommunityCommentVO> commentList = communityService.getPostComments(postId);
        Long totalComments = communityService.getCommentCount(postId);

        model.addAttribute("commentList", commentList);
        model.addAttribute("totalComments", totalComments);

        // 좋아요 여부 확인
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        boolean isLiked = false;
        if (loginUser != null) {
            isLiked = communityService.isLiked(postId, loginUser.getUserId());
        }
        model.addAttribute("isLiked", isLiked);

        return "community/detail";
    }

    // pagination
    @ResponseBody
    @GetMapping("/api/posts/pagination")
    public PaginationVO pagination(@RequestParam(required = false)  String dongCode,
                                   @RequestParam(required = false)  Long categoryId,
                                   @RequestParam(required = false)  String searchKeyword,
                                   @RequestParam(defaultValue = "1") Long page){
        PaginationDataDTO paginationData = getPaginationData(dongCode, categoryId, searchKeyword, page);

        PaginationVO result = new PaginationVO();
        result.setContent(paginationData.getPostList());
        result.setPage(page);
        result.setTotalPosts(paginationData.getTotalCount());
        result.setTotalPages(paginationData.getTotalPages());
        result.setSize((long) PAGE_SIZE);

        return result;
    }

    // 댓글 목록 조회
    @ResponseBody
    @GetMapping("/api/posts/{postId}/comments")
    public ResponseEntity<List<CommunityCommentVO>> getComment(
            @PathVariable Long postId,
            HttpSession session) {
        List<CommunityCommentVO> commentList = communityService.getPostComments(postId);

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if(loginUser != null) {
            for(CommunityCommentVO comment : commentList) {
                if(loginUser.getUserId().equals(comment.getUserId())) {
                    comment.setUser(true);
                }
            }
        }

        return new ResponseEntity<>(commentList, HttpStatus.OK);
    }

    // 댓글 작성
    @ResponseBody
    @PostMapping("/api/posts/{postId}/comments")
    public ResponseEntity<String> addComment(
            @PathVariable Long postId,
            @RequestBody CommunityCommentVO commentVO,
            HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if(loginUser == null) {
            return new ResponseEntity<>("로그인이 필요합니다. ", HttpStatus.UNAUTHORIZED);
        }

        commentVO.setPostId(postId);
        commentVO.setUserId(loginUser.getUserId());

        boolean isSuccess = communityService.addComment(commentVO);
        if (isSuccess) {
            return new ResponseEntity<>("", HttpStatus.CREATED);
        } else {
            return new ResponseEntity<>("", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 댓글 수정
    @ResponseBody
    @PutMapping("/api/comments/{commentId}")
    public ResponseEntity<Void> updateComment(
            @PathVariable Long commentId,
            @RequestBody CommunityCommentVO commentVO,
            HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        boolean isSuccess = communityService.updateComment(commentId, commentVO.getContent(), loginUser.getUserId());
        if (isSuccess) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    // 댓글 삭제
    @ResponseBody
    @DeleteMapping("/api/comments/{commentId}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable Long commentId,
            HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        boolean isSuccess = communityService.deleteComment(commentId, loginUser.getUserId());
        if (isSuccess) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    // 좋아요 토글
    @ResponseBody
    @PostMapping("/api/posts/{postId}/like")
    public ResponseEntity<LikeResponseDTO> toggleLike(
            @PathVariable Long postId,
            HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        boolean isLiked = communityService.toggleLike(postId, loginUser.getUserId());
        CommunityPostVO post = communityService.getPostDetail(postId);
        Long likeCount = post != null ? post.getLikeCount() : 0L;

        return new ResponseEntity<>(new LikeResponseDTO(isLiked, likeCount), HttpStatus.OK);
    }

    private PaginationDataDTO getPaginationData(String dongCode, Long categoryId, String searchKeyword, Long page) {
        long startIdx = (page - 1) * PAGE_SIZE;

        List<CommunityPostVO> postList;
        if (categoryId != null && categoryId == 0) {
            // 인기글
            postList = communityService.getPopularPostList(dongCode, searchKeyword, startIdx);
        } else {
            // 전체 또는 일반 카테고리
            postList = communityService.getPostList(dongCode, categoryId, searchKeyword, startIdx);
        }

        long totalCount = communityService.getPostCount(dongCode, categoryId, searchKeyword);
        long totalPages = (long) Math.ceil((double) totalCount / PAGE_SIZE);

        return new PaginationDataDTO(postList, totalCount, totalPages);
    }

    @GetMapping("/write")
    public String writeForm(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/user/login";
        }
        return "community/write";
    }

    @PostMapping("/write")
    public String createPost(CommunityPostVO postVO
                            , HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/user/login";
        }
        postVO.setUserId(loginUser.getUserId());

        boolean success = communityService.createPost(postVO);
        if(success) {
            return "redirect:/community/detail/" + postVO.getPostId();
        }

        return "redirect:/community/write";
    }

}
