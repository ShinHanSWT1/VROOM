package com.gorani.vroom.main;

import com.gorani.vroom.community.CommunityPostVO;
import com.gorani.vroom.community.CommunityService;
import com.gorani.vroom.errand.post.CategoryVO;
import com.gorani.vroom.errand.post.ErrandListVO;
import com.gorani.vroom.location.LocationService;
import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MainController {

    private final LocationService locationService;
    private final CommunityService communityService;
    private final MainService mainService;

    @GetMapping("/")
    public String Main(Model model,
                       HttpSession session,
                       @RequestParam(required = false) String dongCode,
                       @RequestParam(required = false) String guName){
        
        // 1. 로그인 정보 확인
        UserVO loginUser = (UserVO)session.getAttribute("loginSess");
        model.addAttribute("loginUser", loginUser);

        // 조회할 동네
        String targetDongCode = null;
        if (dongCode != null && !dongCode.isEmpty()) {
            targetDongCode = dongCode;
        }
        
        // 구 카테고리 필터
        List<String> gunguList = locationService.getGuList();
        model.addAttribute("gunguList", gunguList);
        
        // 현재 선택된 동네 정보를 뷰에 전달 (필터 UI 표시용)
        model.addAttribute("selectedDongCode", targetDongCode);
        model.addAttribute("selectedGuName", guName);

        // 카테고리 리스트 조회
        List<CategoryVO> errandsCategoryList = mainService.getErrandsCategoryList();
        model.addAttribute("errandsCategoryList", errandsCategoryList);
        
        // 최근 심부름 게시글 조회
        List<ErrandListVO> errandListVO = mainService.getMainErrandList(targetDongCode);
        model.addAttribute("errandListVO", errandListVO);
        
        // 커뮤니티 인기글 조회 
        List<CommunityPostVO> popularPostListVO = mainService.getMainPopularPostList(targetDongCode);
        model.addAttribute("popularPostListVO", popularPostListVO);

        return "main/index";
    }
}
