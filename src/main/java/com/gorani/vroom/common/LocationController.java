package com.gorani.vroom.common;

import com.gorani.vroom.community.LegalDongVO;
import com.gorani.vroom.community.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController // json 데이터 반환
@RequestMapping("/location")
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("getDongs")
    public List<LegalDongVO> getDongs(@RequestParam("gunguName") String gunguName) {
        List<LegalDongVO> dongList = locationService.getDongList(gunguName);

        return dongList;
    }
}
