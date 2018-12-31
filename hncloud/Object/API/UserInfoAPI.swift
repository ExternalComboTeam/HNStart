//
//  UserInfoAPI.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import SwiftyJSON

class UserInfoAPI: API {
    /// 註冊
    class func register(account: String, password: String, email: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "add_account.php"
        baseRequest(url, .post, ["account": account,
                                 "password": password,
                                 "password2": password,
                                 "email": email], completionHandler)
    }
    /// 登入
    class func login(account: String, password: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "login.php"
        baseRequest(url, .post, ["account": account,
                                 "password": password], completionHandler)
    }
    /// 忘記密碼
    class func forget(account: String, email: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_newpassword.php"
        baseRequest(url, .post, ["account": account,
                                 "email": email], completionHandler)
    }
    /// 修改密碼
    class func modify(password old: String, new password: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_password.php"
        baseRequest(url, .post, ["oldpassword": old,
                                 "password": password,
                                 "password2": password,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 更新個人資料
    class func update(nickName: String, gender: SexType, birthday: String, height: Int, width: Int, unit: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_account.php"
        baseRequest(url, .post, ["nickname": nickName,
                                 "gender": gender.apiValue,
                                 "birthday": birthday,
                                 "sid": UserInfo.share.sid,
                                 "height": height,
                                 "weight": width,
                                 "unit": unit], completionHandler)
    }
    /// 上傳圖片
    class func upload(image: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_image.php"
        baseRequest(url, .post, ["file:": image,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
    /// 上傳設備
    class func update(device: String, _ completionHandler: ((JSON) -> Void)?) {
        let url = domain + "set_pid.php"
        baseRequest(url, .post, ["pid:": device,
                                 "sid": UserInfo.share.sid], completionHandler)
    }
}
