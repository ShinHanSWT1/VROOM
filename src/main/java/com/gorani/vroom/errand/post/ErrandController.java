package com.gorani.vroom.errand.post;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

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
	public String errandCreateForm(@RequestParam(required = false) String dongCode, Model model) {

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
		
		// 2) 가장 흔한 케이스: userId가 세션에 Long/Integer/String으로 들어있는 경우
	    Object userIdObj = session.getAttribute("userId");
//	    if (userIdObj != null) {
//	        errandCreateVO.setUserId(Long.valueOf(userIdObj.toString()));
//	    } else {
//	        // 3) 다음 케이스: loginUser 객체로 들어있는 경우 -> 타입 모르니 일단 클래스 확인
//	        Object loginUser = session.getAttribute("loginUser");
//	        System.out.println("loginUser.class=" + (loginUser == null ? "null" : loginUser.getClass()));
//
//	        // ❗ 여기서 loginUser에서 userId를 꺼내는 건 '실제 타입'에 맞춰야 함
//	        // 타입 확인 후 getter로 꺼내서 setUserId 해야 함.
//	    }
//
//	    // 방어: userId 여전히 null이면 등록 불가 (DB가 거절함)
//	    if (errandCreateVO.getUserId() == null) {
//	        throw new IllegalStateException("로그인 userId를 세션에서 찾지 못했습니다.");
//	        // 또는: return "redirect:/login";
//	    }
	    
	    Long userId = (userIdObj == null) ? 2L : Long.valueOf(userIdObj.toString());

	    errandCreateVO.setUserId(userId);
	    

	    System.out.println("POST title=" + errandCreateVO.getTitle());
	    System.out.println("POST categoryId=" + errandCreateVO.getCategoryId());
	    System.out.println("POST dongCode = [" + errandCreateVO.getDongCode() + "]");
	    System.out.println("POST dongFullName = [" + errandCreateVO.getDongFullName() + "]");

	    

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
