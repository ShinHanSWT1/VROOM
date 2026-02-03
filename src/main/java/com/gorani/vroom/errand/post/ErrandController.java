package com.gorani.vroom.errand.post;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.gorani.vroom.vroompay.VroomPayService;
import com.gorani.vroom.vroompay.VroomPayVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gorani.vroom.errand.assignment.ErrandAssignmentService;
import com.gorani.vroom.errand.chat.ChatService;
import com.gorani.vroom.user.auth.UserVO;

import lombok.RequiredArgsConstructor;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequiredArgsConstructor
public class ErrandController {

	private final ErrandService errandService;
	private final ErrandAssignmentService errandAssignmentService;
	private final ChatService chatService;
	private final VroomPayService vroomPayService;

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
		System.out.println("4444444444444444444444444444");

		return "errand/errand_list";
	}

	// 심부름 게시글 상세
	@GetMapping("/errand/detail")
	public String errandDetail(@RequestParam("errandsId") Long errandsId, Model model, HttpSession session) {

	    ErrandDetailVO errand = errandService.getErrandDetail(errandsId);
	    if (errand == null) return "redirect:/errand/list";

	    // dongFullName 세팅
	    if (errand.getGunguName() != null && errand.getDongName() != null) {
	        errand.setDongFullName(errand.getGunguName() + " " + errand.getDongName());
	    }

	    List<ErrandListVO> relatedErrands =
	            errandService.getRelatedErrands(errandsId, errand.getDongCode(), errand.getCategoryId(), 6);

	    // 로그인 유저 (세션에는 userId만 있다고 가정)
	    Long currentUserId = null;
	    
	    // 1) loginSess에서 가져오기 (ChatController에서 쓰는 방식과 통일)
	    Object loginSess = session.getAttribute("loginSess");
	    if (loginSess != null) {
	        try {
	            // loginSess에 getUserId()가 있으면 가져옴
	            Object v = loginSess.getClass().getMethod("getUserId").invoke(loginSess);
	            if (v instanceof Long) currentUserId = (Long) v;
	            else if (v instanceof Integer) currentUserId = ((Integer) v).longValue();
	            else if (v instanceof String) currentUserId = Long.valueOf((String) v);
	        } catch (Exception ignore) {}
	    }

	    // 2) fallback: userId (혹시 저장돼 있으면)
	    if (currentUserId == null) {
	        Object userIdObj = session.getAttribute("userId");
	        if (userIdObj instanceof Long) currentUserId = (Long) userIdObj;
	        else if (userIdObj instanceof Integer) currentUserId = ((Integer) userIdObj).longValue();
	        else if (userIdObj instanceof String) {
	            try { currentUserId = Long.valueOf((String) userIdObj); } catch (Exception ignore) {}
	        }
	    }

	    // 작성자 여부 (ErrandDetailVO.userId = 작성자 id)
	    Long ownerId = errand.getUserId();
	    boolean isOwner = (currentUserId != null && ownerId != null && currentUserId.equals(ownerId));
	    System.out.println("111111111111111111" + ownerId);
	    // 매칭된 부름이 여부
	    boolean isMatchedErrander = false;
	    if (currentUserId != null && !isOwner) {
	        // 이 게시글에 대해 "현재 유저가 수행자로 매칭되어 있는지"
	        isMatchedErrander = errandAssignmentService.isMatchedErrander(errandsId, currentUserId);
	    }
	    System.out.println("22222222222222222222222" + currentUserId);
	    // 채팅방 존재 여부
	    boolean hasChatRoom = false;
	    if (isOwner || isMatchedErrander) {   // currentUserId null이면 위에서 false라서 안전
	        hasChatRoom = chatService.existsChatRoomByErrandsId(errandsId);
	    }

	    // 재입장 가능
	    boolean canReEnterChat = (isOwner || isMatchedErrander) && hasChatRoom;
	    
	    System.out.println("[DETAIL] errandsId=" + errandsId
	            + " currentUserId=" + currentUserId
	            + " ownerId=" + ownerId
	            + " isOwner=" + isOwner
	            + " isMatchedErrander=" + isMatchedErrander
	            + " hasChatRoom=" + hasChatRoom
	            + " canReEnterChat=" + canReEnterChat);

	    model.addAttribute("isOwner", isOwner);
	    model.addAttribute("isMatchedErrander", isMatchedErrander);
	    model.addAttribute("hasChatRoom", hasChatRoom);
	    model.addAttribute("canReEnterChat", canReEnterChat);

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
	public String errandCreateSubmit(@ModelAttribute ErrandCreateVO errandCreateVO,
									 HttpSession session,
									 RedirectAttributes rttr) {
		
		// 1. 세션에서 "loginSess" 속성을 UserVO 타입으로 가져옵니다.
		UserVO loginUser = (UserVO) session.getAttribute("loginSess");

		// 2. 로그인 상태가 아니라면, 로그인 페이지로 리다이렉트합니다.
		if (loginUser == null) {
			return "redirect:/auth/login";
		}

		// 3. 로그인된 사용자의 ID를 errandCreateVO 객체에 설정합니다.
		errandCreateVO.setUserId(loginUser.getUserId());

		// -- 페이가 부족한 경우 create 못하고 충전해야함
		// 현재 유저의 잔액 조회
		VroomPayVO vroomPayVO = vroomPayService.getWalletAccount(loginUser.getUserId());
		long currentBalance = vroomPayVO.getAvailBalance().longValueExact();

		// 심부름 가격 조회
		long errandPrice = errandCreateVO.getRewardAmount() + errandCreateVO.getExpenseAmount();

		// 잔액 비교
		if (currentBalance < errandPrice) {
			// 잔액이 부족한 경우 처리
			// 충전 페이지로 리다이렉트 하면서 메시지 전달
			rttr.addFlashAttribute("msg", "보유 페이가 부족합니다. 충전 후 다시 시도해주세요.");
			return "redirect:/member/vroomPay";
		}
		
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
