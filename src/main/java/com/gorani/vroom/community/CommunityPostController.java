package com.gorani.vroom.community;

import com.gorani.vroom.location.LocationService;
import com.gorani.vroom.user.profile.UserProfileVO;
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
                         Model model) {
        addCommonModel(dongCode, categoryId, guName, model);

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

        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("user");
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
        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("user");
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
    public String writeForm(Model model) {
        return "community/write";
    }

}
