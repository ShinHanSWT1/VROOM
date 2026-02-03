package com.gorani.vroom.user.profile;

import com.gorani.vroom.common.util.S3UploadService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserProfileServiceImpl implements UserProfileService {

    private final UserMapper userMapper;
    private final S3UploadService s3UploadService;

    // 프로필 조회
    @Override
    public UserProfileVO getUserProfile(Long userId) {
        return userMapper.findById(userId);
    }

    // 프로필 수정
    @Override
    public void updateProfile(Long userId, UserProfileVO vo) {
        vo.setUserId(userId);
        userMapper.update(vo);
    }

    // 프로필 이미지 경로만 수정
    @Override
    public void updateProfileImage(Long userId, String imagePath) {
        userMapper.updateProfileImage(userId, imagePath);
    }

    // 프로필 이미지 파일 저장 (S3 적용)
    @Override
    public String saveProfileImage(Long userId, MultipartFile file) throws IOException {
        // S3 업로드
        String webPath = s3UploadService.upload(file, "profile");
        
        // DB 저장용 웹 경로 업데이트
        userMapper.updateProfileImage(userId, webPath);

        return webPath;
    }

    // 내가 신청한 심부름 목록 조회
    @Override
    public List<ErrandsVO> getMyErrands(Long userId) {
        return userMapper.findErrandsByUserId(userId);
    }

    // 신고 등록
    @Override
    public void createIssueTicket(IssueTicketVO ticket) {

        // errandId로 심부름꾼 ID 조회
        if (ticket.getErrandId() != null) {
            Long erranderId =
                    userMapper.findErranderIdByErrandId(ticket.getErrandId());
            ticket.setTargetUserId(erranderId);
        }

        userMapper.insertIssueTicket(ticket);

        // 심부름 상태 변경 (CONFIRMED2 → HOLD) + 이력 추가
        if (ticket.getErrandId() != null) {
            userMapper.updateErrandStatus(ticket.getErrandId(), "HOLD");
            userMapper.insertErrandStatusHistory(
                    ticket.getErrandId(), "CONFIRMED2", "HOLD", "USER", ticket.getUserId()
            );
        }

        log.info(
                "신고 등록 완료: errandId={}, userId={}, targetUserId={}",
                ticket.getErrandId(),
                ticket.getUserId(),
                ticket.getTargetUserId()
        );
    }

    // 회원 탈퇴 (비밀번호 확인 후 처리)
    @Override
    public boolean withdrawUser(Long userId, String password) {

        // DB 비밀번호 조회
        String storedPassword = userMapper.findPasswordByUserId(userId);

        // 비밀번호 검증
        if (storedPassword != null && storedPassword.equals(password)) {
            userMapper.withdrawUser(userId);
            log.info("회원 탈퇴 완료: userId={}", userId);
            return true;
        }

        log.warn("회원 탈퇴 실패 - 비밀번호 불일치: userId={}", userId);
        return false;
    }

    @Override
    public void changeRole(Long userId, String role) {
        userMapper.updateRole(userId, role);
    }
}
