//
//  HCHCommonManager.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import CoreBluetooth
import UIKit

class HCHCommonManager: NSObject {
    
    
    // MARK: - Singleton.
    static let instance = HCHCommonManager()
    
    
    // MARK: - Property.
    
    var isFirstLogin = false
    var stepsPlan: Int = 0
    var sleepPlan: Int = 0
    var antilossIsOn = false
    var curTestMode: Int = 0
    var curHardVersion: Int = 0
    var curHardVersionTwo: Int = 0
    /*兼容第二个版本 */
    var curBlueToothVersion: Float = 0.0
    var curSoftVersion: Float = 0.0
    var curPower: Int = 0
    /*手环电量 */
    var age: Int = 0
    var blueVersion: Int = 0
    var softVersion: Int = 0
    var userInfoDictionAry: [String : Any] = [:]
    var currentMode: Int = 0
    var curSportDic: [String : Any] = [:]
    var eventCount: Int = 0
    var isLogin = false
//    var state: Int = 0
    var lanuguageIndex_SRK: Int = 0
    var active = false
    var isThirdPartLogin = false
    var firstThirdPartLogin = false
    /*第一次第三方登录 */
    var selectTimeSeconds: Int = 0
    var todayTimeSeconds: Int = 0
    var blueToothState: CBManagerState?
    var requestIndex: Int = 0
    /*全天心率数据请求包第几个。等待到这个包就开始存储离线数据 */
    var queryHearRateSeconed: Int = 0
    /*请求心率的 时间 的秒数  .记录发送命令时间 */
    var queryWeatherArray: [AnyHashable] = []
    /*请求天气的数组，数组中有值就按数组的规范来，没有数组就默认的走 */
    var pilaoWarning: Int = 0
    
    #warning("Reachability & NetworkStatus has not been created.")
//    var internetReachability: Reachability?
//    var iphoneNetworkStatus: NetworkStatus?
    /*网络状态 apple demo */    //ada配置
    var pilaoValue = false
    
    var weatherLocation: Int = 0
    /*天气的位置。天气的 1 是国内 2 是国外 */
    
    var conState = false
    /*  蓝牙 连接状态的监测 */
    
    var languageNum: Int = 0
    //  语言状态。用于发给手表。用于请求天气发给手表
    
    // 用于监测系统的变化。基本是区别夸天
    var timeTimer: Timer?

    
    
    // MARK: - Init.
    
    override init() {
        super.init()
        
        isFirstLogin = UserDefaults.standard.bool(forKey: GlobalProperty.CheckFirstLoad_HCH)
        sleepPlan = UserDefaults.standard.integer(forKey: GlobalProperty.Sleep_PlanTo_HCH)
        stepsPlan = UserDefaults.standard.integer(forKey:  GlobalProperty.Steps_PlanTo_HCH)
        antilossIsOn = UserDefaults.standard.bool(forKey: GlobalProperty.AntiLoss_Status_HCH)
//        state = UserDefaults.standard.integer(forKey: GlobalProperty.kUnitStateKye)
        
        todayTimeSeconds = Int(TimeCallManager.instance.getSecondsOfCurDay())
        
        selectTimeSeconds = todayTimeSeconds
        pilaoValue = true
        weatherLocation = 1
        timeTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.systemTimeChange), userInfo: nil, repeats: true) //定时刷新时间
        
        #warning("Reachability has not been created.")
        //监测网络的通知
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
        //开始监测网络
//        internetReachability = Reachability()
//        internetReachability.startNotifier()
//        updateInterface(withReachability: internetReachability)

    }
    
    
    
    // MARK: - Method.
    
    
    func setAntilossIsOn(_ antilossIsOn: Bool) {
        self.antilossIsOn = antilossIsOn
        UserDefaults.standard.set(antilossIsOn ? 1 : 0, forKey: GlobalProperty.AntiLoss_Status_HCH)
    }
    
    func setIsFirstLogin(_ isFirstLogin: Bool) {
        self.isFirstLogin = isFirstLogin
        UserDefaults.standard.set(isFirstLogin ? 1 : 0, forKey: GlobalProperty.CheckFirstLoad_HCH)
    }

    func setSleepPlan(_ sleepPlan: Int) {
        self.sleepPlan = sleepPlan
        UserDefaults.standard.set(Int32(sleepPlan), forKey: GlobalProperty.Sleep_PlanTo_HCH)
    }
    
    func setStepsPlan(_ stepsPlan: Int) {
        self.stepsPlan = stepsPlan
        UserDefaults.standard.set(Int32(stepsPlan), forKey: GlobalProperty.Steps_PlanTo_HCH)
    }


    
    
    /**
     *得到存放文件的文件夹
     */
    func getFileStoreFolder() -> String? {
        
        let fileManager = FileManager.default
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let paths = URL(fileURLWithPath: path[0]).appendingPathComponent("\("")").absoluteString
        if !fileManager.isExecutableFile(atPath: paths) {
            try? fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
        }
        
        return paths
        
    }
    
    //将图片存储
    func storeHeadImage(with locImage: UIImage) -> String? {

        guard var file = getFileStoreFolder() else { return nil }
        
        file = "\(file)/\("headImageCache.png")"
        
        guard let url = URL(string: file) else { return nil }
        
        let imageData: Data? = locImage.pngData()
        do {
            try imageData?.write(to: url, options: .atomic)
        } catch _ {
            return nil
        }
        
        return file

    }
    
    //讲图片从缓存改为存储
    func saveImageFromCache() -> String? {
        
        guard let file = getFileStoreFolder() else { return nil }
        let file1 = "\(file)/\("headImageCache.png")"
        let file2 = "\(file)/\("headImage.png")"
        try? FileManager.default.removeItem(atPath: file2)
        try? FileManager.default.moveItem(atPath: file1, toPath: file2)
        return file2

    }
    
    //根据fileName获取图片
    func getHeadImage(withFile fileName: String?) -> UIImage? {
        
        guard let filename = fileName else { return nil }
        
        let locImage = UIImage(contentsOfFile: filename)
        
        return locImage

    }
    
    //- (void)sendUserInfoToBlueTooth;
    //- (void)sendCurrentUserInfoToBlueTooth;
    func getPersonAge() -> Int {
        
        var age: Int = 25
        //    NSDictionary *dic = [[SQLdataManger getInstance] getCurPersonInf];
        let formates = DateFormatter()
        formates.dateFormat = "yyyy-MM-dd"
        //    NSDate *assignDate = [formates dateFromString:[dic objectForKey:BornDate_PersonInfo_HCH]];
        let assignDate: Date? = formates.date(from: userInfoDictionAry["birthdate"] as? String ?? "")
        let time = Int(assignDate?.timeIntervalSinceNow ?? 0)
        age = abs(time / (60 * 60 * 24)) / 365
        
        return age

    }
    
    //生成长度为10的随机字符串
    func createRandomString() -> String? {
//        let NUMBER_OF_CHARS: Int = 10
//        var data = [Int8](repeating: 0, count: NUMBER_OF_CHARS)
//        var x = 0
//        while x < NUMBER_OF_CHARS {
//            data[x] = Int8("A" + (arc4random_uniform(26)))
//        }
//        x += 1
//        return String(bytes: data, encoding: .utf8)
        return nil
    }
    
    
    func getLanguageNum() -> Int {
        languageNum = BLETool.setLanguageTool()
        return languageNum
    }
    
    //监测系统时间的方法
    @objc func systemTimeChange() {
        
        
        todayTimeSeconds = Int(TimeCallManager.instance.getSecondsOfCurDay())
        
        //    //adaLog(@"todayTimeSeconds = %d",_todayTimeSeconds);
        //    //adaLog(@"todayTimeSeconds = %@",[[TimeCallManager getInstance] timeAdditionWithTimeString:@"yyyy-MM-dd HH:mm:ss" andSeconed:_todayTimeSeconds]);
    }
    
    #warning("Reachability has not been created.")
//    func updateInterface(with reachability: Reachability?) {
//        let netStatus: NetworkStatus? = reachability?.currentReachabilityStatus()
//        iphoneNetworkStatus = netStatus
//        switch netStatus {
//        case NotReachable?:
//            //adaLog(@"--NotReachable");
//            break
//        case ReachableViaWWAN?:
//            //adaLog(@"--ReachableViaWWAN");
//            break
//        case ReachableViaWiFi?:
//            //adaLog(@"--ReachableViaWiFi");
//            break
//        default:
//            break
//        }
//    }

    
    
    func setUserEmailWith(_ email: String?) {
        if email != nil {
            userInfoDictionAry["email"] = email
        }
    }
    
    func setUserBirthdateWith(_ birthdate: String?) {
        if birthdate != nil {
            userInfoDictionAry["birthdate"] = birthdate
        }
    }
    
    func setUserHeaderWith(_ header: String?) {
        if header != nil {
            userInfoDictionAry["header"] = header
        }
    }
    
    func setUserHeightWith(_ height: String?) {
        if height != nil {
            userInfoDictionAry["height"] = height
        }
    }
    
    func setUserWeightWith(_ weight: String?) {
        if weight != nil {
            userInfoDictionAry["weight"] = weight
        }
    }
    
    func setUserNickWith(_ nick: String?) {
        if nick != nil {
            userInfoDictionAry["nick"] = nick
        }
    }
    
    func setUserGenderWith(_ gender: String?) {
        if gender != nil {
            userInfoDictionAry["gender"] = gender
        }
    }
    
    func setUserAcountName(_ userName: String?) {
        if userName != nil {
            userInfoDictionAry["account"] = userName
        }
    }
    
    func userEmail() -> String? {
        return userInfoDictionAry["email"] as? String
    }
    
    func userBirthdate() -> String? {
        return userInfoDictionAry["birthdate"] as? String
    }
    
    func userHeader() -> String? {
        return userInfoDictionAry["header"] as? String
    }
    
    func userHeight() -> String? {
        return userInfoDictionAry["height"] as? String
    }
    
    func userWeight() -> String? {
        return userInfoDictionAry["weight"] as? String
    }
    
    func userNick() -> String? {
        return userInfoDictionAry["nick"] as? String
    }
    
    func userGender() -> String? {
        return userInfoDictionAry["gender"] as? String
    }
    
    func userAcount() -> String? {
        guard let account = userInfoDictionAry["account"] as? String else {
            return NSLocalizedString("未登錄", comment: "")
        }
        return account
    }

    //几岁了。
    func getAge() -> Int {
        
        guard let birthData = userBirthdate() else { return 0 }
        
        let formates = DateFormatter()
        formates.dateFormat = "yyyy-MM-dd"
        let assignDate: Date? = formates.date(from: birthData)
        let time = Int(abs(Float(assignDate?.timeIntervalSinceNow ?? 0.0)))
        let age: Int = Int(trunc(Double(time / (60 * 60 * 24))) / 365)
        
        return age

    }
}

