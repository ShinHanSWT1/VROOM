package com.gorani.vroom.admin.notice;

import com.gorani.vroom.admin.auth.AdminVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminNoticeController {

    private final AdminNoticeService noticeService;

    // 페이지 이동
    @GetMapping("/admin/notice")
    public String notice() {
        return "admin/notice";
    }

    // 목록 조회 API (관리자용)
    @GetMapping("/admin/api/notice/list")
    @ResponseBody
    public List<NoticeVO> getNoticeList(@RequestParam(required = false)
                                        String keyword,
                                        @RequestParam(required = false)
                                        String status,
                                        @RequestParam(required = false)
                                        String target) {
        return noticeService.getNoticeList(keyword, status, target);
    }

    // 공개용 공지 목록 API (로그인 불필요)
    @GetMapping("/api/notice/published")
    @ResponseBody
    public List<NoticeVO> getPublishedNoticeList() {
        return noticeService.getNoticeList(null, "PUBLISHED", null);
    }

    // 상세 조회 API
    @GetMapping("/admin/api/notice/{id}")
    @ResponseBody
    public NoticeVO getNotice(@PathVariable Long id) {
        return noticeService.getNoticeById(id);
    }

    // 등록 API
    @PostMapping("/admin/api/notice")
    @ResponseBody
    public Map<String, Object> createNotice(@RequestBody NoticeVO notice,
                                            HttpSession session) {
        AdminVO admin = (AdminVO) session.getAttribute("loginAdmin");
        if (admin != null) {
            notice.setAdminId((long) admin.getId());
        }
        noticeService.insertNotice(notice);
        return Map.of("success", true);
    }

    // 수정 API
    @PutMapping("/admin/api/notice/{id}")
    @ResponseBody
    public Map<String, Object> updateNotice(@PathVariable Long id,
                                            @RequestBody NoticeVO notice) {
        notice.setId(id);
        noticeService.updateNotice(notice);
        return Map.of("success", true);
    }

    // 삭제 API
    @DeleteMapping("/admin/api/notice/{id}")
    @ResponseBody
    public Map<String, Object> deleteNotice(@PathVariable Long id) {
        noticeService.deleteNotice(id);
        return Map.of("success", true);
    }
}