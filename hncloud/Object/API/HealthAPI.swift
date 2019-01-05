//
//  HealthAPI.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import SwiftyJSON
import KRProgressHUD

class HealthAPI: API {
    /// 上傳血糖
    class func bloodsugar(date: String, sugar: SugerData, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "add_bloodsugar.php"
        baseRequest(url, .post, ["date": date,
                                 "fpg_a": sugar.mFasting,
                                 "ppg_a": sugar.mAfer,
                                 "fpg_p": sugar.lFasting,
                                 "ppg_p": sugar.lAfer,
                                 "fpg_n": sugar.dFasting,
                                 "ppg_n": sugar.dAfer,
                                 "before_sleep": sugar.sBefore,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 血糖查詢
    class func search(bloodsugar date: String, _ completionHandler: ((JSON) -> Void)?, error: ((NSError) -> Void)?) {
        let url = domain + "search_bloodsugar.php"
        baseRequest(url, .post, ["date": date,
                                 "sid": UserInfo.share.sid], completionHandler, error)
    }
    /// 上傳血壓、心率、血氧
    class func pressure(sys: String, dia: String, heartrate: String, spo: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "add_bloodpressure.php"
        baseRequest(url, .post, ["sid": UserInfo.share.sid,
                                 "spo2": spo,
                                 "sys": sys,
                                 "heartrate": heartrate,
                                 "dia": dia], completionHandler)
    }
    /// 上傳校正血壓
    class func update(pressure sys: Int, dia: Int, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "search_bloodsugar.php"
        baseRequest(url, .post, ["sys": sys,
                                 "dia": dia,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳整天心率(24小時) add_heartrate24.php
    class func heartrate(date: String, rate: [String], _ completionHandler: ((JSON) -> Void)?) {
        if rate.count != 24 {
            KRProgressHUD.showMessage("心律小於24組")
            return
        }
        let url = domain + "search_bloodsugar.php"
        baseRequest(url, .post, ["date": date,
                                 "gender": UserInfo.share.gender.apiValue,
                                 "t01": rate[0],
                                 "t02": rate[1],
                                 "t03": rate[2],
                                 "t04": rate[3],
                                 "t05": rate[4],
                                 "t06": rate[5],
                                 "t07": rate[6],
                                 "t08": rate[7],
                                 "t09": rate[8],
                                 "t10": rate[9],
                                 "t11": rate[10],
                                 "t12": rate[11],
                                 "t13": rate[12],
                                 "t14": rate[13],
                                 "t15": rate[14],
                                 "t16": rate[15],
                                 "t17": rate[16],
                                 "t18": rate[17],
                                 "t19": rate[18],
                                 "t20": rate[19],
                                 "t21": rate[20],
                                 "t22": rate[21],
                                 "t23": rate[22],
                                 "t24": rate[23],
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳總步數、卡路里、里程
    class func uploadSteps(date: String, steps: String, calories: String, mileage: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_sports.php"
        baseRequest(url, .post, ["date": date,
                                 "steps":steps,
                                 "calories": calories,
                                 "mileage": mileage,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳每小時步數
    class func uploadStepsHour(date: String, hour24: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_steps.php"
        baseRequest(url, .post, ["date": date,
                                 "hour24":hour24,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳每小時卡路里
    class func uploadCaloriesHour(date: String, hour24: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_calories.php"
        baseRequest(url, .post, ["date": date,
                                 "hour24":hour24,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳每小時疲勞度
    class func uploadFatigueHour(date: String, hour24: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_fatigue.php"
        baseRequest(url, .post, ["date": date,
                                 "hour24":hour24,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳每小時疲勞度
    class func uploadSleepHour(date: String, hour12: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_sleep.php"
        baseRequest(url, .post, ["date": date,
                                 "hour12":hour12,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳風險管理
    class func uploadHealthCare(date: String, time: String, health: String, elasticity: String, cycle: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_healthcare.php"
        baseRequest(url, .post, ["date": date,
                                 "time": time,
                                 "health": health,
                                 "elasticity": elasticity,
                                 "cycle": cycle,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
}
