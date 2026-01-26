package com.gorani.vroom.user.profile;

import com.gorani.vroom.community.CommunityPostVO;
import com.gorani.vroom.community.CommunityService;
import com.gorani.vroom.user.auth.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/member")
public class UserProfileController {

    private final UserProfileService userProfileService;
    private final CommunityService communityService;

    @Autowired
    public UserProfileController(UserProfileService userProfileService, CommunityService communityService) {
        this.userProfileService = userProfileService;
        this.communityService = communityService;
    }

    // 나의 정보 페이지
    @GetMapping("/myInfo")
    public String userProfile(Model model, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        // 로그인 안하면
        if(loginUser == null){
            return "redirect:/auth/login";
        }
        // 로그인 상태
        Long userId = loginUser.getUserId();

        UserProfileVO profile = userProfileService.getUserProfile(userId);
        model.addAttribute("profile", profile);

        // 내가 신청한 심부름 목록
        model.addAttribute("errands", userProfileService.getMyErrands(userId));

        log.info("조회된 프로필 정보: {}", profile);
        return "user/myInfo";
    }

    // 나의 활동
    @GetMapping("/myActivity")
    public String myActivity(Model model, HttpSession session) {

        // 로그인 체크 (세션 확인)
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        // 내 회원 번호 가져오기
        Long userId = loginUser.getUserId();

        // CommunityService에서 3가지 활동 내역 가져오기
        List<CommunityPostVO> myPosts = communityService.getMyPosts(userId);
        List<CommunityPostVO> myComments = communityService.getMyCommentedPosts(userId);
        List<CommunityPostVO> myScraps = communityService.getMyLikedPosts(userId);

        //  JSP(화면)로 보따리(Model) 싸서 보내기
        model.addAttribute("myPosts", myPosts);       // 작성한 글
        model.addAttribute("myComments", myComments); // 댓글 단 글
        model.addAttribute("myScraps", myScraps);     // 저장한 글

        return "user/myActivity";
    }
}
