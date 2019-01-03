//
//  WeatherDays.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class WeatherDays: NSObject {
    
    /// 日期
    var weatherDateArray: [Int] = []
    /// 天气类型
    var weatherType = ""
    /// 温度范围
    var weatherMax = ""
    /// 温度范围
    var weatherMin = ""

    func description() -> String? {
        return String(format: "weatherDateArray:%ld,weatherType:%@,weatherMax:%@,_weatherMin:%@", weatherDateArray.count, weatherType, weatherMax, weatherMin)
    }


}
