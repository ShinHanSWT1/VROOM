package com.gorani.vroom.admin.issue;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminIssueMapper {
    Map<String, Object> getSummary();

    List<Map<String, Object>> getIssueCountByType();

    List<Map<String, Object>> searchIssues(Map<String, Object> param);

    int countIssue(Map<String, Object> param); // 페이징 카운트 추가
    int updateIssuePriority(Map<String, Object> param); // 우선순위 변경 추가
}
