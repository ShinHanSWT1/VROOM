package com.gorani.vroom.location;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/location")
@RequiredArgsConstructor
public class LocationController {

    private final LocationService locationService;

    @GetMapping("/getDongs")
    public List<LegalDongVO> getDongs(@RequestParam("gunguName") String gunguName) {
        return locationService.getDongList(gunguName);
    }
}
