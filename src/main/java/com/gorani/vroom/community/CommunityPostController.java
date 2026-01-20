package com.gorani.vroom.community;

import com.gorani.vroom.Location.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.*;

@Controller
@RequestMapping("/community")
public class CommunityPostController {

    @Autowired
    private LocationService locationService;

    @Autowired
    private CommunityService communityService;
    
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
                       Model model) {
        addCommonModel(dongCode, categoryId, guName, model);
        model.addAttribute("searchKeyword", searchKeyword);

        // 게시글 목록 ( 필터링 적용 )
        List<CommunityPostVO> postList;
        if (categoryId != null && categoryId == 0) {
            // 인기글
            postList = communityService.getPopularPostList(dongCode, searchKeyword);
        } else {
            // 전체 또는 일반 카테고리
            postList = communityService.getPostList(dongCode, categoryId, searchKeyword);
        }

        model.addAttribute("postList", postList);

        

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
    @GetMapping("/write")
    public String writeForm(Model model) {
        return "community/write";
    }

}
