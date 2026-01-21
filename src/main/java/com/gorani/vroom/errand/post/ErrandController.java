package com.gorani.vroom.errand.post;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ErrandController {

	private final ErrandService errandService;

	// 심부름 게시글 목록
	@GetMapping("/errand/list")
	public String errandList(@RequestParam(required = false) String q, @RequestParam(required = false) Long categoryId,
			@RequestParam(required = false) String dongCode, @RequestParam(required = false) String sort,
			@RequestParam(defaultValue = "1") int page, Model model) {

		int size = 20; // 페이지당 개수

		List<ErrandListVO> errands = errandService.getErrandList(q, categoryId, dongCode, sort, page, size);

		int totalCount = errandService.getErrandTotalCount(q, categoryId, dongCode);

		model.addAttribute("errands", errands);
		model.addAttribute("categories", errandService.getCategories());
		model.addAttribute("dongs", errandService.getDongs());
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", page);

		return "errand/errand_list";
	}

	// 심부름 게시글 상세
	@GetMapping("/errand/detail")
	public String errandDetail(@RequestParam("errandsId") Long errandsId, Model model) {
		ErrandDetailVO errand = errandService.getErrandDetail(errandsId);

		if (errand == null) {
			// 존재하지 않는 글이면 목록으로 돌려보냄
			return "redirect:/errand/list";
		}

		model.addAttribute("errand", errand);
		return "errand/errand_detail";
	}

	// 심부름 게시글 작성 화면
	@GetMapping("/errand/create")
	public String errandCreateForm(@RequestParam(required = false) String dongCode, Model model) {

		// 기본 동네 코드 (query 우선)
		model.addAttribute("defaultDongCode", dongCode);
		return "errand/errand_create";
	}

	// 심부름 게시글 작성 등록
	@PostMapping("/errand/create")
	public String errandCreateSubmit(@ModelAttribute ErrandCreateVO errandCreateVO) {
		Long errandsId = errandService.createErrand(errandCreateVO);
		return "redirect:/errand/detail?errandsId=" + errandsId;
	}
}
