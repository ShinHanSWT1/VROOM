package com.gorani.vroom.errand.assignment;

import java.io.File;
import java.util.UUID;

import com.gorani.vroom.vroompay.VroomPayService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.gorani.vroom.errand.chat.ChatService;
import com.gorani.vroom.notification.NotificationService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ErrandAssignmentServiceImpl implements ErrandAssignmentService {

    private final ErrandAssignmentMapper errandAssignmentMapper;
    private final ChatService chatService;
    private final NotificationService notificationService;
    private final VroomPayService vroomPayService;

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

        // 0) owner 조회
        Long ownerUserId = errandAssignmentMapper.selectOwnerUserId(errandsId);

        // [가드1] 작성자가 호출하면 즉시 막기 (매칭/assignment 생성 금지)
        if (ownerUserId != null && ownerUserId.equals(erranderUserId)) {
            // 작성자는 여기서 room을 만들면 안 됨. (부름이가 시작해야 함)
            throw new IllegalStateException("작성자는 채팅 시작(매칭)을 할 수 없습니다. 부름이가 채팅을 시작해야 합니다.");
        }

        // 1) errander profile 조회 (부름이만 존재해야 함)
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(erranderUserId);
        System.out.println("[ASSIGN] erranderUserId=" + erranderUserId);
        System.out.println("[ASSIGN] erranderId(from profiles)=" + erranderId);

        // [가드2] 부름이 프로필 없으면 매칭 시작 불가
        if (erranderId == null) {
            throw new IllegalStateException("부름이 프로필이 없어 채팅 시작이 불가합니다.");
        }

        // active_status가 active 인 부름이만 가능하도록
        if (!"ACTIVE".equals(errandAssignmentMapper.getErranderActiveStatus(erranderId))) {
            throw new IllegalStateException("해당 부름이 계정이 정지된 상태입니다.");
        }

        // DB에서 status 재조회
        String before = errandAssignmentMapper.selectErrandStatus(errandsId);
        System.out.println("[ASSIGN] db status before=" + before);

        // WAITING->MATCHED 시도
        int updated = errandAssignmentMapper.updateErrandWaitingToMatchedWithErrander(errandsId, erranderId);
        System.out.println("[ASSIGN] update rows=" + updated);

        // 1) WAITING -> MATCHED
        if (updated == 0) {
            throw new IllegalStateException("이미 누군가 선점했거나 요청 불가 상태입니다.");
        }

        // 4) assignment insert
        errandAssignmentMapper.insertMatchedAssignment(null, ownerUserId, errandsId, erranderId, "AUTO", "MATCHED", null);

        // 5) status history
        errandAssignmentMapper.insertStatusHistory(
                errandsId,
                before,
                "MATCHED",
                "ERRANDER",
                changedByUserId
        );

        // 6) 채팅방 생성
        Long roomId = chatService.getOrCreateChatRoom(errandsId, erranderUserId);

        // + 알림 보내기
        notificationService.send(
                ownerUserId,
                "ERRAND",
                "심부름이 매칭되었습니다",
                "/errand/detail?errandsId=" + errandsId
        );

        // PAYMENT erranderId 업데이트
        vroomPayService.updatePaymentErranderMatched(errandsId, erranderId);


        return roomId; // 이제 정상
    }
    
    @Override
    @Transactional
    public void uploadCompleteProof(Long errandsId, Long roomId, Long erranderUserId, MultipartFile proofImage) {

        if (proofImage == null || proofImage.isEmpty()) {
            throw new RuntimeException("업로드 파일이 없습니다.");
        }

        // userId -> erranderId(부름이 프로필 PK)로 변환
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(erranderUserId);
        if (erranderId == null) {
            throw new RuntimeException("부름이 프로필이 없어 업로드가 불가합니다.");
        }

        // validate도 erranderId로 검사해야 함
        int can = errandAssignmentMapper.validateRunnerAndStatus(errandsId, erranderId);
        if (can != 1) {
            throw new RuntimeException("업로드 권한이 없거나 상태가 올바르지 않습니다.");
        }

        // 2) 파일 저장 (로컬)
        String uploadDir = "D:/vroom_uploads/proof";
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


    /**
     * 관리자에 의한 심부름 수동 배정
     * - 상태 변경 (WAITING -> MATCHED)
     * - 배정 정보 Insert
     * - 이력 기록 (ADMIN)
     * - 채팅방 생성
     *
     * @return
     */
    @Override
    @Transactional
    public Long assignErranderByAdmin(Long errandsId, Long erranderId, Long adminId, String reason) {
        Long roomId = null;

        // 1. 심부름 작성자(Owner) ID 조회 (채팅방 생성용)
        Long ownerUserId = errandAssignmentMapper.selectOwnerUserId(errandsId);
        if (ownerUserId == null) {
            throw new IllegalStateException("존재하지 않는 심부름입니다.");
        }

        // 2. 부름이(Errander)의 User ID 조회
        Long erranderUserId = errandAssignmentMapper.selectUserIdByErranderId(erranderId);
        if (erranderUserId == null) {
            throw new IllegalStateException("유효하지 않는 부름이 ID입니다.");
        }
        if (ownerUserId.equals(erranderUserId)) {
            System.out.println("[ASSIGN][BLOCK] OWNER cannot start chat. errandsId=" + errandsId + ", userId=" + erranderUserId);
            throw new IllegalStateException("작성자는 채팅 시작(매칭)을 할 수 없습니다. 부름이가 채팅을 시작해야 합니다.");
        }

        // 3. 현재 심부름 상태 확인 (WAITING이어야 배정 가능)
        String status = errandAssignmentMapper.selectErrandStatus(errandsId);
        if (!"WAITING".equals(status)) {
            throw new IllegalStateException("대기(WAITING) 상태의 심부름만 배정할 수 있습니다. 현재상태: " + status);
        }

        // 4. 상태 변경 (WAITING -> MATCHED)
        int updated = errandAssignmentMapper.updateErrandStatusWaitingToMatched(errandsId);
        if (updated == 0) {
            throw new IllegalStateException("심부름 상태 변경에 실패했습니다. 이미 배정되었을 수 있습니다.");
        }

        // 5. 배정 정보 저장 (Assignment Insert)
        errandAssignmentMapper.insertMatchedAssignment(adminId, ownerUserId, errandsId, erranderId, "MANUAL", "MATCHED", reason);

        // 6. 상태 변경 이력 저장 (Changed By ADMIN)
        // 사유(Reason)를 저장할 컬럼이 있다면 Mapper를 수정하여 reason도 전달하세요.
        errandAssignmentMapper.insertStatusHistory(
                errandsId,
                "WAITING",
                "MATCHED",
                "ADMIN",    // 변경 주체: 관리자
                adminId     // 관리자 ID
        );

        // 7. 채팅방 생성 (Owner <-> Errander)
        // 채팅방이 있어야 소통이 가능하므로 필수입니다.
        try {
            roomId = chatService.getOrCreateChatRoom(errandsId, erranderUserId);
            if (roomId != null) {
                // + 알림 보내기
                notificationService.send(
                        ownerUserId,
                        "ERRAND",
                        "심부름에 부름이가 배정되었습니다",
                        "/errand/detail?errandsId=" + errandsId
                );
            }
        } catch (Exception e) {
            log.error("관리자 배정 후 채팅방 생성 실패: errandsId={}", errandsId, e);
            // 채팅방 실패가 배정 취소로 이어져야 한다면 throw e;
            // 채팅방은 나중에 만들어도 된다면 로그만 남김 (비즈니스 요건에 따름)
        }

        return roomId;
    }
    
    @Override
    public boolean isMatchedErrander(Long errandsId, Long userId) {
        if (errandsId == null || userId == null) return false;

        // userId → erranderId 변환
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(userId);
        if (erranderId == null) return false;

        // errander_id 기준으로 매칭 여부 확인
        return errandAssignmentMapper
                .countMatchedByErrandAndErrander(errandsId, erranderId) > 0;
    }
    
    @Override
    public boolean isCanceledErrander(Long errandsId, Long userId) {
        return errandAssignmentMapper.existsCanceledAssignment(errandsId, userId) > 0;
    }
    
    @Override
    @Transactional
    public void rejectErrander(Long errandsId, Long erranderId, Long changedByUserId) {

        // 1) assignments 상태: MATCHED -> CANCELED (매칭 레코드 종료)
        int updatedAssign = errandAssignmentMapper.updateAssignmentStatusMatchedToCanceled(errandsId, erranderId);
        if (updatedAssign == 0) {
            throw new IllegalStateException("이미 처리된 요청입니다.");
        }

        // 2) errand_status_history 기록: MATCHED -> WAITING
        errandAssignmentMapper.insertStatusHistory(
            errandsId,
            "MATCHED",
            "WAITING",
            "USER",
            changedByUserId
        );

        // 3) errands(게시글) 상태: MATCHED -> WAITING
        int updatedErrand = errandAssignmentMapper.updateErrandStatusMatchedToWaiting(errandsId);
        if (updatedErrand == 0) {
            throw new IllegalStateException("게시글 상태 갱신 실패: errandsId=" + errandsId);
        }

        // 4) 거절 이력 테이블 기록 (재신청 방지)
        errandAssignmentMapper.insertRejectHistory(errandsId, erranderId);
    }
}