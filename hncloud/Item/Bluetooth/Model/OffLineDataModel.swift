//
//  OffLineDataModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/24.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit

class OffLineDataModel: NSObject {
    
    /// 离线事件的日期 格式为秒数 [NSDate dateWithTimeIntervalSince1970:seconds]可转化为date
    var timeSeconds: Int?
    
    /// 离线运动开始时间 格式为秒数 [NSDate dateWithTimeIntervalSince1970:seconds]可转化为date
    var startSeconds: Int?
    
    /// 离线运动结束时间 格式为秒数 [NSDate dateWithTimeIntervalSince1970:seconds]可转化为date
    var stopSeconds: Int?
    
    /// 离线运动 步数
    var steps: Int?
    
    /// 离线运动消耗
    var costs: Int?
}
