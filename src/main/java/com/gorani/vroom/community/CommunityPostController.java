package com.gorani.vroom.community;

import com.gorani.vroom.location.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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

    // 커뮤니티 게시글 목록 페이지
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

    @GetMapping("/detail/{postId}")
    public String detail(@PathVariable int postId,
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

        return "community/detail";
    }

    @ResponseBody
    @GetMapping("/api/posts")
    public PaginationVO pagination(
                             @RequestParam(required = false)  String dongCode,
                             @RequestParam(required = false)  Long categoryId,
                             @RequestParam(required = false)  String guName,
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
