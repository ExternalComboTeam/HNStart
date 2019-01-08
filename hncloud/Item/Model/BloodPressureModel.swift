//
//  BloodPressureModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class BloodPressureModel: NSObject {
    /*唯一的id   用于。存  删 */
    var bloodPressureID = ""
    /* 血压日期 */
    var bloodPressureDate = ""
    /* 血压记录时间 */
    var startTime = ""
    /* 收缩压 */
    var systolicPressure = ""
    /* 舒张压 */
    var diastolicPressure = ""
    /*  心率   1   heartRate */
    var heartRate = ""
    /*血氧 */
    var spo2 = ""
    /* 疲劳度 */
    var hrv = ""
    var deviceId = ""
    var deviceType = ""
    var isUp = ""
    // CurrentUserName_HCH
    var userName = ""

    class func setValueWithDictionary(_ dictionary: [String : Any]) -> BloodPressureModel {
        
        let model = BloodPressureModel()
        model.bloodPressureID = dictionary["BloodPressureID"] as? String ?? ""
        model.bloodPressureDate = dictionary["BloodPressureDate"] as? String ?? ""
        model.startTime = dictionary["StartTime"] as? String ?? ""
        model.systolicPressure = dictionary["systolicPressure"] as? String ?? ""
        model.diastolicPressure = dictionary["diastolicPressure"] as? String ?? ""
        model.heartRate = dictionary["heartRate"] as? String ?? ""
        model.spo2 = dictionary["SPO2"] as? String ?? ""
        model.hrv = dictionary["HRV"] as? String ?? ""
        
        model.isUp = dictionary[GlobalProperty.ISUP] as? String ?? ""
        model.deviceId = dictionary[GlobalProperty.DEVICEID] as? String ?? ""
        model.deviceType = dictionary[GlobalProperty.DEVICETYPE] as? String ?? ""
        #if DEBUG
        print("---\(model)")
        #endif
        
        return model
        
    }

    /**
     *
     *
     *数组转化为字典
     *
     **/
    class func array(toDictionary array: [[String: Any]]) -> [String : Any]? {
        
        guard var lastDic = array.last else {
            return nil
        }
        
        guard let time = lastDic["StartTime"],
            let systolic = lastDic["systolicPressure"],
            let diastolic = lastDic["diastolicPressure"],
            let heartRate = lastDic["heartRateNumber"],
            let sp02 = lastDic["SPO2"],
            let hrv = lastDic["HRV"] else {
                return nil
        }

        let returnDic: [String : Any] = ["time": time,
                                         "Systolic": systolic,
                                         "Diastolic": diastolic,
                                         "HeartRate": heartRate,
                                         "SPO2": sp02,
                                         "HRV": hrv]
        let mutDic = returnDic
        return mutDic
        
        //    for (NSDictionary *dd in array)
        //    {
        //        NSMutableDictionary *TotalDict =[NSMutableDictionary dictionary];
        //        NSMutableDictionary *tempDict =[NSMutableDictionary dictionary];
        //        [tempDict setValue:dd[@"systolicPressure"] forKey:@"Systolic"];
        //        [tempDict setValue:dd[@"diastolicPressure"] forKey:@"Diastolic"];
        //        [tempDict setValue:dd[@"heartRateNumber"] forKey:@"HeartRate"];
        //        [tempDict setValue:dd[@"SPO2"] forKey:@"SPO2"];
        //        [tempDict setValue:dd[@"HRV"] forKey:@"HRV"];
        //
        //        [TotalDict setValue:tempDict forKey:dd[@"StartTime"]];
        //
        //        [dict addEntriesFromDictionary:TotalDict];
        //    }
        
        
    }
    
    func description() -> String? {
        return "BloodPressureID = \(bloodPressureID),BloodPressureDate = \(bloodPressureDate),StartTime = \(startTime),systolicPressure = \(systolicPressure),diastolicPressure = \(diastolicPressure),heartRate = \(heartRate),SPO2 = \(spo2),HRV = \(hrv) "
    }

    

    /**
     把对象转化为可以storage  的字典
     */
    class func model(toStorageDict dict: [String : Any]) -> [String : Any] {
        
        var dictionary = dict
        dictionary[GlobalProperty.ISUP] = "1"
        
        //    [dictionary setValue:self.BloodPressureID forKey:BloodPressureID_def];
        //    [dictionary setValue:self.BloodPressureDate forKey:BloodPressureDate_def];
        //    [dictionary setValue:self.StartTime forKey:StartTime_def];
        //    [dictionary setValue:self.systolicPressure forKey:systolicPressure_def];
        //    [dictionary setValue:self.diastolicPressure forKey:diastolicPressure_def];
        //    [dictionary setValue:self.heartRate forKey:heartRateNumber_def];
        //    [dictionary setValue:self.SPO2 forKey:SPO2_def];
        //    [dictionary setValue:self.HRV forKey:HRV_def];
        //
        //    [dictionary setValue:self.deviceId forKey:DEVICEID];
        //    [dictionary setValue:self.deviceType forKey:DEVICETYPE];
        
        //    [dictionary setValue:[[HCHCommonManager getInstance]UserAcount] forKey:CurrentUserName_HCH];
        return dictionary
        
    }

    /**
     把下载的数据转化为对象
     */
    
    class func model(withDictionary dictonary: [String : Any], key: String) -> [String : Any]? {
        //    BloodPressureModel *model = [[BloodPressureModel alloc]init];
        //    model.StartTime = key;
        //    model.BloodPressureDate = [key substringToIndex:10];
        //    model.systolicPressure = dictonary[@"Systolic"];
        //    model.diastolicPressure = dictonary[@"Diastolic"];
        //    model.heartRate = dictonary[@"HeartRate"];
        //    model.SPO2 = dictonary[@"SPO2"];
        //    model.HRV = dictonary[@"HRV"];
        //    return model;
        
        //    BloodPressureModel *model = [[BloodPressureModel alloc]init];
        //    model.StartTime = key;
        //    model.BloodPressureDate = [key substringToIndex:10];
        //    model.systolicPressure = dictonary[@"Systolic"];
        //    model.diastolicPressure = dictonary[@"Diastolic"];
        //    model.heartRate = dictonary[@"HeartRate"];
        //    model.SPO2 = dictonary[@"SPO2"];
        //    model.HRV = dictonary[@"HRV"];
        //    return model;
        
        guard let systolic = dictonary["Systolic"],
            let diastolic = dictonary["Diastolic"],
            let heartRate = dictonary["HeartRate"],
            let sp02 = dictonary["SPO2"],
            let hrv = dictonary["HRV"] else {
                
                return nil
        }
        
        let dict = [
            GlobalProperty.StartTime_def : key,
            GlobalProperty.BloodPressureDate_def : (key as NSString).substring(to: 10),
            GlobalProperty.systolicPressure_def : systolic,
            GlobalProperty.diastolicPressure_def : diastolic,
            GlobalProperty.heartRateNumber_def : heartRate,
            GlobalProperty.SPO2_def : sp02,
            GlobalProperty.HRV_def : hrv
        ]
        
        
        return dict
        
    }

}
