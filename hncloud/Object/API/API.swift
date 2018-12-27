//
//  API.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON
import KRProgressHUD

class API {
    static let domain = "http://18.220.225.195/horncloud/api/"
    
    class func baseRequest(_ url: String,
                           _ method: HTTPMethod = .get,
                           _ parameters: [String : Any]? = nil,
                           _ completionHandler: ((JSON) -> Void)? = nil,
                           _ errorHandler: ((NSError) -> Void)? = defaultErrorHandler) {
        
        let headers: HTTPHeaders? = [:]
        
        #if DEBUG
        print("============ API ============")
        print("URL: \(url) (\(method))")
        print("BODY: \(parameters?.jsonString() ?? "NULL")")
        #endif
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // FIXME: Alamofire framework
        let manager = Alamofire.SessionManager.default
        
        manager.request(url,
                        method: method,
                        parameters: parameters,
                        encoding: URLEncoding.default,
                        headers: headers)
            .responseSwiftyJSON { (dataResponse) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if let json = dataResponse.result.value {
                    #if DEBUG
                    print("========== Response ==========")
                    print("URL: \(url) (\(method))")
                    print("DAT: \(json)")
                    #endif
                    if let success = json["success"].int, let msg = json["message"].string {
                        if success == 1 {
                            completionHandler?(json["data"])
                        } else {
                            let userinfo:[String:Any] = [
                                NSLocalizedDescriptionKey : "",
                                NSLocalizedFailureReasonErrorKey : msg
                            ]
                            let error = NSError(domain:"API.response.failed",
                                                code: 400,
                                                userInfo: userinfo)
                            errorHandler?(error)
                        }
                    } else {
                        completionHandler?(json["data"])
                    }
                } else {
                    #if DEBUG
                    print("======= Response Error =====>>")
                    print("URL: \(url) (\(method))")
                    if let data = dataResponse.data {
                        print(String(data: data, encoding: .utf8) ?? "NULL")
                    } else {
                        print("沒有資料")
                    }
                    print("<<===== Response Error =======")
                    #endif
                    errorHandler?(dataResponse.result.error! as NSError)
                }
        }
        
    }
    
    class func defaultErrorHandler(_ error: NSError) -> Void {
        KRProgressHUD.dismiss {
            let title: String = "抱歉。".localized() + "系統忙碌中，請稍後瀏覽".localized()
            var message = error.localizedDescription.isEmpty ? nil : error.localizedDescription
            if error.code == 4 {
                message = "系統忙碌中，無法讀取資料。"
            }
            
            guard let visible = UIApplication.shared.keyWindow?.visibleViewController, !(visible is UIAlertController) else { return }
            
            UIAlertController(title: error.localizedFailureReason ?? title,
                              message: message,
                              defaultActionButtonTitle: "好",
                              tintColor: nil).show()
        }
    }
}
