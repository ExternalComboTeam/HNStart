//
//  HealthAPI.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import SwiftyJSON

class HealthAPI: API {
    /// 上傳血糖
    class func bloodsugar(_ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "add_bloodsugar.php"
        baseRequest(url, .post, ["date": "",
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 血糖查詢
    class func search(bloodsugar date: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "search_bloodsugar.php"
        baseRequest(url, .post, ["date": date,
                                 "sid": UserInfo.share.sid], completionHandler)
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
    class func heartrate(date: String, time: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "search_bloodsugar.php"
        baseRequest(url, .post, ["date": date,
                                 "gender": UserInfo.share.gender.apiValue,
                                 "t01 - t24": time,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    ///
}
