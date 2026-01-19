package com.gorani.vroom.sample;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class SampleController {

    @GetMapping("/sample")
    public void sample(){

    }

    @Autowired
    private DataSource dataSource;

    @GetMapping("/dbTest.do")
    @ResponseBody
    public String dbTest() {

        log.info("===== DB 연결 테스트 시작 =====");

        try (Connection conn = dataSource.getConnection()) {
            log.info("DB 연결 성공");
            log.info("Connection = " + conn);
        } catch (Exception e) {
            log.error("DB 연결 실패", e);
            return "DB CONNECT FAIL";
        }

        log.info("===== DB 연결 테스트 종료 =====");
        return "DB CONNECT OK";
    }
}
