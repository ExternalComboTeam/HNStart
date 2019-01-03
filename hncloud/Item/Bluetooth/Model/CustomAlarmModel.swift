//
//  CustomAlarmModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/24.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit

enum AlarmType: Int {
    // 运动
    case movement = 1
    // 约会
    case date
    // 喝水
    case drink
    // 吃药
    case takeMedicion
    // 睡觉
    case sleep
    // 自定义
    case custom
}

class CustomAlarmModel: NSObject {
    
    var index: Int
    var type: AlarmType
    var timeArray: [String]
    var repeatArray: [Int]
    var noticeString: String?
    
    init(index: Int,
         type: AlarmType,
         timeArray: [String],
         repeatArray: [Int],
         noticeString: String? = nil) {
        
        self.index = index
        self.type = type
        self.timeArray = timeArray
        self.repeatArray = repeatArray
        self.noticeString = noticeString
        
        super.init()
    }
}
