//
//  TimeCallManager.swift
//  hncloud
//
//  Created by Hong Shih on 2019/1/1.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class TimeCallManager: NSObject {
    
    static let instance = TimeCallManager()
    
    
    func changeDateTommdde(withSeconds seconds: Int) -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd  E"
        let dateString = dateFormatter.string(from: date)
        return "\(dateString)"
    }
    
    func changeCurDateToItailYYYYMMDDString() -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        return formates.string(from: Date())
    }
    
    func changeDateToItailYYYYMMDDString(withAssign assignDate: Date?) -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        if let assignDate = assignDate {
            return formates.string(from: assignDate)
        }
        return nil
    }
    
    func changeItailYYYYMMDDStringToDate(with itailString: String?) -> Date? {
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        return formates.date(from: itailString ?? "")
    }
    
    func getForwordYYYYMMDDDateString(withAssign assignString: String?) -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        let assignDate: Date? = formates.date(from: assignString ?? "")
        
        var aTimeInterval: TimeInterval? = assignDate?.timeIntervalSinceReferenceDate
        if let _aTimeInterval = aTimeInterval {
            aTimeInterval = _aTimeInterval - 24 * 60 * 60
        }
        let cureDate = Date(timeIntervalSinceReferenceDate: aTimeInterval ?? 0.0)
        
        return formates.string(from: cureDate)
    }
    
    func getBackYYYYMMDDDateString(withAssign assignString: String?) -> String? {
        
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        let assignDate: Date? = formates.date(from: assignString ?? "")
        
        var aTimeInterval: TimeInterval? = assignDate?.timeIntervalSinceReferenceDate
        if let _aTimeInterval = aTimeInterval {
            aTimeInterval = _aTimeInterval + 24 * 60 * 60
        }
        
        let cureDate = Date(timeIntervalSinceReferenceDate: aTimeInterval ?? 0.0)
        
        return formates.string(from: cureDate)
    }
    
    func getYYYYMMDDSecondsSince1970(with seconds: TimeInterval) -> TimeInterval {
        let cDate = Date(timeIntervalSince1970: seconds)
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        let dateStr = formates.string(from: cDate)
        
        let resultDate: Date? = formates.date(from: dateStr)
        return resultDate?.timeIntervalSince1970 ?? 0.0
    }
    
    func getHHmmSecondsSinceCurDay(with seconds: TimeInterval) -> TimeInterval {
        let cDate = Date(timeIntervalSince1970: seconds)
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        let dateStr = formates.string(from: cDate)
        
        let resultDate: Date? = formates.date(from: dateStr)
        
        return resultDate?.timeIntervalSince(cDate) ?? 0.0
    }
    
    func getYYYYMMDDSeconds(with data: Data?) -> TimeInterval {
        
        guard let data = data, data.count == 3 else {
            #if DEBUG
            print("\(#function)\ndata is nil or data.count != 3")
            #endif
            return 0
        }
        
        let transdata = data.bytes
        var timeStr: String? = nil
        if let itemOne = transdata.item(at: 2), let itemTwo = transdata.item(at: 1), let itemThree = transdata.first {
            timeStr = String(format: "20%02d/%02d/%02d", itemOne, itemTwo, itemThree)
        }
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        let resultDate: Date? = formates.date(from: timeStr ?? "")
        return resultDate?.timeIntervalSince1970 ?? 0.0
    }
    
    func getYYYYMMDDHHmmSeconds(with datastr: String?) -> TimeInterval {
        
        let formates = DateFormatter()
        formates.dateFormat = "yyyy-MM-dd HH:mm" //yyyy-MM-dd HH:mm:ss
        let resultDate: Date? = formates.date(from: datastr ?? "")
        return resultDate?.timeIntervalSince1970 ?? 0.0
    }
    
    func getMinutueWithSecond(_ seconds: TimeInterval) -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "mm"
        let date = Date(timeIntervalSince1970: seconds)
        return formates.string(from: date)
    }
    
    func getHourWithSecond(_ seconds: TimeInterval) -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "HH"
        let date = Date(timeIntervalSince1970: seconds)
        return formates.string(from: date)
    }
    
    //获取一个时间和另一个时间点间隔了几个5分钟
    func getIntervalFiveMin(with oritime: Int, andEndTime endTime: Int) -> Int {
        let origDate = Date(timeIntervalSince1970: TimeInterval(oritime))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endTime))
        
        let i = Int(endDate.timeIntervalSince(origDate))
        var index: Int = 0
        
        if i % 300 >= 200 {
            index = i / 300 + 1
        } else {
            index = i / 300 + 1
        }
        
        return index
    }
    
    //获取一个时间和另一个时间点间隔了几个1分钟
    func getIntervalOneMin(with oritime: Int, andEndTime endTime: Int) -> Int {
        let origDate = Date(timeIntervalSince1970: TimeInterval(oritime))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endTime))
        
        let i = Int(endDate.timeIntervalSince(origDate))
        var index: Int = 0
        
        if i % 60 >= 50 {
            index = i / 60 + 1
        } else {
            index = i / 60
        }
        
        return index
    }
    
    //两个时间间隔一天 YES 否则为NO
    func aday(with oritime: Int, andEndTime endTime: Int) -> Bool {
        var ret = false
        let origDate = Date(timeIntervalSince1970: TimeInterval(oritime))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endTime))
        
        let i = Int(endDate.timeIntervalSince(origDate))
        var index: Int = 0
        index = i / 1440
        if index > 0 {
            ret = true
        }
        return ret
    }
    
    //获取一个时间和另一个时间点间隔了几个5秒钟
    func getIntervalFiveSecond(with oritime: Int, andEndTime endTime: Int) -> Int {
        let origDate = Date(timeIntervalSince1970: TimeInterval(oritime))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endTime))
        
        let i = Int(endDate.timeIntervalSince(origDate))
        var index: Int = 0
        
        index = i / 5
        return index
    }
    
    //获取一个时间和另一个时间点间隔了多少秒
    func getIntervalSecond(with oritime: Int, andEndTime endTime: Int) -> Int {
        let origDate = Date(timeIntervalSince1970: TimeInterval(oritime))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endTime))
        
        let i = Int(endDate.timeIntervalSince(origDate))
        return i
    }
    
    //获取时间是当年的第几周
    func getWeekIndexInYear(with senconds: Int) -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(senconds))
        let calendar = Calendar.current
        let comps = calendar.component(.weekOfYear, from: date)
        let weekIndex = comps
        
        return weekIndex
    }
    
    //根据格式和时间字符串获取秒数
    func getSecondsWithTime(_ timeStr: String?, andFormat format: String?) -> TimeInterval {
        let formates = DateFormatter()
        formates.dateFormat = format ?? ""
        let resultDate: Date? = formates.date(from: timeStr ?? "")
        return resultDate?.timeIntervalSince1970 ?? 0.0
    }
    
    //根据秒数和格式获取时间字符串
    func timeAddition(withTime timeStr: String?, andSeconed seconed: Int) -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let resultDate = formates.date(from: timeStr ?? "") {
            var time = resultDate.timeIntervalSinceNow
            time += TimeInterval(seconed)
            let date = Date(timeIntervalSinceNow: time)
            return formates.string(from: date)
        }
        return nil
    }
    
    //根据秒数和格式获取时间字符串 ++ 这个可以对的时间
    func getTimeString(withSeconds seconds: Int, andFormat format: String) -> String {
        let formates = DateFormatter()
        formates.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        return formates.string(from: date)
    }
    
    //获取当前天时间的秒数
    func getSecondsOfCurDay() -> TimeInterval {
        let eDate = Date()
        let formates = DateFormatter()
        formates.dateFormat = "yyyy/MM/dd"
        let string = formates.string(from: eDate)
        return getSecondsWithTime(string, andFormat: "yyyy/MM/dd")
    }
    
    func getYearWithSecond(_ seconds: TimeInterval) -> String? {
        let formates = DateFormatter()
        formates.dateFormat = "yyyy"
        let date = Date(timeIntervalSince1970: seconds)
        return formates.string(from: date)
    }
    
    //获取当前 的秒数
    func getNowSecond() -> TimeInterval {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        let resultDate: Date? = dateFormatter.date(from: dateString)
        let timeOne: TimeInterval? = resultDate?.timeIntervalSince1970
        //    NSTimeInterval timeTwo = [resultDate timeIntervalSinceNow];
        
        //    //adaLog(@"timeOne= %f ,timeTwo= %f",timeOne,timeTwo);
        //   NSString *str = [self getTimeStringWithSeconds:timeOne andFormat:@"yyyy-MM-dd HH:mm:ss"];
        //    //adaLog(@"str = %@",str);
        return timeOne ?? 0.0
    }
    
    
}
