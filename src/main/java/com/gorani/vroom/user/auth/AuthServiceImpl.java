package com.gorani.vroom.user.auth;

import com.gorani.vroom.common.util.MD5Util;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.io.File;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthUserMapper authUserMapper;
    private final KakaoOAuthClient kakaoOAuthClient;

    // =====================================================
    // ====================== SIGNUP =======================
    // =====================================================

    @Override
    public void signup(UserVO vo, MultipartFile profile, UserVO oauthUser) throws Exception {

        System.out.println("🔥 AuthServiceImpl.signup() 진입");

        // =====================================================
        // ================= 0. 입력값 정규화 ==================
        // =====================================================
        // 서버 기준 데이터 정합성 확보 (프론트 신뢰 ❌)
        vo.setEmail(vo.getEmail() != null ? vo.getEmail().trim() : null);
        vo.setNickname(vo.getNickname() != null ? vo.getNickname().trim() : null);
        vo.setPhone(vo.getPhone() != null ? vo.getPhone().trim() : null);

        if (vo.getDongCode2() != null && vo.getDongCode2().isBlank()) {
            vo.setDongCode2(null);
        }

        // =====================================================
        // ============ 1. OAuth 병합 + 랜덤 비번 처리 ============
        // =====================================================
        // - OAuth로 가입하는 경우, snsId/provider 등 신뢰 가능한 값은 서버가 강제로 주입한다.
        // - pwd는 사용자가 입력하지 않으므로 DB NOT NULL 충족용 랜덤값을 서버에서 생성한다.
        boolean isOAuthSignup = (oauthUser != null);

        if (isOAuthSignup) {
            mergeOAuthUser(vo, oauthUser);
            ensureOAuthPassword(vo); // 랜덤 비번 + md5 세팅
        }

        // =====================================================
        // ================= 2. 입력값/중복 검증 =================
        // =====================================================
        // ⚠️ 주의:
        // - OAuth 경로로 들어와도 "최종 저장"은 일반 회원가입과 동일하게 제약을 만족해야 한다.
        // - oauthUser 쪽 값이 비어있을 수 있으니, 최종 vo 기준으로 검증한다.

        // 0. 이메일 중복 체크 (email이 최종적으로 있어야 한다면 여기서 막아야 함)
        if (vo.getEmail() == null || vo.getEmail().isBlank()) {
            throw new IllegalArgumentException("이메일은 필수입니다.");
        }
        if (!vo.getEmail().matches("^[^@]+@[^@]+\\.[^@]+$")) {
            throw new IllegalArgumentException("이메일 형식이 올바르지 않습니다.");
        }
        if (existsEmail(vo.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 1. 전화번호 중복 체크
        if (vo.getPhone() == null || vo.getPhone().isBlank()) {
            throw new IllegalArgumentException("전화번호는 필수입니다.");
        }
        if (!vo.getPhone().matches("^\\d{11}$")) {
            throw new IllegalArgumentException("전화번호는 숫자 11자리여야 합니다.");
        }
        if (existsPhone(vo.getPhone())) {
            throw new IllegalArgumentException("이미 가입된 전화번호입니다.");
        }

        // 2. 닉네임 중복 체크
        if (vo.getNickname() == null || vo.getNickname().isBlank()) {
            throw new IllegalArgumentException("닉네임은 필수입니다.");
        }
        if (vo.getNickname().contains(" ")) {
            throw new IllegalArgumentException("닉네임에는 공백을 사용할 수 없습니다.");
        }
        if (existsNickname(vo.getNickname())) {
            throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
        }

        // 3. 주소 검증
        if (vo.getDongCode1() == null || vo.getDongCode1().isBlank()) {
            throw new IllegalArgumentException("주소 1은 필수입니다.");
        }
//        if (vo.getDongCode2() == null || vo.getDongCode2().isBlank()) {
//            throw new IllegalArgumentException("주소 2는 필수입니다.");
//        }

        // =====================================================
        // ================= 3. 프로필 이미지 처리 ===============
        // =====================================================
        if (profile != null && !profile.isEmpty()) {
            String fileName = saveFile(profile);
            vo.setProfileImage(fileName);
        }

        // =====================================================
        // =================== 4. 기본값 세팅 ===================
        // =====================================================
        vo.setRole("USER");
        vo.setStatus("ACTIVE");

        if (vo.getMannerScore() == null) {
            vo.setMannerScore(new BigDecimal("36.5"));
        }
        if (vo.getCancelRate() == null) {
            vo.setCancelRate(BigDecimal.ZERO);
        }

        // provider 기본값 (OAuth면 merge에서 이미 SOCIAL이 들어감)
        if (vo.getProvider() == null || vo.getProvider().isBlank()) {
            vo.setProvider("LOCAL");
        }

        // =====================================================
        // ================= 5. 비밀번호 암호화 ==================
        // =====================================================
        // - LOCAL: 사용자가 입력한 비번을 md5
        // - OAuth: ensureOAuthPassword()에서 이미 md5 세팅 완료 → 여기서 다시 하면 안 됨
        if (!isOAuthSignup) {
            if (vo.getPwd() == null || vo.getPwd().isBlank()) {
                throw new IllegalArgumentException("비밀번호는 필수입니다.");
            }
            vo.setPwd(MD5Util.md5(vo.getPwd()));
        }

        // =====================================================
        // ==================== 6. DB INSERT ====================
        // =====================================================
        int result = authUserMapper.insertUser(vo);
        if (result != 1) {
            throw new RuntimeException("회원가입 DB 저장 실패");
        }
    }


    // =====================================================
    // ======================= LOGIN =======================
    // =====================================================

    @Override
    public UserVO login(UserVO vo) {

        // email / pwd 기반 로그인 (ERD 조건 포함)
        UserVO loginUser = authUserMapper.login(vo);

        // 로그인 성공 시 마지막 로그인 시간 갱신
        if (loginUser != null) {
            authUserMapper.updateLastLoginAt(loginUser.getUserId());
        }

        return loginUser;
    }


    // =====================================================
    // =================== VALIDATION ======================
    // ===================  [중복체크]  ======================
    // =====================================================

    @Override
    public boolean existsEmail(String email) {
        return authUserMapper.existsEmail(email) != null;
    }

    @Override
    public boolean existsPhone(String phone) {
        return authUserMapper.existsPhone(phone) != null;
    }

    @Override
    public boolean existsNickname(String nickname) {
        return authUserMapper.existsNickname(nickname) != null;
    }


    // =====================================================
    // ===================== FILE UPLOAD ===================
    // =====================================================

    private String saveFile(MultipartFile file) throws Exception {
        String uploadDir = "C:/upload/profile/";

        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        if (originalName == null || !originalName.contains(".")) {
            throw new IllegalArgumentException("잘못된 파일 형식입니다.");
        }

        String ext = originalName.substring(originalName.lastIndexOf("."));
        String savedName = UUID.randomUUID() + ext;

        file.transferTo(new File(uploadDir + savedName));
        return savedName;
    }

    // =====================================================
    // ===================  OAuth MERGE ====================
    // =====================================================

    /**
     * OAuth 임시 사용자(oauthSignupUser) 정보를 서버 기준으로 병합한다.
     *
     * 원칙:
     * - snsId/provider는 서버가 신뢰하는 값이므로 무조건 덮어쓴다.
     * - email/nickname은 oauthUser에 값이 "있을 때만" 덮어쓴다.
     *   (사용자가 추가 입력해야 하는 경우를 위해)
     */
    private void mergeOAuthUser(UserVO target, UserVO oauthUser) {

        // 서버 신뢰 필드: 무조건 주입
        target.setSnsId(oauthUser.getSnsId());
        target.setProvider(oauthUser.getProvider()); // "SOCIAL"

        // 선택 필드: oauthUser에 값이 있을 때만 주입 (없으면 사용자가 입력한 값 유지)
        if (oauthUser.getEmail() != null && !oauthUser.getEmail().isBlank()) {
            target.setEmail(oauthUser.getEmail());
        }
        if (oauthUser.getNickname() != null && !oauthUser.getNickname().isBlank()) {
            target.setNickname(oauthUser.getNickname());
        }
    }

    /**
     * OAuth 전용 내부 비밀번호 생성 + md5 처리
     * - 사용자는 비밀번호를 모른다 (카카오로만 로그인)
     * - DB NOT NULL / 기존 로직 유지용 내부 값
     */
    private void ensureOAuthPassword(UserVO vo) {
        String randomPwd = UUID.randomUUID().toString();
        vo.setPwd(MD5Util.md5(randomPwd));
    }



    // =====================================================
    // =================== OAuth (Kakao) ===================
    // =====================================================

    @Override
    public KakaoLoginResult kakaoLogin(String code, HttpSession session) {

        // 1️⃣ 카카오 사용자 정보 조회
        String redirectUri = (String) session.getAttribute("kakaoRedirectUri");
        if (redirectUri == null) {
            throw new RuntimeException("카카오 redirectUri 세션값이 없습니다.");
        }

        KakaoUserInfo kakaoUser =
                kakaoOAuthClient.getUserInfo(code, redirectUri);

        session.removeAttribute("kakaoRedirectUri");

        String snsId = kakaoUser.getId();

        // 2️⃣ 기존 회원 조회
        UserVO exist = authUserMapper.findBySnsId(snsId);

        if (exist != null) {
            authUserMapper.updateLastLoginAt(exist.getUserId());
            session.setAttribute("loginSess", exist);
            return KakaoLoginResult.LOGIN_SUCCESS;
        }

        // 3️⃣ 신규 회원 → 임시 세션 저장
        UserVO temp = new UserVO();
        temp.setSnsId(snsId);
        temp.setProvider("SOCIAL");
        temp.setEmail(kakaoUser.getEmail());       // null 가능
        temp.setNickname(kakaoUser.getNickname()); // null 가능
        System.out.println(temp);
        session.setAttribute("oauthSignupUser", temp);

        return KakaoLoginResult.NEED_SIGNUP;
    }
}