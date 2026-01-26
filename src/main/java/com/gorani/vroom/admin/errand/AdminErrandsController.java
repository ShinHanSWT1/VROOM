package com.gorani.vroom.admin.errand;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminErrandsController {

//    private final AdminErrandsService service;

    @GetMapping("/admin/errands")
    public String erranders(Model model) {

        return "admin/errands";
    }

}
