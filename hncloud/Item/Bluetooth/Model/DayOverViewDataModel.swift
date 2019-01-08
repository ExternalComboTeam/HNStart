//
//  DayOverViewDataModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/24.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit

class DayOverViewDataModel: NSObject {
    
    /// 數據日期，格式為秒數 [NSDate dateWithTimeIntervalSince1970:seconds] 可轉化為 date
    var timeSeconds: Int
    
    /// 全天總步數
    var steps: Int
    
    /// 全天里程，单位为米
    var meters: Int
    
    /// 全天消耗卡路里
    var costs: Int
    
    /// 全天运动时长
    var activityTime: Int
    
    /// 全天静坐时长
    var calmTime: Int
    
    /// 全天运动消耗
    var activityCosts: Int
    
    /// 全天静坐消耗
    var calmCosts: Int
    
    init(timeSeconds: Int,
         steps: Int,
         meters: Int,
         costs: Int,
         activityTime: Int,
         calmTime: Int,
         activityCosts: Int,
         calmCosts: Int) {
        
        self.timeSeconds = timeSeconds
        self.steps = steps
        self.meters = meters
        self.costs = costs
        self.activityTime = activityTime
        self.calmTime = calmTime
        self.activityCosts = activityCosts
        self.calmCosts = calmCosts
     
        super.init()
    }
}
