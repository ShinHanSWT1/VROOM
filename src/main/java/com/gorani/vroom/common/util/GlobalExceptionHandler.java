package com.gorani.vroom.common.util;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(IllegalStateException.class)
    public Object handleIllegalState(IllegalStateException e, HttpServletRequest req) {

        // AJAX 요청(또는 fetch) 판별: 필요하면 더 정확히 커스텀 가능
        String accept = req.getHeader("Accept");
        String xrw = req.getHeader("X-Requested-With");

        boolean isAjax = (xrw != null && xrw.equalsIgnoreCase("XMLHttpRequest"))
                || (accept != null && accept.contains("application/json"));

        if (isAjax) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new ErrorResponse("ALREADY_MATCHED", "이미 매칭된 심부름입니다."));
        }

        ModelAndView mv = new ModelAndView("errand/errand_already_matched");
        mv.addObject("message", "이미 매칭된 심부름입니다.");
        mv.setStatus(HttpStatus.CONFLICT);
        return mv;
    }

    // 간단 DTO
    static class ErrorResponse {
        public String code;
        public String message;
        public ErrorResponse(String code, String message) {
            this.code = code;
            this.message = message;
        }
    }
}
