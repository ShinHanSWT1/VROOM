package com.gorani.vroom.errand.assignment;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gorani.vroom.errand.chat.ChatService;

import lombok.RequiredArgsConstructor;
import java.io.File;
import java.util.UUID;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;


@Service
@RequiredArgsConstructor
public class ErrandAssignmentServiceImpl implements ErrandAssignmentService {

    private final ErrandAssignmentMapper errandAssignmentMapper;
    private final ChatService chatService;
    
    private String toChangedByType(String role) {
        if (role == null) return "SYSTEM";

        // 시스템 내부 role이 OWNER로 오더라도 history는 USER로 기록
        switch (role) {
            case "OWNER":
            case "USER":
                return "USER";
            case "ERRANDER":
            case "RUNNER":
                return "ERRANDER";
            case "ADMIN":
                return "ADMIN";
            default:
                return "SYSTEM";
        }
    }


    @Override
    @Transactional
    public Long requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId) {
    	
    	// 0) owner 조회 (먼저!)
        Long ownerUserId = errandAssignmentMapper.selectOwnerUserId(errandsId);

        // [가드1] 작성자가 호출하면 즉시 막기 (매칭/assignment 생성 금지)
        if (ownerUserId != null && ownerUserId.equals(erranderUserId)) {
            System.out.println("[ASSIGN][BLOCK] OWNER cannot start chat. errandsId=" + errandsId + ", userId=" + erranderUserId);
            // 작성자는 여기서 room을 만들면 안 됨. (부름이가 시작해야 함)
            // 컨트롤러에서 "방 있으면 입장 / 없으면 안내"로 보내는 게 맞음
            throw new IllegalStateException("작성자는 채팅 시작(매칭)을 할 수 없습니다. 부름이가 채팅을 시작해야 합니다.");
            // 또는 return null; (근데 null 반환하면 또 다른 곳에서 NPE 날 수 있음)
        }

        // 1) errander profile 조회 (부름이만 존재해야 함)
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(erranderUserId);
        System.out.println("[ASSIGN] erranderUserId=" + erranderUserId);
        System.out.println("[ASSIGN] erranderId(from profiles)=" + erranderId);

        // [가드2] 부름이 프로필 없으면 매칭 시작 불가
        if (erranderId == null) {
            System.out.println("[ASSIGN][BLOCK] errander profile not found. userId=" + erranderUserId);
            throw new IllegalStateException("부름이 프로필이 없어 채팅 시작이 불가합니다.");
        }
    	
    	// DB에서 status 재조회
        String status = errandAssignmentMapper.selectErrandStatus(errandsId);
        System.out.println("[ASSIGN] db status before=" + status);

        // WAITING->MATCHED 시도
        int updated = errandAssignmentMapper.updateErrandStatusWaitingToMatched(errandsId);
        System.out.println("[ASSIGN] update rows=" + updated);

        // 업데이트 후 status 재조회
        String after = errandAssignmentMapper.selectErrandStatus(errandsId);
        System.out.println("[ASSIGN] db status after=" + after);

        // 1) WAITING -> MATCHED
        if (updated == 0) {
            throw new IllegalStateException("이미 누군가 선점했거나 요청 불가 상태입니다.");
        }

        System.out.println("[ASSIGN] erranderUserId=" + erranderUserId);

        // 4) assignment insert
        errandAssignmentMapper.insertMatchedAssignment(ownerUserId, errandsId, erranderId);

        // 5) status history
        errandAssignmentMapper.insertStatusHistory(
            errandsId,
            "WAITING",
            "MATCHED",
            "ERRANDER",
            changedByUserId
        );

        // 6) 채팅방 생성
        Long roomId = chatService.getOrCreateChatRoom(errandsId, erranderUserId);

        return roomId; // 이제 정상
    }
    
    @Override
    @Transactional
    public void uploadCompleteProof(Long errandsId, Long roomId, Long runnerUserId, MultipartFile proofImage) {

        if (proofImage == null || proofImage.isEmpty()) {
            throw new RuntimeException("업로드 파일이 없습니다.");
        }

        // 핵심: userId -> erranderId(부름이 프로필 PK)로 변환
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(runnerUserId);
        if (erranderId == null) {
            throw new RuntimeException("부름이 프로필이 없어 업로드가 불가합니다.");
        }

        // validate도 erranderId로 검사해야 함
        int can = errandAssignmentMapper.validateRunnerAndStatus(errandsId, erranderId);
        if (can != 1) {
            throw new RuntimeException("업로드 권한이 없거나 상태가 올바르지 않습니다.");
        }

        // 2) 파일 저장 (로컬)
        String uploadDir = "D:/vroom_uploads/proof"; // 주인님 환경에 맞게 통일 추천
        new File(uploadDir).mkdirs();

        String original = proofImage.getOriginalFilename();
        String ext = "";
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf("."));
        }

        String saveName = UUID.randomUUID().toString().replace("-", "") + ext;
        File dest = new File(uploadDir, saveName);

        try {
            proofImage.transferTo(dest);
        } catch (Exception e) {
            throw new RuntimeException("파일 저장 실패");
        }

        // URL 경로도 /uploads/proof 로 통일 (정적 리소스 매핑이 그쪽이면)
        String savedPath = "/uploads/proof/" + saveName;

        // 3) proof 저장 (erranderId로 저장)
        int inserted = errandAssignmentMapper.insertCompletionProof(errandsId, erranderId, savedPath);
        if (inserted != 1) {
            throw new RuntimeException("인증 정보 저장 실패");
        }
        
        // 4) 상태 변경: CONFIRMED1 -> CONFIRMED2
        int updated = errandAssignmentMapper.updateErrandStatusConfirmed1ToConfirmed2(errandsId);
        if (updated != 1) {
            throw new RuntimeException("상태 변경 실패(이미 변경되었거나 조건 불일치)");
        }
        
        // 5) 히스토리 저장 (CONFIRMED1 -> CONFIRMED2)
        int hist = errandAssignmentMapper.insertStatusHistory(
                errandsId,
                "CONFIRMED1",
                "CONFIRMED2",
                "ERRANDER",      // 또는 "RUNNER" / "USER" 너희 규칙대로
                erranderId       // changed_by_id도 너희 규칙대로 (userId를 쓰는 구조면 userId)
        );
        if (hist != 1) {
            throw new RuntimeException("상태 히스토리 저장 실패");
        }
    }

    
    @Override
    @Transactional
    public Long createCompletionProof(Long errandsId, Long erranderId, String fileUrl) {
        // 1) completion_proofs insert
        errandAssignmentMapper.insertCompletionProof(errandsId, erranderId, fileUrl);
        Long proofId = errandAssignmentMapper.selectLastInsertedProofId(); // 또는 useGeneratedKeys로 바로 받기

        // 2) proof_media insert
        errandAssignmentMapper.insertProofMedia(proofId, fileUrl);

        return proofId;
    }

}