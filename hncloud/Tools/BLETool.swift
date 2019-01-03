//
//  BLETool.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

let isZhHans = NSLocale.preferredLanguages.first?.hasPrefix("zh-Hans")
let isTH = NSLocale.preferredLanguages.first?.hasPrefix("th")

class BLETool: NSObject {
    
    /*
     
     *      只有B7才发送天气 ，不是B7
     
     */
    class func sendWeatherFilter() -> Bool {
        var isCan = false
        
        if let str = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceNAME) {
            //adaLog(@"strB7 = %@",str);//@"B7"
            if .orderedSame == str.compare("B7", options: .caseInsensitive, range: Range(NSRange(location: 0, length: 2), in: str), locale: .current) {
                isCan = true
            }
            if UserDefaults.standard.integer(forKey: GlobalProperty.WEATHERSUPPORT) == 1 {
                isCan = true
            }
        }
        
        return isCan
    }
    
    /*
     
     *     判断系统是什么语言。我们应该用那个语言
     
     */
    class func setLanguageTool() -> Int {
        var langage: Int = 0 //默认中文
        if let isZhHans = isZhHans, isZhHans {
            langage = 1 // 不是中文就是英文
        }
        if let isTH = isTH, isTH {
            langage = 2 // 如果是泰语就是泰语
        }
        return langage
    }
    
    /*
     
     *    地点  最大24个字节
     
     */
    class func checkLocaleLength(_ localeData: Data?) -> Data? {
        var localeData = localeData
        
        if (localeData?.count ?? 0) > 24 {
            localeData = localeData?.subdata(in: 0..<24)
        }
        return localeData
    }
    
    /*
     
     *    天气内容  最大48个字节
     
     */
    class func checkWeatherContentLength(_ weatherContentData: Data?) -> Data? {
        var weatherContentData = weatherContentData
        
        if (weatherContentData?.count ?? 0) > 48 {
            weatherContentData = weatherContentData?.subdata(in: 0..<48)
        }
        return weatherContentData
    }
    
    /*
     
     *    计算发送超时的时间。
     
     */
    class func countSendtimeOut(with sendL: CGFloat, andReceive receiveL: CGFloat) -> CGFloat {
        var timeOut: CGFloat = 0.0
        timeOut = max(sendL, receiveL) * 70.0 + 100.0 + CGFloat(Int(arc4random()) % 100)
        timeOut /= 1000.0
        return timeOut
    }
    
    /*
     
     *   计算延时多长时间重发数据
     
     */
    //+(int)delayResendTimeWithLength:(int)dataLength
    //{
    //
    //}
    
    
    //日月： 2
    //月日： 1
    class func getMMDDformat() -> Int {
        var num: Int = 2
        let lanString = NSLocale.preferredLanguages.first
        if lanString?.hasPrefix("en") ?? false {
            num = 1
        } else if lanString?.hasPrefix("ko") ?? false {
            num = 1
        } else if lanString?.hasPrefix("ja") ?? false {
            num = 1
        } else if lanString?.hasPrefix("zh") ?? false {
            num = 1
        }
        return num
    }
    
}
