package com.gorani.vroom.location;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // json 데이터 반환
@RequestMapping("/location")
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/getDongs")
    @ResponseBody
    public List<LegalDongVO> getDongs(@RequestParam("gunguName") String gunguName) {
        List<LegalDongVO> result = locationService.getDongList(gunguName);
        return result;
    }
}
