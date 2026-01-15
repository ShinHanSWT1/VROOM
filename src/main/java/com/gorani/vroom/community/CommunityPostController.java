package com.gorani.vroom.community;

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

    // 커뮤니티 게시글 목록 페이지
    @GetMapping("/list")
    public String list(Model model,
                       @RequestParam(value = "category_name", required = false, defaultValue = "전체")
                       String categoryName) {
        List<String> gunguList = locationService.getGuList();
        model.addAttribute("gunguList", gunguList);

        // 검색 조건 데이터
        Map<String, String> searchVO = new HashMap<>();
        searchVO.put("gungu_name", "금천구"); // legal_dong 테이블 기준
        searchVO.put("dong_name", "가산동");  // legal_dong 테이블 기준
        searchVO.put("category_name", categoryName);

        model.addAttribute("searchVO", searchVO);

        // 게시글 목록
        List<Map<String, Object>> postList = new ArrayList<>();

        for (int i = 1; i <= 5; i++) {
            Map<String, Object> post = new HashMap<>();
            post.put("post_id", i); // postNo -> post_id
            post.put("title", "가산동 소식 " + i);
            post.put("content", "DB 컬럼명과 맞춘 테스트 내용입니다.");
            post.put("nickname", "고라니" + i); // MEMBERS 테이블 조인 결과 가정
            post.put("dong_name", "가산동");  // legal_dong 조인 결과 가정
            post.put("category_name", categoryName.equals("전체") ? "맛집" : categoryName);
            post.put("created_at", new Date()); // regDate -> created_at
            post.put("like_count", 10 + i);    // likeCount -> like_count
            post.put("view_count", 100 + i);   // viewCount -> view_count

            postList.add(post);
        }
        model.addAttribute("postList", postList);
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
        post.put("manner_score", 36.5); // temperature -> manner_score (MEMBERS 테이블)
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
    public String writeFomr(Model model) {
        return "community/write";
    }

}
