//
//  PZWeatherModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class PZWeatherModel: NSObject {

    /// 日期
    var weatherDate = ""
    /// 时间
    var realtimeShi = ""
    /// 地点
    var weather_city = ""
    /// 天气类型
    var weatherType = ""
    /// 天气内容
    var weatherContent = ""
    /// 天气内容
    var weatherCode = ""
    /// 温度范围
    var weatherMax = ""
    /// 温度范围
    var weatherMin = ""
    /// 当前温度
    var weather_currentTemp = ""
    /// 紫外线
    var weather_uv = ""
    /// 风力
    var weather_fl = ""
    /// 风向
    var weather_fx = ""
    /// 空气质量
    var weather_aqi = ""
    ///  温度array
    var tempArray: [String] = []
    /// 城市id
    var city_id = ""
 
    //@property (strong, nonatomic) NSString *weather_fl1;
}
