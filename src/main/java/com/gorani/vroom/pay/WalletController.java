package com.gorani.vroom.pay;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/pay")
@RequiredArgsConstructor
public class WalletController {
    private final WalletService walletService;

    //
}
