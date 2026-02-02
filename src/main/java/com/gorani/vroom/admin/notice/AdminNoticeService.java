package com.gorani.vroom.admin.notice;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminNoticeService {

    private final AdminNoticeMapper noticeMapper;

    public List<NoticeVO> getNoticeList(String keyword, String status, String target){
        return noticeMapper.getNoticeList(keyword, status, target);
    }

    public NoticeVO getNoticeById(Long id) {
        return noticeMapper.getNoticeById(id);
    }

    public void insertNotice(NoticeVO notice) {
        noticeMapper.insertNotice(notice);
    }

    public void updateNotice(NoticeVO notice) {
        noticeMapper.updateNotice(notice);
    }

    public void deleteNotice(Long id) {
        noticeMapper.deleteNotice(id);
    }
}
