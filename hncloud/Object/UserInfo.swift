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
    
    var typeNumber: Int {
        switch self {
        case .Wristband:
            return 2
        case .Watch:
            return 1
        case .none:
            return 0
        }
    }
}

enum SexType: Int {
    case male = 0
    case women
    
    var apiValue: String {
        switch self {
        case .male:
            return "Male"
        default:
            return "Female"
        }
    }
    
    /// 原專案中，錯誤使用 male 單字，此處應為性別，
    /// EX: 男性 male = false = 0, 女性 female = true = 1
    var maleBool: Bool {
        switch self {
        case .male:
            return false
        case .women:
            return true
        }
    }
    
    static func get(api: String) -> SexType {
        switch api {
        case "Female":
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
    private let ud = UserDefaults.standard
    
    var sid: String {
        set {
            self.keychain.set(newValue, forKey: "sid")
        }
        get {
            return self.keychain.get("sid") ?? ""
        }
    }
    var count: String {
        set {
            self.keychain.set(newValue, forKey: "count")
        }
        get {
            return self.keychain.get("count") ?? ""
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
    
    /// 公制 = false, 英制 = true
    var unitState: Bool {
        get {
            return unit == "1"
        }
    }
    
    var distansUnit: String {
        return unitState ? "mile" : "km"
    }
    
    var sys: Int {
        set {
            self.keychain.set("\(newValue)", forKey: "sys")
        }
        get {
            return Int(self.keychain.get("sys") ?? "") ?? 0
        }
    }
    
    var dia: Int {
        set {
            self.keychain.set("\(newValue)", forKey: "dia")
        }
        get {
            return Int(self.keychain.get("dia") ?? "") ?? 0
        }
    }
    
    var warningMax: Int {
        set {
            self.keychain.set("\(newValue)", forKey: "warningMax")
        }
        get {
            return Int(self.keychain.get("warningMax") ?? "") ?? 0
        }
    }
    
    var warningMin: Int {
        set {
            self.keychain.set("\(newValue)", forKey: "warningMin")
        }
        get {
            return Int(self.keychain.get("warningMin") ?? "") ?? 0
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
        
        if CositeaBlueTooth.instance.isConnected {
            print("          userInfo.isConnected = true")
        } else {
            print("          userInfo.isConnected = false")
        }
        
        return (self.keychain.get("deviceToken") ?? "") != "未綁定".localized()
    }

    @objc dynamic var selectedDate: Date = Date()
    var walkTarget: Int = 10000
    var sleepTarget: Int = 8
    
    func update(json: JSON) {
        self.sid = json["sid"].string ?? ""
        print("show sid = \(json["sid"])")
        print("show sid = \(json)")
        self.gender = SexType.get(api: json["gender"].string ?? "")
        self.nickName = json["nickname"].string ?? ""
        self.height = json["height"].string ?? ""
        self.weight = json["weight"].string ?? ""
        self.birthday = json["birthday"].string ?? ""
        self.unit = json["unit"].string ?? ""
        self.sys = json["sys"].int ?? 0
        self.dia = json["dia"].int ?? 0
    }
    
    func login(json: JSON) {
        self.sid = json["data"]["sid"].string ?? ""
        self.gender = SexType.get(api: json["data"]["gender"].string ?? "")
        self.account = json["data"]["account"].string ?? ""
        self.nickName = json["data"]["nickname"].string ?? ""
        self.height = json["data"]["height"].string ?? ""
        self.weight = json["data"]["weight"].string ?? ""
        self.email = json["data"]["email"].string ?? ""
        self.birthday = json["data"]["birthday"].string ?? ""
        self.unit = json["data"]["unit"].string ?? ""
        self.sys = json["data"]["sys"].int ?? json["data"]["sys"].string?.int ?? 0
        self.dia = json["data"]["dia"].int ?? json["data"]["dia"].string?.int ?? 0
        self.count = json["data"]["id"].string ?? json["data"]["id"].int?.string ?? ""
    }
    
    func clear() {
        self.keychain.clear()
    }
}



