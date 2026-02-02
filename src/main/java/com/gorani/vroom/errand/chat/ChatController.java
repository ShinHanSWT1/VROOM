package com.gorani.vroom.errand.chat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import com.gorani.vroom.user.auth.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/errand/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;
    
    @GetMapping("/room")
    public String showChatPageByRoomId(
            @RequestParam("roomId") Long roomId,
            HttpSession session,
            Model model
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        
        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        Long currentUserId = loginUser.getUserId();

        // 1) 참가자 권한 체크 (참가자 아니면 차단)
        String userRole = chatService.getUserRole(roomId, currentUserId);
        if (userRole == null) {
            model.addAttribute("message", "이미 다른 부름이가 채팅 중인 심부름입니다.");
            return "errand/errand_already_matched";
        }

        // 2) roomId로 기본 정보 조회 (errandsId 필요하면 여기서 얻기)
        ChatRoomVO room = chatService.getChatRoomInfo(roomId, currentUserId);
        if (room == null) {
            return "redirect:/errand/list";
        }
        Long errandsId = room.getErrandsId();
        
        String errandStatus = chatService.getErrandStatus(errandsId);
        System.out.println("[DEBUG] roomId=" + roomId + ", errandsId=" + errandsId + ", errandStatus=" + errandStatus);
        model.addAttribute("errandStatus", errandStatus);

        // 3) 채팅방 정보 + 메시지 로딩
        ChatRoomVO chatRoomInfo = chatService.getErrandInfoForChat(errandsId, currentUserId);
        List<ChatMessageVO> messages = chatService.getChatMessages(roomId, currentUserId);

        model.addAttribute("roomId", roomId);
        model.addAttribute("errandsId", errandsId);
        model.addAttribute("currentUserId", currentUserId);
        model.addAttribute("userRole", userRole);
        model.addAttribute("chatRoomInfo", chatRoomInfo);
        model.addAttribute("messages", messages);
        model.addAttribute("currentUserNickname", loginUser.getNickname());

        return "errand/errand_chat";
    }


    /**
     * 채팅 페이지 표시
     */
    @GetMapping
    public String showChatPage(
            @RequestParam("errandsId") Long errandsId,
            HttpSession session,
            Model model
    ) {
        // 세션에서 사용자 정보 가져오기
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        Long currentUserId = loginUser.getUserId();

        System.out.println("[CHAT] enter request errandsId=" + errandsId);
        System.out.println("[CHAT] userId=" + currentUserId);

        // 작성자 여부 판단
        Long ownerUserId = chatService.getOwnerUserIdByErrandsId(errandsId);
        boolean isOwner = ownerUserId != null && ownerUserId.equals(currentUserId);

        // 1) 방 조회
        ChatRoomVO room = chatService.getChatRoomByErrandsId(errandsId);

        // 2) 방이 없으면
        if (room == null) {
            if (isOwner) {
                // 작성자: 부름이가 아직 채팅 시작 안함
                return "redirect:/errand/detail?errandsId=" + errandsId
                        + "&message=" + java.net.URLEncoder.encode(
                            "아직 부름이가 채팅을 시작하지 않았습니다.",
                            java.nio.charset.StandardCharsets.UTF_8
                        );
            } else {
                // 부름이: 방 생성 후 roomId로 입장
                Long createdRoomId = chatService.getOrCreateChatRoom(errandsId, currentUserId);
                return "redirect:/errand/chat/room?roomId=" + createdRoomId;
            }
        }

        // 3) 방이 있으면: 참가자 권한 체크 (재입장 포함)
        Long roomId = room.getRoomId();
        String userRole = chatService.getUserRole(roomId, currentUserId);
        if (userRole == null) {
            // 참가자 아니면: 이미 다른 부름이가 매칭한 방
            return "errand/errand_already_matched";
        }
        
        String errandStatus = chatService.getErrandStatus(errandsId);
        System.out.println("[DEBUG] errandsId=" + errandsId + ", errandStatus=" + errandStatus);
        model.addAttribute("errandStatus", errandStatus);

        // 4) 채팅방 정보 조회 (심부름 정보 포함)
        ChatRoomVO chatRoomInfo = chatService.getErrandInfoForChat(errandsId, currentUserId);

        // 5) 메시지 목록 조회
        List<ChatMessageVO> messages = chatService.getChatMessages(roomId, currentUserId);

        // 6) 모델에 데이터 추가
        model.addAttribute("roomId", roomId);
        model.addAttribute("errandsId", errandsId);
        model.addAttribute("currentUserId", currentUserId);
        model.addAttribute("userRole", userRole);
        model.addAttribute("chatRoomInfo", chatRoomInfo);
        model.addAttribute("messages", messages);
        model.addAttribute("currentUserNickname", loginUser.getNickname());

        return "errand/errand_chat";
    }

    /**
     * 메시지 전송 (AJAX)
     */
    @PostMapping("/send")
    @ResponseBody
    public ResponseEntity<?> sendMessage(
            @RequestBody Map<String, Object> payload,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        Long roomId = Long.valueOf(payload.get("roomId").toString());
        String content = payload.get("content").toString();
        String messageType = payload.getOrDefault("messageType", "TEXT").toString();

        ChatMessageVO message = chatService.sendMessage(
            roomId, 
            loginUser.getUserId(), 
            messageType,
            content
        );

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);

        return ResponseEntity.ok(response);
    }

    /**
     * 심부름 수락 (AJAX)
     */
    @PostMapping("/accept")
    @ResponseBody
    public ResponseEntity<?> acceptErrand(
            @RequestBody Map<String, Object> payload,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        Long errandsId = Long.valueOf(payload.get("errandsId").toString());
        Long roomId = Long.valueOf(payload.get("roomId").toString());

        // 권한 체크: OWNER만 수락 가능
        String userRole = chatService.getUserRole(roomId, loginUser.getUserId());
        if (!"OWNER".equals(userRole)) {
            return ResponseEntity.status(403).body(Map.of("error", "권한이 없습니다."));
        }

        chatService.acceptErrand(errandsId, roomId, loginUser.getUserId());
        
        messagingTemplate.convertAndSend(
    	    "/topic/room." + roomId,
    	    Map.of(
    	        "messageType", "STATUS",
    	        "status", "CONFIRMED1",
    	        "errandsId", errandsId,
    	        "roomId", roomId
    	    )
    	);

        return ResponseEntity.ok(Map.of("success", true, "message", "심부름이 수락되었습니다."));
    }

    /**
     * 심부름 거절 (AJAX)
     */
    @PostMapping("/reject")
    @ResponseBody
    public ResponseEntity<?> rejectErrand(
            @RequestBody Map<String, Object> payload,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        Long errandsId = Long.valueOf(payload.get("errandsId").toString());
        Long roomId = Long.valueOf(payload.get("roomId").toString());
        Long erranderUserId = Long.valueOf(payload.get("erranderUserId").toString());

        // 권한 체크: OWNER만 거절 가능
        String userRole = chatService.getUserRole(roomId, loginUser.getUserId());
        if (!"OWNER".equals(userRole)) {
            return ResponseEntity.status(403).body(Map.of("error", "권한이 없습니다."));
        }

        chatService.rejectErrand(errandsId, roomId, loginUser.getUserId(), erranderUserId);

        return ResponseEntity.ok(Map.of("success", true, "message", "심부름이 거절되었습니다."));
    }
    
    @GetMapping("/enter")
    public String enterChat(
            @RequestParam("errandsId") Long errandsId,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) return "redirect:/auth/login";

        Long userId = loginUser.getUserId();

        // 1) 방 조회
        ChatRoomVO room = chatService.getChatRoomByErrandsId(errandsId);

        // 2) 방이 없으면: 부름이만 생성 가능, 작성자는 안내
        if (room == null) {
            Long ownerUserId = chatService.getOwnerUserIdByErrandsId(errandsId);
            boolean isOwner = ownerUserId != null && ownerUserId.equals(userId);

            if (isOwner) {
                return "redirect:/errand/detail?errandsId=" + errandsId
                    + "&message=" + java.net.URLEncoder.encode(
                        "아직 부름이가 채팅을 시작하지 않았습니다.",
                        java.nio.charset.StandardCharsets.UTF_8
                    );
            }

            // 부름이는 생성 후 입장
            Long roomId = chatService.getOrCreateChatRoom(errandsId, userId);
            return "redirect:/errand/chat/room?roomId=" + roomId;
        }

        // 3) 방이 있으면: 참가자면 재입장 허용, 아니면 차단
        Long roomId = room.getRoomId();
        String role = chatService.getUserRole(roomId, userId);
        if (role == null) {
            return "errand/errand_already_matched";
        }

        return "redirect:/errand/chat/room?roomId=" + roomId;
    }

    /**
     * 메시지 목록 조회 (AJAX)
     */
    @GetMapping("/messages")
    @ResponseBody
    public ResponseEntity<?> getMessages(
            @RequestParam("roomId") Long roomId,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return ResponseEntity.status(401).body(Map.of("error", "로그인이 필요합니다."));
        }

        List<ChatMessageVO> messages = chatService.getChatMessages(roomId, loginUser.getUserId());
        
        return ResponseEntity.ok(Map.of("success", true, "messages", messages));
    }
    
    @PostMapping("/assign/complete-confirm")
    @ResponseBody
    public java.util.Map<String, Object> completeConfirm(@RequestBody java.util.Map<String, Object> body,
                                                         HttpSession session) {
    	System.out.println("[HIT] /assign/complete-confirm");

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return java.util.Map.of("ok", false, "message", "로그인이 필요합니다.");
        }

        Long currentUserId = loginUser.getUserId();
        Long errandsId = Long.valueOf(String.valueOf(body.get("errandsId")));
        Long roomId = Long.valueOf(String.valueOf(body.get("roomId")));

        // (권장) OWNER 권한 체크: 참가자 + 역할 확인
        String role = chatService.getUserRole(roomId, currentUserId);
        if (!"OWNER".equals(role)) {
            return Map.of("success", false, "message", "권한이 없습니다.");
        }

        chatService.completeConfirm(errandsId, currentUserId);
        messagingTemplate.convertAndSend(
    	    "/topic/room." + roomId,
    	    Map.of(
    	        "messageType", "STATUS",
    	        "status", "CONFIRMED2",
    	        "errandsId", errandsId,
    	        "roomId", roomId
    	    )
    	);

        return Map.of("success", true, "status", "CONFIRMED2");
    }
}