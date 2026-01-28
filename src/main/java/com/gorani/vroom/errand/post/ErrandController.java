package com.gorani.vroom.errand.post;

import com.gorani.vroom.errand.assignment.ErrandAssignmentService;
import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;


@Controller
@RequiredArgsConstructor
public class ErrandController {

	private final ErrandService errandService;
	private final ErrandAssignmentService errandAssignmentService;

	// 심부름 게시글 목록
	@GetMapping("/errand/list")
	public String errandList(@RequestParam(required = false) String q, @RequestParam(required = false) Long categoryId,
			@RequestParam(required = false) String dongCode, @RequestParam(required = false) String sort,
			@RequestParam(defaultValue = "1") int page, Model model) {

		int size = 9; // 페이지당 개수

		List<ErrandListVO> errands = errandService.getErrandList(q, categoryId, dongCode, sort, page, size);

		int totalCount = errandService.getErrandTotalCount(q, categoryId, dongCode);
		int totalPages = (int) Math.ceil((double) totalCount / size);
		
		model.addAttribute("page", page);
	    model.addAttribute("size", size);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("totalPages", totalPages);

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
		
		// dongFullName 세팅
	    if (errand.getGunguName() != null && errand.getDongName() != null) {
	        errand.setDongFullName(errand.getGunguName() + " " + errand.getDongName());
	    }

		List<ErrandListVO> relatedErrands =
	            errandService.getRelatedErrands(errandsId, errand.getDongCode(), errand.getCategoryId(), 6);


		model.addAttribute("errand", errand);
		model.addAttribute("relatedErrands", relatedErrands);
		return "errand/errand_detail";
	}

	// 심부름 게시글 작성 화면
	@GetMapping("/errand/create")
	public String errandCreateForm(@RequestParam(required = false) String dongCode, Model model,
								    HttpSession session) {
		UserVO loginUser = (UserVO) session.getAttribute("loginSess");
		if(loginUser == null) {
			return "redirect:/auth/login";
		}

		// 기본 동네 코드 (query 우선)
		model.addAttribute("defaultDongCode", dongCode);
		
		// 동네 목록 내려주기
		List<Map<String, Object>> dongs = errandService.getDongs();
	    model.addAttribute("dongs", dongs);
		return "errand/errand_create";
	}

	
	// 심부름 게시글 작성 등록
	@PostMapping("/errand/create")
	public String errandCreateSubmit(@ModelAttribute ErrandCreateVO errandCreateVO, HttpSession session) {
		
		// 1. 세션에서 "loginSess" 속성을 UserVO 타입으로 가져옵니다.
		UserVO loginUser = (UserVO) session.getAttribute("loginSess");

		// 2. 로그인 상태가 아니라면, 로그인 페이지로 리다이렉트합니다.
		if (loginUser == null) {
			return "redirect:/auth/login";
		}

		// 3. 로그인된 사용자의 ID를 errandCreateVO 객체에 설정합니다.
		errandCreateVO.setUserId(loginUser.getUserId());
		
		Long errandsId = errandService.createErrand(errandCreateVO);
		return "redirect:/errand/detail?errandsId=" + errandsId;
		
	}

	/**
     * 내 정보 페이지 경로 리다이렉트
     * 잘못된 경로(/errand/myInfo)로 들어왔을 때 -> 올바른 경로(/member/myInfo)로 보냄
     */
    @GetMapping("/errand/myInfo")
    public String redirectMyInfo() {
        return "redirect:/member/myInfo";
    }
}
