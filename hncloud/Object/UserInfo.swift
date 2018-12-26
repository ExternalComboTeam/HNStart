//
//  UserInfo.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KeychainSwift

enum DeviceType {
    case Wristband
    case Watch
    case none
    
    var rawValue: String {
        switch self {
        case .Wristband:
            return "手環".localized()
        case .Watch:
            return "手錶".localized()
        default:
            return ""
        }
    }
    
    var image: UIImage? {
        switch self {
        case .Wristband:
            return UIImage(named: "brachlet_hr")
        case .Watch:
            return UIImage(named: "brachlet_blood")
        default:
            return nil
        }
    }
    
    var setType: String {
        switch self {
        case .Wristband:
            return "b".localized()
        case .Watch:
            return "w".localized()
        default:
            return ""
        }
    }
    
    static func getType(by value: String) -> DeviceType {
        switch value {
        case "b".localized():
            return .Wristband
        case "w".localized():
            return .Watch
        default:
            return .none
        }
    }
}

class UserInfo: NSObject {
    static var share: UserInfo {
        return AppDelegate.share.userInfo
    }
    
    private let keychain = KeychainSwift()
    
    var account: String {
        set {
            self.keychain.set(newValue, forKey: "account")
        }
        get {
            return self.keychain.get("account") ?? ""
        }
    }
    
    var isLogin: Bool {
        return !(self.keychain.get("account") ?? "").isEmpty
    }
    
    var deviceType: DeviceType {
        set {
            self.keychain.set(newValue.setType, forKey: "choseType")
        }
        get {
            return DeviceType.getType(by: self.keychain.get("choseType") ?? "")
        }
    }
    var deviceToken: String {
        set {
            self.keychain.set(newValue, forKey: "deviceToken")
        }
        get {
            return self.keychain.get("deviceToken") ?? ""
        }
    }
    var isConnect: Bool {
        return (self.keychain.get("deviceToken") ?? "") != "未綁定".localized()
    }
    
    func clear() {
        self.keychain.clear()
    }
}
