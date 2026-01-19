package com.gorani.vroom.errand.post;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ErrandController {

    private final ErrandService errandService;

    /**
     * 심부름 게시글 목록
     */
    @GetMapping("/errand/list")
    public String errandList(@RequestParam(required = false) String q,
                             @RequestParam(required = false) Long categoryId,
                             @RequestParam(required = false) String dongCode,
                             @RequestParam(required = false) String sort,
                             @RequestParam(defaultValue = "1") int page,
                             Model model) {

        int size = 20; // 페이지당 개수

        List<ErrandListVO> errands =
                errandService.getErrandList(q, categoryId, dongCode, sort, page, size);

        int totalCount =
                errandService.getErrandTotalCount(q, categoryId, dongCode);

        model.addAttribute("errands", errands);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", page);

        return "errand_list";
    }

    /**
     * 심부름 게시글 상세
     */
    @GetMapping("/errand/detail")
    public String errandDetail() {
        return "errand_detail";
    }

    /**
     * 심부름 게시글 작성 화면
     */
    @GetMapping("/errand/create")
    public String errandCreate() {
        return "errand_create";
    }
}
