package com.gorani.vroom.errander.activity;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/errander/mypage")
@RequiredArgsConstructor
public class ErranderActivityController {

    private final ErranderActivityServiceImpl activityService;

/*    // 나의 거래 페이지
    @GetMapping("/activity")
    public String activity(Model model, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        return "errander/activity";
    }*/

    // 일별 수익 API (달력용)
    @GetMapping("/api/daily-earnings")
    @ResponseBody
    public List<ErranderActivityVO> getDailyEarnings(
            @RequestParam int year,
            @RequestParam int month,
            HttpSession session) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return List.of();
        }

        Long userId = loginUser.getUserId();
        return activityService.getErranderActivities(userId, year, month);
    }
}