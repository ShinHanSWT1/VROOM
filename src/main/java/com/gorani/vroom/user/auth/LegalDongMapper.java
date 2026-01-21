package com.gorani.vroom.user.auth;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LegalDongMapper {

    List<LegalDongVO> selectDongByGu(@Param("gu") String gu);

}