package com.gorani.vroom.community;

import com.gorani.vroom.Location.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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

    // 커뮤니티 게시글 목록 페이지
    @GetMapping("")
    public String list(@RequestParam(required = false)  String dongCode,
                       @RequestParam(required = false)  Long categoryId,
                       @RequestParam(required = false)  String searchKeyword,
                       Model model) {
        List<String> gunguList = locationService.getGuList();
        model.addAttribute("gunguList", gunguList);

        // 사이드바 카테고리 불러오기
        List<CategoryVO> categoryList = communityService.getCategoryList();
        model.addAttribute("categoryList", categoryList);
        model.addAttribute("selectedCategoryId", categoryId);

        // 게시글 목록 ( 필터링)
        List<CommunityPostVO> postList = communityService.getPostList(dongCode, categoryId, searchKeyword);
        model.addAttribute("postList", postList);

        // 검색 조건
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("searchKeyword", searchKeyword);

        // 게시글 목록
//        List<Map<String, Object>> postList = new ArrayList<>();
//        for (int i = 1; i <= 5; i++) {
//            Map<String, Object> post = new HashMap<>();
//            post.put("post_id", i);
//            post.put("title", "테스트 게시글 " + i);
//            post.put("content", "내용입니다.");
//            post.put("nickname", "사용자" + i);
//            post.put("dong_name", "가산동");
//            post.put("created_at", new Date());
//            post.put("like_count", 10 + i);
//            post.put("view_count", 100 + i);
//            post.put("category_name", "맛집");
//            postList.add(post);
//        }
        return "community/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("post_id") int postId, Model model) {
        // 1. 게시글 상세 (DB 컬럼명 기준)
        Map<String, Object> post = new HashMap<>();
        post.put("post_id", postId);
        post.put("title", "DB 컬럼명을 사용한 제목");
        post.put("content", "내용입니다.");
        post.put("nickname", "작성자");
        post.put("manner_score", 36.5);
        post.put("dong_name", "가산동");
        post.put("category_name", "맛집");
        post.put("created_at", new Date());
        post.put("like_count", 50);
        post.put("view_count", 200);

        model.addAttribute("post", post);

        // 2. 댓글 목록 (COMMUNITY_COMMENT 테이블 컬럼명 기준)
        List<Map<String, Object>> commentList = new ArrayList<>();
        Map<String, Object> comment = new HashMap<>();
        comment.put("comment_id", 1); // commentNo -> comment_id
        comment.put("content", "댓글 내용입니다.");
        comment.put("created_at", new Date());
        comment.put("nickname", "댓글러");
        comment.put("dong_name", "독산동");

        commentList.add(comment);
        model.addAttribute("commentList", commentList);

        return "community/detail";
    }
    @GetMapping("/write")
    public String writeForm(Model model) {
        return "community/write";
    }

}
