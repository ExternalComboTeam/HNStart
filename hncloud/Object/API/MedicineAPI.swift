//
//  MedicineAPI.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import SwiftyJSON

class MedicineAPI: API {
    /// 健保查詢
    class func health(no: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "search_no.php"
        baseRequest(url, .post, ["no": no], completionHandler)
    }
    /// 藥品查詢
    class func search(key: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "search_drug.php"
        baseRequest(url, .post, ["name": key,
                                 "limit": 30,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳用藥紀錄
    class func use(no: String, time: Date, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "add_drugrecord.php"
        baseRequest(url, .post, ["sid": UserInfo.share.sid,
                                 "no": no,
                                 "date": time.string(withFormat: "yyyy-MM-dd"),
                                 "time": time.string(withFormat: "HH:mm")], completionHandler)
    }
    /// 查詢用藥紀錄
    class func searchUse(date: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "search_drugrecord.php"
        baseRequest(url, .post, ["date": date,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
}
