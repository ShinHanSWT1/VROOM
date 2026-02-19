package com.gorani.vroom.main;

import com.gorani.vroom.community.CommunityPostVO;
import com.gorani.vroom.errand.post.ErrandListVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/main")
@RequiredArgsConstructor
public class MainApiController {

    private final MainService mainService;

    @GetMapping("/errands")
    public List<ErrandListVO> getErrands(@RequestParam(required = false) String guName) {
        return mainService.getMainErrandList(guName);
    }

    @GetMapping("/posts")
    public List<CommunityPostVO> getPopularPosts(@RequestParam(required = false) String guName) {
        return mainService.getMainPopularPostList(guName);
    }
}
