//
//  SleepModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/24.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit

class SleepModel: NSObject {
    
    /// 数据时间，格式为秒数
    var timeSeconds: Int
    
    /// 浅睡时间
    var lightSleepTime: Int
    
    /// 深睡时间
    var deepSleepTime: Int
    
    /// 睡眠中清醒时间
    var awakeSleepTime: Int
    
    /// 睡眠具体情况数组
    var sleepArary: [Int]
    
    init(timeSeconds: Int,
         lightSleepTime: Int,
         deepSleepTime: Int,
         awakeSleepTime: Int,
         sleepArary: [Int]) {
        
        self.timeSeconds = timeSeconds
        self.lightSleepTime = lightSleepTime
        self.deepSleepTime = deepSleepTime
        self.awakeSleepTime = awakeSleepTime
        self.sleepArary = sleepArary
        
        super.init()
    }
}
