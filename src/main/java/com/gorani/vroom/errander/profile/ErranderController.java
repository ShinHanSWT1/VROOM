package com.gorani.vroom.errander.profile;

import com.gorani.vroom.config.MvcConfig;
import com.gorani.vroom.user.auth.UserVO;
import com.gorani.vroom.vroompay.VroomPayService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/errander") // 모든 주소 앞에 /errander가 자동으로 붙음
@RequiredArgsConstructor
public class ErranderController {

    private final ErranderService erranderService;
    private final VroomPayService vroomPayService;

    //  나의 정보
    @GetMapping("/mypage/profile")
    public String profile(Model model, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());

        // 부름이 등록 안 된 유저라면 등록 페이지로 보내기
        if (profile == null) {
            return "redirect:/errander/register";
        }

        model.addAttribute("profile", profile);
        return "errander/profile";
    }

    // 나의 거래
    @GetMapping("/mypage/activity")
    public String activity() {
        return "errander/activity";
    }

    // 부름 페이
    @GetMapping("/mypage/pay")
    public String pay(Model model, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
        if (profile == null) {
            return "redirect:/errander/register";
        }

        model.addAttribute("profile", profile);
        return "errander/pay";
    }

    // 부름 페이 - 정산 요약 API
    @ResponseBody
    @GetMapping("/api/pay/summary")
    public ResponseEntity<Map<String, Object>> getPaySummary(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response);
        }

        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
        if (profile == null) {
            response.put("success", false);
            response.put("message", "부름이 등록이 필요합니다.");
            return ResponseEntity.ok(response);
        }

        Long erranderId = profile.getErranderId();

        // 정산 대기 금액 (CONFIRMED1)
        int settlementWaiting = erranderService.getSettlementWaitingAmount(erranderId);

        // 수령 예정 금액 (CONFIRMED2)
        int expectedAmount = erranderService.getExpectedAmount(erranderId);

        // 이번 달 정산 수익 (COMPLETED)
        int thisMonthSettled = erranderService.getThisMonthSettledAmount(erranderId);

        response.put("success", true);
        response.put("settlementWaiting", settlementWaiting);
        response.put("expectedAmount", expectedAmount);
        response.put("thisMonthSettled", thisMonthSettled);

        return ResponseEntity.ok(response);
    }

    // 리뷰 목록 조회 API
    @ResponseBody
    @GetMapping("/api/reviews")
    public ResponseEntity<Map<String, Object>> getReviews(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response);
        }

        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
        if (profile == null) {
            response.put("success", false);
            response.put("message", "부름이 정보가 없습니다.");
            return ResponseEntity.ok(response);
        }

        List<ErranderReviewVO> reviews = erranderService.getErranderReviews(profile.getErranderId(), page, size);
        
        response.put("success", true);
        response.put("reviews", reviews);
        response.put("page", page);
        response.put("hasMore", reviews.size() == size); // 다음 페이지 존재 가능성

        return ResponseEntity.ok(response);
    }

    // 설정
    @GetMapping("/mypage/settings")
    public String settings() {
        return "errander/settings";
    }

    // 나의 거래 상세 심부름 관련 글 누르면 이동
    @GetMapping("/mypage/activity_detail")
    public String activityDetail(@RequestParam("id") Long vroomId, Model model) {
        // TODO : vroomID 로 거래 상세 정보 조회해서 담기
        model.addAttribute("vroomId", vroomId);
        return "errander/activity_detail";
    }

    // 부름이 등록 페이지
    @GetMapping("/register")
    public String registerForm(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        // 이미 등록된 부름이인지 확인
        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
        if (profile != null && !"REJECTED".equals(profile.getApprovalStatus())) {
            // REJECTED가 아니면 (PENDING, APPROVED) 마이페이지로
            return "redirect:/member/myInfo";
        }
        // profile이 null이거나 REJECTED면 등록 페이지로

        return "errander/register";
    }

    // 부름이 등록 처리
    @PostMapping("/register")
    public String register(ErranderProfileVO profileVO,
                           @RequestParam("idType") String idType,
                           @RequestParam("idFile") MultipartFile idFile,
                           @RequestParam("bankFile") MultipartFile bankFile,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        // 파일 크기 체크 (예: 10MB)
        long maxFileSize = 10 * 1024 * 1024;
        if (idFile.getSize() > maxFileSize || bankFile.getSize() > maxFileSize) {
            redirectAttributes.addFlashAttribute("message", "파일 크기는 각각 10MB를 초과할 수 없습니다.");
            return "redirect:/errander/register?error=fileSize";
        }

        profileVO.setUserId(loginUser.getUserId());

        try {
            // 문서 정보를 담을 리스트 생성
            List<ErranderDocumentVO> documents = new ArrayList<>();

            // 신분증 처리
            if (!idFile.isEmpty()) {
                String savedPath = saveFile(idFile);
                if (savedPath == null) {
                    throw new IOException("신분증 파일 저장 실패");
                }

                documents.add(new ErranderDocumentVO(
                        idType,
                        idFile.getOriginalFilename(),
                        savedPath
                ));
            }

            // 통장 사본 처리
            if (!bankFile.isEmpty()) {
                String savedPath = saveFile(bankFile);
                if (savedPath == null) {
                    throw new IOException("통장 사본 파일 저장 실패");
                }

                documents.add(new ErranderDocumentVO(
                        "ACCOUNT",
                        bankFile.getOriginalFilename(),
                        savedPath
                ));
            }

            // 기존 REJECTED 프로필이 있는지 확인 (재신청 여부)
            ErranderProfileVO existingProfile = erranderService.getErranderProfile(loginUser.getUserId());
            boolean success;

            if (existingProfile != null && "REJECTED".equals(existingProfile.getApprovalStatus())) {
                // 재신청: 기존 프로필 업데이트 + 기존 서류 삭제 + 새 서류 등록
                success = erranderService.reRegisterErrander(existingProfile.getErranderId(), profileVO, documents);
            } else {
                // 신규 등록
                success = erranderService.registerErrander(profileVO, documents);
            }

            if (success) {
                // 등록 성공 시 사용자 메인 페이지로 이동하며 메시지 전달
                redirectAttributes.addFlashAttribute("message", "부름이 등록 신청이 완료되었습니다. 관리자 승인 후 활동 가능합니다.");
                return "redirect:/";
            } else {
                // 실패 시 다시 등록 페이지로 (에러 메시지 전달 필요할 수 있음)
                redirectAttributes.addFlashAttribute("message", "등록 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
                return "redirect:/errander/register?error=true";
            }

        } catch (IOException e) {
            log.error("파일 저장 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("message", "파일 업로드 중 오류가 발생했습니다.");
            return "redirect:/errander/register?error=io";
        } catch (Exception e) {
            log.error("부름이 등록 중 알 수 없는 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", "알 수 없는 오류가 발생했습니다.");
            return "redirect:/errander/register?error=server";
        }
    }

    // 심부름꾼 등록 여부 및 승인 상태 확인
    @ResponseBody
    @GetMapping("/check")
    public ResponseEntity<Map<String, Object>> checkErrander(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("isRegistered", false);
            return ResponseEntity.ok(response);
        }

        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());

        if (profile == null) {
            response.put("isRegistered", false);
        } else {
            response.put("isRegistered", true);
            response.put("approvalStatus", profile.getApprovalStatus());

            // 계좌 연결 여부 확인
            boolean hasAccount = vroomPayService.getWalletAccount(loginUser.getUserId()) != null;
            response.put("hasAccount", hasAccount);
        }

        return ResponseEntity.ok(response);
    }

    // 심부름꾼으로 전환
    @GetMapping("/switch")
    public String switchToErrander(@RequestParam(value = "returnUrl", required = false) String returnUrl,
                                   HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser != null) {
            // 전환 전 한 번 더 체크 (선택 사항)
            ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
            if (profile != null && "APPROVED".equals(profile.getApprovalStatus())) {
                loginUser.setRole("ERRANDER");
                session.setAttribute("loginSess", loginUser);
            }
        }

        if (returnUrl != null && !returnUrl.isEmpty()) {
            return "redirect:" + returnUrl;
        }
        return "redirect:/";
    }

    private String saveFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return null;
        }

        // 저장 디렉토리 확인 및 생성
        File uploadDir = new File(MvcConfig.ERRANDER_DOC_UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 원본 파일명에서 확장자 추출
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        // 저장할 파일명 생성 (UUID + 확장자)
        String savedFilename = UUID.randomUUID() + extension;

        // 파일 저장
        File destFile = new File(MvcConfig.ERRANDER_DOC_UPLOAD_PATH + savedFilename);
        file.transferTo(destFile);

        // 웹 접근 경로 반환
        return "/uploads/erranderDocs/" + savedFilename;
    }
}
