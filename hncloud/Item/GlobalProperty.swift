//
//  GlobalProperty.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

struct GlobalProperty {
    

    
//    static let kX = Int(CurrentDeviceWidth) / 375
    
//    func kLOCAL(x: String) -> String {
//        return NSLocalizedString(x, comment: "")
//    }
    
//    static let kHCH = HCHCommonManager.getInstance()
    

    
    // 全局颜色定义
//    static let fontcolorMain = UIColor(hexString: "#323232")
//    static let fontcolorless = UIColor(hexString: "#7d7d7d")
//    func intToString(x: Any) -> String {
//        return "\(x)"
//    }
    
//    static let kStepColor = UIColor(red: 33 / 255.0, green: 109 / 255.0, blue: 182 / 255.0, alpha: 1)
//    static let kDeppSleepColor = [](122, 82, 160)
//    static let kLightSleepColor = [](212, 170, 254)
//    static let kWakeSleepColor = [](242, 217, 254)
//    func kColor(x: Any, y: Any, z: Any) -> UIColor {
//        return UIColor(red: x / 255.0, green: y / 255.0, blue: z / 255.0, alpha: 1)
//    }
    
//    static let ShouHuan_DeviceName = "HR"
//    static let testEventCount = HCHCommonManager.getInstance().eventCount
    
    static let mSystemVersion = UIDevice.current.systemVersion
    static let currentWorkMode = HCHCommonManager.instance.currentMode
    static let kLastDeviceUUID = "BindingDeviceUuid"
    static let kLastDeviceNAME = "BindingDeviceName"
    static let kLastDeviceMACADDRESS = "BindingDeviceMacAddress"
    static let SUPPORTPAGEMANAGER = "SUPPORTPAGEMANAGER"
    static let SHOWPAGEMANAGER = "SHOWPAGEMANAGER"
    static let SUPPORTINFORMATION = "SUPPORTINFORMATION"
    /**
     *  AllDEVICETYPE  1 手环  2 手表
     *
     */
    static let AllDEVICETYPE = "AllDEVICETYPE"
    //#define AllDEVICEID  @"AllDEVICEID"
    static let AllDEVICETYPELAST = "AllDEVICETYPELAST"
    static let AllDEVICETYPECHANGE = "AllDEVICETYPECHANGE"
    static let DEFAULTDEVICEID = "111111111111"
    
    
    static let CheckFirstLoad_HCH = "CheckFirstLoad_HCH"
    static let Steps_PlanTo_HCH = "stepsPlan"
    static let Sleep_PlanTo_HCH = "sleepPlan"
    
    static let LastLoginUser_Info = "LastLoginUser_Info"
    
//    static let kUnitStateKye = "unitState"
    
    static let CurrentUserName_HCH = "CurrentUserName"
    
    static let kLightSleep = "lightSleep"
    static let kDeepSleep = "deepSleep"
    static let kAwakeSleep = "awakeSleep"
    static let HEARTCONTINUITY = "heartContinuity"
    static let NEWALARM = "newAlarm"
    static let REMINDLENGTH = "remindLength"
    static let CUSTOMREMINDLENGTH = "customRemindLength"
    static let continuityMonitorNumber = 62
    static let MISTEPDATABASEVERSION = "MistepDatabaseVersion"
    //数据库版本   1.上传下行升级到版本3    2.运动加轨迹 升级到4  3. 修复离线的保存数据。改了运动表。升级到5
    
    //在线运动的表
    static let ONLINESPORT = "ONLINESPORT"
    static let SPORTID = "sportID"
    static let SPORTTYPE = "sportType"
    static let SPORTDATE = "sportDate"
    static let FROMTIME = "fromTime"
    static let TOTIME = "toTime"
    static let STEPNUMBER = "stepNumber"
    static let KCALNUMBER = "kcalNumber"
    static let HEARTRATE = "heartRate"
    static let SPORTNAME = "sportName"
    static let ISUP = "isUp"
    static let HAVETRAIL = "haveTrail"
    static let TRAILARRAY = "trailArray"
    static let MOVETARGET = "moveTarget"
    static let MILEAGEM = "mileageM"
    static let MILEAGEM_MAP = "mileageM_map"
    static let SPORTPACE = "sportPace"
    static let WHENLONG = "whenLong"
    
    
    static let DEVICETYPE = "deviceType"
    static let DEVICEID = "deviceID"
    
    
    
    //第三方登录
    static let kThirdPartLoginKey = "thirdPartDic"
    
    static let kThirdPartPassWord = "Cositea001"
    
    //心率预警key
    static let kHeartRateAlarm = "HeartRateAlarm"
    //个人信息
    static let HeadImageURL_PersonInfo_HCH = "HeadImageURL"
    static let BornDate_PersonInfo_HCH = "BornDateHCL"
    static let Male_PersonInfo_HCH = "Male"
    static let High_PersonInfo_HCH = "High"
    static let Weight_PersonInfo_HCH = "Weight"
    static let Key_PersonInfo_HCH = "Key"
    static let PersonInfo_IsNeedTosend_HCH = "PersonInfo_IsNeedTosend"
    
    
    // 全天详细数据
    static let kDayStepsData = "stepData"
    static let kDayCostsData = "costsData"
    static let kPilaoData = "pilaoData"
    
    //  心率数据
    static let DataTime_HCH = "DataDate"
    
    //睡眠数据
    static let DataIndex_SleepData_HCH = "DataIndex_SleepData"
    static let DataStartTime_SleepData_HCH = "DataStartTime_SleepData"
    static let DataStopTime_SleepData_HCH = "DataStopTime_SleepData"
    static let DataValue_SleepData_HCH = "DataValue_SleepData"
    static let SleepEventIndex_HCH = "SleepEventIndex"
    
    static let DataIndex_SleepHeartRate_HCH = "DataIndex_SleepHeartRate"
    static let DataRate_SleepHeartRate_HCH = "DataRate_SleepHeartRate"
    
    
    //天总数据
    static let TotalSteps_DayData_HCH = "TotalSteps_DayData"
    static let TotalMeters_DayData_HCH = "TotalMeters_DayData"
    static let TotalCosts_DayData_HCH = "TotalCosts_DayData"
    static let TotalDeepSleep_DayData_HCH = "TotalDeepSleep_DayData"
    static let TotalLittleSleep_DayData_HCH = "TotalLittleSleep_DayData"
    static let TotalWarkeSleep_DayData_HCH = "TotalWarkeSleep_DayData"
    static let TotalSleepCount_DayData_HCH = "TotalSleepCount_DayData"
    static let TotalDayEventCount_DayData_HCH = "TotalDayEventCount_DayData"
    static let TotalDataWeekIndex_DayData_HCH = "TotalDataWeekIndex"
    static let TotalDataActivityTime_DayData_HCH = "TotalDataActivityTime_DayData"
    static let TotalDataCalmTime_DayData_HCH = "TotalDataCalm_DayData"
    
    static let kTotalDayActivityCost = "activityCosts"
    static let kTotalDayCalmCost = "calmCosts"
    
    //   防丢提醒
    static let AntiLoss_Status_HCH = "antiLoss_status"
    
    
    //实时数据
    
    static let SportString_ActualData_HCH = "SportString_ActualData"
    static let StartTime_ActualData_HCH = "StartTime_ActualData"
    static let StopTime_ActualData_HCH = "StopTime_ActualData"
    static let SportType_ActualData_HCH = "SportType_ActualData"
    static let HeartRate_ActualData_HCH = "HeartRate_ActualData"
    static let StepCount_ActualData_HCH = "StepCount_ActualData"
    static let MeterCount_ActualData_HCH = "MeterCount_ActualData"
    static let CostCount_ActualData_HCH = "CostCount_ActualData"
    static let Speed_ActualData_HCH = "Speed_ActualData"
    static let SportEventIndex_HCH = "SportEventIndex"
    static let TimeSeprate_ActualData_HCH = "TimeSeprate_ActualData"
    
    static let ActualData_Index_HCH = "ActualData_Index"
    
    static let IsLaguageDataPath_SRK = "IsLaguageDataPath"
    static let ChinesLanguage_SRK = "ChinesLanguage"
    static let EnglishLanguage_SRK = "EnglishLanguage"
    static let LanguageChooseKey_SRK = "LanguageChooseKey_SRK"
    
    static let TiredCheck_Time_HCH = "monitorTime"
    static let TiredCheck_Data_HCH = "fatigue"
    
    //血压数据，建表 ，需要保存用户
    static let BloodPressureID_def = "BloodPressureID"
    static let BloodPressureDate_def = "BloodPressureDate"
    static let StartTime_def = "StartTime"
    static let systolicPressure_def = "systolicPressure"
    
    static let diastolicPressure_def = "diastolicPressure"
    static let heartRateNumber_def = "heartRateNumber"
    static let SPO2_def = "SPO2"
    static let HRV_def = "HRV"
    //外设表
    static let deviceId_per = "deviceId_per"
    static let macAddress_per = "macAddress_per"
    static let UUIDString_per = "UUIDString_per"
    static let RSSI_per = "RSSI_per"
    static let deviceName_per = "deviceName_per"
    
    //天气表
    static let WEATHERTABLE = "Weather_Table"
    static let WEATHERID = "weatherId"
    static let WEATHERTIME = "weatherTime"
    static let WEATHERLOCATION = "weatherLocation"
    static let WEATHERCONTENT = "weatherContent"
    static let EXTONE = "extOne"
    static let EXTTWO = "extTwo"
    static let EXTTHREE = "extThree"
    
    
    //int LanguageIndex_SRK ;
    //int DeviceStatus_OAD ; //升级状态
    //int testEventCount; //白天事件总数
    //int startSeconds; //实时数据开始时间
    //int systemTimeOffset;
    //int netWorkStatus; //网络状态
    //int currentWorkMode; //后台和前台
    
    
    // Include any system framework and library headers here that should be included in all compilation units.
    // You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
    
    
    //适配的比例
    static let ZITI_PROPORTION = 736.0 / 2208
    
    static let WIDTH_PROPORTION = UIScreen.main.bounds.size.width / 1242
    
    static let HEIGHT_PROPORTION = UIScreen.main.bounds.size.height / 2208
    
    /**
     *
     *  颜色的设置
     *
     */
//    static let colorFontGraw6c6c6c = [](108, 108, 108)
//    static let colorFontBlack484848 = [](72, 72, 72)
//    static let color16e0be = [](22, 224, 190)
//    static let color39baff = [](57, 186, 254)
    //#define  color   kColor(72, 72, 72)
    //#define  color   kColor(72, 72, 72)
    //#define  connectViewH  (50*HeightProportion)
    static let NavsubTag = 43568
    static let KONEDAYSECONDS = 86400
    static let LOGINTYPE = "loginType"
    
    // 定义log的输出
    #if DEBUG
//    func adaLog(_ content: CVarArgType...) {
//        print("\(#function) 第\(#line)行 \n \(content)\n\n")
//    }
    #else
    //#define adaLog(...)
    #endif
    
    //#ifdef DEBUG // 调试状态, 打开LOG功能
    //#define interfaceLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])//NSLog(__VA_ARGS__)
    //#else // 发布状态, 关闭LOG功能
    //#define interfaceLog(...)
    //#endif
    
    //#ifdef DEBUG // 调试状态, 打开LOG功能
    //#define dataLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])//NSLog(__VA_ARGS__)
    //#else // 发布状态, 关闭LOG功能
    //#define dataLog(...)
    //#endif
    
    //  查询天气的字典 key
    static let QUERYWEATHERID = "queryWeatherID"
    static let QUERYWEATHERRI = "queryWeatherRi"
    static let QUERYWEATHERDAYNUMBER = "queryWeatherDayNumber"
    static let COMPLETIONDEGREESUPPORT = "CompletionDegreeSupport"
    static let WEATHERSUPPORT = "weatherSupport"
    
    static let BLOODPRESSURELOW = "BLOODPRESSURELOW"
    static let BLOODPRESSUREHIGH = "BLOODPRESSUREHIGH"
    
    
    //#define MAPSPORTTARGET @"mapSportTarget"//带轨迹的运动，运动目标
    //#define MAPSPORTTYPE @"mapSportType"//带轨迹的运动，运动类型
    
    
    static let MAPSPORTTARGET = "mapSportTarget"
    static let MAPSPORTTYPE = "mapSportType"
//    func UIColorFromHex(s: Any) -> UIColor {
//        return UIColor(red: ((s & 0xff0000) >> 16) / 255.0, green: ((s & 0xff00) >> 8) / 255.0, blue: (s & 0xff) / 255.0, alpha: 1.0)
//    }
//    func UIColorFromHexAlpha(s: Any, aal: Any) -> UIColor {
//        return UIColor(red: ((s & 0xff0000) >> 16) / 255.0, green: ((s & 0xff00) >> 8) / 255.0, blue: (s & 0xff) / 255.0, alpha: aal)
//    }
    
    static let MAPVOICEISOPEN = "mapVoiceIsOpen"
    static let SEARCHDEVICEISSEEK = "searchDeviceIsSeek"
    static let CALLBACKFORTY = "callbackForty"
    
//    static let kAppDelegate = UIApplication.shared.delegate as? AppDelegate

//[[UIApplication sharedApplication] delegate]
//#define kAppShare [UIApplication sharedApplication]


}


// MARK: - Enum.

enum EditPersonState : Int {
    case regist = 1
    case edit
    case first
}

enum Language : Int {
    case chinesLanguage = 0
    case englishLanguage
    case koreaLanguage
    case spanishLanguage
}

enum BlueToothFunctionIndexEnum : Int {
    case callAlarm = 0x01 //来电提醒
    case unitSet = 0x02 //语言设置  以及各种基本设置
    case checkPower = 0x03 //检测电量
    case setStepPram = 0x04 //设置计步参数
    case openAntiLoss = 0x05 //打开防丢提醒
    case getActualData = 0x06 //获取实时数据
    case checkVersion = 0x07 //检测版本
    case updateHardWare = 0x08 //升级固件
    case customAlarm = 0x09 //自定义提醒
    case tiredCheck = 0x0a //开始疲劳测试
    case takePhoto = 0x0e
    case sendWeatherSuc = 0x0f //天气发送成功
    case heartRateAlarm = 0x10 //心率预警
    case resetDevice = 0x11 //恢复出厂设置
    case phoneDelay = 0x12 //电话延时提醒
    case findBand = 0x13
    case jiuzuoAlarm = 0x14
    case timeSync = 0x20 //时间同步
    case updateTotalData_old = 0x21 //上传监测数据
    case updateOffLine = 0x22 //上传离线数据
    case updateSleepData = 0x23 //上传睡眠数据
    case updateTiredData = 0x25 //上传疲劳值数据
    case updateTotalData = 0x26 //全天数据
    case exceptioncodeData = 0x27
    case bloodPressure = 0x2a
    case pageManager_None = 0x2c //页面管理界面
    case completionDegree = 0x2d //完成度
    case queryWeather = 0x31 //手环请求天气
    case checkAction = 0x32 //查询设备是否支持某功能
    case checkNewLength = 0x33 //查询设备支持 长度
    case pilaoData = 0x65 //疲劳值不支持
    //CustomAlarm_None = 0x49,//手环请求天气
    
}


enum BatteryState: Int {
    
    case full = 100
    case eighty = 80
    case sixty = 60
    case forty = 40
    case twenty = 20
    
    init?(_ ele: Int) {
        
        if ele >= 100 {
            self.init(rawValue: 100)
        } else if ele >= 80 {
            self.init(rawValue: 80)
        } else if ele >= 60 {
            self.init(rawValue: 60)
        } else if ele >= 40 {
            self.init(rawValue: 40)
        } else if ele >= 20 {
            self.init(rawValue: 20)
        } else {
            return nil
        }
    }
    
    var image: UIImage {
        switch self {
        case .full:
            return #imageLiteral(resourceName: "ele100")
        case .eighty:
            return #imageLiteral(resourceName: "ele80")
        case .sixty:
            return #imageLiteral(resourceName: "ele60")
        case .forty:
            return #imageLiteral(resourceName: "ele40")
        case .twenty:
            return #imageLiteral(resourceName: "ele20")
        }
    }
    
    var stringValue: String {
        switch self {
        case .full:
            return "100%"
        case .eighty:
            return "80%"
        case .sixty:
            return "60%"
        case .forty:
            return "40%"
        case .twenty:
            return "20%"
        }
    }
    
}
