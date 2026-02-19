package com.gorani.vroom.admin.notice;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminNoticeMapper {
    List<NoticeVO> getNoticeList(@Param("keyword") String keyword,
                                 @Param("status") String status,
                                 @Param("target") String target);

    NoticeVO getNoticeById(@Param("id") Long id);

    void insertNotice(NoticeVO notice);

    void updateNotice(NoticeVO notice);

    void deleteNotice(@Param("id") Long id);
}
