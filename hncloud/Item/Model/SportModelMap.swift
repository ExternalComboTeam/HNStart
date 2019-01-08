//
//  SportModelMap.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

enum sportStrength : Int {
    case warmUp = 0
    case aerobic
    case anaerobic
    case fatBurning
    case limit
}

//typedef enum {
//    NSAFRequest_GET   = 0,
//    NSAFRequest_POST,
// }NSAFRequestType;

class SportModelMap: NSObject {
    /*唯一的id   用于。存  删 */
    var sportID = ""
    var sportType = ""
    var sportDate = ""
    var sportName = ""
    var fromTime = ""
    var toTime = ""
    //  心率   1   heartRate
    var heartRate = ""
    /*用于存储   每分钟的心率。一分钟一个心率。 */
    var heartRateArray: [String] = []
    //当前步数  4  stepNumber
    var stepNumber = ""
    //当前里程  4  mileageNumber
    var mileageNumber = ""
    //当前消耗热量    4  kcalNumber
    var kcalNumber = ""
    //当前步速  1   stepSpeed
    var stepSpeed = ""
    // CurrentUserName_HCH
    var userName = ""
    var deviceId = ""
    var deviceType = ""
    var isUp = ""
    /**
     *  数据日期,格式为秒数 [NSDate dateWithTimeIntervalSince1970:seconds]可转化为date
     */
     /*用于存离线数据的时间。以后截取离线运动的心率事件 */
    var timeSeconds: Int = 0
    var startTimeSeconds: Int = 0
    var stopTimeSeconds: Int = 0
    var sportStrength: sportStrength?
    var haveTrail = ""
    var trailArray: [String] = []
    var moveTarget = ""
    //@property (nonatomic,strong) NSString * mileageM;
    var mileageM_map = ""
    /*配速 */
    var sportPace = ""
    /*时长 */
    var whenLong = ""
    //时长
    var falseData = ""
    
    
    
    class func setValueWithDictionary(_ dictionary: [String : Any]) -> SportModelMap {
        
        let model = SportModelMap()
        model.sportID = dictionary["sportID"] as? String ?? ""
        model.sportType = dictionary["sportType"] as? String ?? ""
        model.sportDate = dictionary["sportDate"] as? String ?? ""
        model.fromTime = dictionary["fromTime"] as? String ?? ""
        model.toTime = dictionary["toTime"] as? String ?? ""
        if let heartRate = dictionary["heartRate"] as? Data {
            model.heartRateArray = NSKeyedUnarchiver.unarchiveObject(with:heartRate) as? [String] ?? []
        }
        model.heartRateArray = NSKeyedUnarchiver.unarchiveObject(with:dictionary["heartRate"] as! Data) as! [String]
        model.stepNumber = dictionary["stepNumber"] as? String ?? ""
        model.mileageNumber = dictionary["mileageNumber"] as? String ?? ""
        model.kcalNumber = dictionary["kcalNumber"] as? String ?? ""
        model.stepSpeed = dictionary["stepSpeed"] as? String ?? ""
        model.sportName = dictionary["sportName"] as? String ?? ""
        ////adaLog(@"model.heartRateArray  -- %@",model.heartRateArray);
        model.userName = dictionary[GlobalProperty.CurrentUserName_HCH] as? String ?? ""
        model.isUp = dictionary[GlobalProperty.ISUP] as? String ?? ""
        model.deviceId = dictionary[GlobalProperty.DEVICEID] as? String ?? ""
        model.deviceType = dictionary[GlobalProperty.DEVICETYPE] as? String ?? ""
        
        model.haveTrail = dictionary[GlobalProperty.HAVETRAIL] as? String ?? ""
        if let data = dictionary[GlobalProperty.TRAILARRAY] as? Data {
            model.trailArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String] ?? []
        }
        model.moveTarget = dictionary[GlobalProperty.MOVETARGET] as? String ?? ""
        model.mileageNumber = dictionary[GlobalProperty.MILEAGEM] as? String ?? ""
        model.mileageM_map = dictionary[GlobalProperty.MILEAGEM_MAP] as? String ?? ""
        model.sportPace = dictionary[GlobalProperty.SPORTPACE] as? String ?? ""
        model.whenLong = dictionary[GlobalProperty.WHENLONG] as? String ?? ""
        
        //    //adaLog(@"sportModel---%@",model);
        return model
        
    }

    /**
     把对象转化为可以上传数据的字典String
     */
    func modelToUpdataDictionary() -> [String : Any] {
        
        var dictionary: [String : Any] = [:]
        var subDictionary: [String : Any] = [:]
        let start: Int = Int(TimeCallManager.instance.getSecondsWithTime(fromTime, andFormat: "yyyy-MM-dd HH:mm:ss"))
        let end: Int = Int(TimeCallManager.instance.getSecondsWithTime(toTime, andFormat: "yyyy-MM-dd HH:mm:ss"))
        let key = "\(start)-\(end)"
        if heartRateArray.isEmpty == false {
            let string = ToolBox.array(toString: heartRateArray)
            subDictionary["heart"] = string
        } else {
            subDictionary["heart"] = "0"
        }
        if kcalNumber.isEmpty == false {
            subDictionary["calorie"] = kcalNumber
        } else {
            subDictionary["calorie"] = "0"
        }
        if stepNumber.isEmpty == false {
            subDictionary["step"] = stepNumber
        } else {
            subDictionary["step"] = "0"
        }
        if sportType.isEmpty == false {
            subDictionary["movementType"] = sportType
        } else {
            subDictionary["movementType"] = "0"
        }
        //    NSString *str = [AllTool dictionaryToJson:subDictionary];
        dictionary[key] = subDictionary
        return dictionary
        
    }

    /**
     把对象转化为可以storage  的字典
     */
    func modelToStorageDictionary() -> [String : Any] {
        
        var dictionary: [String : Any] = [:]
        dictionary["sportID"] = sportID
        dictionary["sportType"] = sportType
        dictionary["sportDate"] = sportDate
        dictionary["fromTime"] = fromTime
        dictionary["toTime"] = toTime
        var data = Data()
        if heartRateArray.isEmpty == false {
            data = NSKeyedArchiver.archivedData(withRootObject: heartRateArray)
        } else {
        }
        dictionary["heartRate"] = data
        dictionary["stepNumber"] = stepNumber
        dictionary["mileageNumber"] = mileageNumber
        dictionary["kcalNumber"] = kcalNumber
        dictionary["stepSpeed"] = stepSpeed
        dictionary["sportName"] = sportName
        
        dictionary[GlobalProperty.DEVICEID] = deviceId
        dictionary[GlobalProperty.DEVICETYPE] = deviceType
        dictionary[GlobalProperty.ISUP] = "1"
        dictionary[GlobalProperty.CurrentUserName_HCH] = HCHCommonManager.instance.userAcount()
        return dictionary
    }

    /**
     把下载的数据转化为对象
     */
    class func model(withDictionary dictonary: [String : Any], key: String) -> SportModelMap? {
        
        let model = SportModelMap()
        var Arr = key.components(separatedBy: "-")
        let startTime = Int(Arr[0])
        let startTimeStr = TimeCallManager.instance.getTimeString(withSeconds: startTime ?? 0, andFormat: "yyyy-MM-dd HH:mm:ss")
        let sportDateStr = TimeCallManager.instance.getTimeString(withSeconds: startTime ?? 0, andFormat: "yyyy-MM-dd")
        let stopTime = Int(Arr[1]) ?? 0
        let stopTimeStr = TimeCallManager.instance.getTimeString(withSeconds: stopTime, andFormat: "yyyy-MM-dd HH:mm:ss")
        model.sportDate = sportDateStr
        model.fromTime = startTimeStr
        model.toTime = stopTimeStr
        model.sportType = dictonary["movementType"] as? String ?? ""
        model.stepNumber = dictonary["step"] as? String ?? ""
        model.kcalNumber = dictonary["calorie"] as? String ?? ""
        model.heartRateArray = (dictonary["heart"] as? String)?.components(separatedBy: ",") ?? []
        
        //    if (!(dictionary[@"mileageNumber"] == [NSNull null]))
        //        model.mileageNumber = [dictionary objectForKey:@"mileageNumber"];
        //    if (!(dictionary[@"stepSpeed"] == [NSNull null]))
        //        model.stepSpeed = [dictionary objectForKey:@"stepSpeed"];
        //    if (!(dictionary[@"sportName"] == [NSNull null]))
        //        model.sportName = [dictionary objectForKey:@"sportName"];
        //    model.isUp = dictionary[ISUP];
        //    model.deviceId = dictionary[DEVICEID];
        //    model.deviceType = dictionary[DEVICETYPE];
        
        return model
        
    }
    
    func description() -> String? {
        return "sportID = \(sportID),sportType = \(sportType),sportDate = \(sportDate),fromTime = \(fromTime),toTime = \(toTime),heartRate = \(heartRate),heartRateArray = \(heartRateArray),stepNumber = \(stepNumber),mileageNumber = \(mileageNumber),kcalNumber = \(kcalNumber),stepSpeed = \(stepSpeed),sportName = \(sportName),deviceId = \(deviceId),deviceType = \(deviceType),isUp = \(isUp),_haveTrail = \(haveTrail),_trailArray = \(trailArray),_moveTarget = \(moveTarget),_mileageM_map = \(mileageM_map),_sportPace = \(sportPace),_whenLong = \(whenLong)" //,_mileageM = %@ _mileageM
    }

}
