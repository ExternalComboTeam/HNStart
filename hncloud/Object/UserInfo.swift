//
//  UserInfo.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KeychainSwift
import SwiftyJSON

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

enum SexType {
    case male
    case women
    
    var apiValue: String {
        switch self {
        case .male:
            return "Male"
        default:
            return ""
        }
    }
    static func get(api: String) -> SexType {
        switch api {
        case "":
            return .women
        default:
            return .male
        }
    }
}

class UserInfo: NSObject {
    static var share: UserInfo {
        return AppDelegate.share.userInfo
    }
    
    private let keychain = KeychainSwift()
    
    var sid: String {
        set {
            self.keychain.set(newValue, forKey: "sid")
        }
        get {
            return self.keychain.get("sid") ?? ""
        }
    }
    
    var gender: SexType {
        set {
            self.keychain.set(newValue.apiValue, forKey: "gender")
        }
        get {
            return SexType.get(api: self.keychain.get("gender") ?? "")
        }
    }
    
    var account: String {
        set {
            self.keychain.set(newValue, forKey: "account")
        }
        get {
            return self.keychain.get("account") ?? ""
        }
    }
    var height: String {
        set {
            self.keychain.set(newValue, forKey: "height")
        }
        get {
            return self.keychain.get("height") ?? ""
        }
    }
    var weight: String {
        set {
            self.keychain.set(newValue, forKey: "weight")
        }
        get {
            return self.keychain.get("weight") ?? ""
        }
    }
    var nickName: String {
        set {
            self.keychain.set(newValue, forKey: "nickName")
        }
        get {
            return self.keychain.get("nickName") ?? ""
        }
    }
    var email: String {
        set {
            self.keychain.set(newValue, forKey: "email")
        }
        get {
            return self.keychain.get("email") ?? ""
        }
    }
    
    var isLogin: Bool {
        return !(self.keychain.get("sid") ?? "").isEmpty
    }
    var birthday: String {
        set {
            self.keychain.set(newValue, forKey: "birthday")
        }
        get {
            return self.keychain.get("birthday") ?? ""
        }
    }
    var unit: String {
        set {
            self.keychain.set(newValue, forKey: "unit")
        }
        get {
            return self.keychain.get("unit") ?? ""
        }
    }
    @objc dynamic var deviceChange: Bool = false
    var deviceType: DeviceType {
        set {
            guard DeviceType.getType(by: self.keychain.get("choseType") ?? "") != newValue else { return }
            self.keychain.set(newValue.setType, forKey: "choseType")
            self.deviceChange = !self.deviceChange
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
    
    func update(json: JSON) {
        self.sid = json["sid"].string ?? ""
        self.gender = SexType.get(api: json["gender"].string ?? "")
        self.account = json["account"].string ?? ""
        self.nickName = json["nickname"].string ?? ""
        self.height = json["height"].string ?? ""
        self.weight = json["weight"].string ?? ""
        self.email = json["email"].string ?? ""
        self.birthday = json["birthday"].string ?? ""
        self.unit = json["unit"].string ?? ""
    }
    
    func clear() {
        self.keychain.clear()
    }
}
