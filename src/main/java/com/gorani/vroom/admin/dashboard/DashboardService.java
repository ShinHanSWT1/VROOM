package com.gorani.vroom.admin.dashboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    @Autowired
    private DashboardMapper mapper;

    public DashboardSummaryVO getSummary(){
        return mapper.getSummary();
    }
}
