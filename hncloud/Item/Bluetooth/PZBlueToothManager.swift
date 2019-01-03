//
//  PZBlueToothManager.swift
//  hncloud
//
//  Created by Hong Shih on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift

typealias connectStateBlock = (Int) -> Void
typealias dictionnaryBlock = ([AnyHashable : Any]?) -> Void
protocol PZBlueToothManagerDelegate: NSObjectProtocol {
    /**
     *蓝牙连接成功的回调数据
     */
    func blueToothIsConnected(_ isconnected: Bool)
}

class PZBlueToothManager: NSObject {

    
    static let instance = PZBlueToothManager()

    weak var delegate: PZBlueToothManagerDelegate?
    var offLineDataBlock: dictionnaryBlock?
    var connectStateBlock: connectStateBlock?
    var heartRateBlock: intBlock?
    var actualHeartArray: [String] = []
    
    private var isSetBlocks: Int = 0
    
    
    

//    class func sharedInstance() -> PZBlueToothManager? {
//    }

    func setBlocks() {
        //    self?;
        PZBlueToothManager.instance.recieveOffLineData(withBlock: { dic in
            //        [self? saveOffLineDataWithModel:dic];
        })
        PZBlueToothManager.instance.checkHeartRateAlarm(with: { state, max, min in
        }) //查询心率预警区间
        PZBlueToothManager.instance.checkHRVData(withHRVBlock: { number, array in
        }) //疲劳
        PZBlueToothManager.instance.checkBloodPressure({ bloodPre in
        })
        PZBlueToothManager.instance.checkVerSion(withBlock: { firstHardVersion, secondHardVersion, softVersion, blueToothVersion in
        })
        PZBlueToothManager.instance.checkTodayHeartRate(withBlock: { timeSeconds, index, heartArray in
        }) //当天心率总数。8个包
        PZBlueToothManager.instance.checkTodaySleepState(withBlock: { timeSeconds, sleepArray in
        }) //查询睡眠数据 144 ，每个值表示十分钟
        PZBlueToothManager.instance.checkHourStepsAndCosts(withBlock: { steps, costs in
        }) //查询每小时数据
        PZBlueToothManager.instance.chekCurDayAllData(withBlock: { dic in
        })
        PZBlueToothManager.instance.checkBandPower(withPowerBlock: { number in
        }) //检查电量
        PZBlueToothManager.instance.recieveHistoryAllDayData(with: { model in
        })
        PZBlueToothManager.instance.recieveHistoryHourData(with: { steps, costs, timeSeconds in
        })
        PZBlueToothManager.instance.recieveHistorySleepData(with: { model in
        })
        PZBlueToothManager.instance.recieveHistoryHeartRate(with: { timeSeconds, index, array in
        })
        PZBlueToothManager.instance.recieveHistoryHRVData(with: { number, array in
        })
        //页面配置的接收值
        //    [[CositeaBlueTooth sharedInstance] supportPageManager:^(uint number) {
        //        //adaLog(@"number  === %u",number);
        //    }];
        //    [[PZBlueToothManager sharedInstance] setBindDate];
        //    [[CositeaBlueTooth sharedInstance] recieveOffLineDataWithBlock:^(SportModel *model) {
        //        [self? saveOffLineDataWithModel:model];
        //    }];
        //    [[CositeaBlueTooth sharedInstance] recieveHistoryAllDayDataWithBlock:^(DayOverViewDataModel *model) {
        //        [self? saveAllDayDataWithModel:model];
        //    }];
        //    [[CositeaBlueTooth sharedInstance] recieveHistoryHourDataWithBlock:^(NSArray *steps, NSArray *costs, int timeSeconds) {
        //        [self? saveHourDataWithTimeSeconds:timeSeconds Steps:steps Costs:costs];
        //    }];
        //    [[CositeaBlueTooth sharedInstance] recieveHistorySleepDataWithBlock:^(SleepModel *model) {
        //        [self? saveSleepDataWithSleepModel:model];
        //    }];
        //    [[CositeaBlueTooth sharedInstance] recieveHistoryHeartRateWithBlock:^(int timeSeconds, int index, NSArray *array) {
        //        [self? saveHeartRateArrayWithTiemIndex:timeSeconds + index HeartRateArray:array];
        //    }];
        //    [[CositeaBlueTooth sharedInstance] recieveHistoryHRVDataWithBlock:^(int number, NSArray *array) {
        //        [self? saveHRVDataWithTimeSeconds:number HRVDataArray:array];
        //    }];
        
    }

    func checkBandPower(withPowerBlock PowerBlock: @escaping intBlock) {
        CositeaBlueTooth.instance.checkBandPower(withPowerBlock: { number in
            HCHCommonManager.instance.curPower = number
            PowerBlock(number)
        })
    }

    func chekCurDayAllData(withBlock dayTotalDataBlock: @escaping (_ dic: [String : Any]?) -> Void) {
        CositeaBlueTooth.instance.chekCurDayAllData(with: { [weak self] model in
            
            guard let model = model else { return }
            
            let dic = self?.saveAllDayData(with: model)
            
            DispatchQueue.main.async(execute: {
                if model.timeSeconds == Int(TimeCallManager.instance.getSecondsOfCurDay()) {
                    //if dayTotalDataBlock
                    
                    dayTotalDataBlock(dic)
                    if let dic = dic {
                        HCHCommonManager.instance.curSportDic = dic
                    }
                }
            })
        })
    }

    // MARK: -- 收到离线数据
    func recieveOffLineData(withBlock offLineDataBlock: @escaping (_ dic: SportModelMap?) -> Void) {
        CositeaBlueTooth.instance.recieveOffLineData(withBlock: { [weak self] model in
            
            if let model = model {
                self?.saveOffLineData(withModel: model)
            }
            
            //if offLineDataBlock
            
            offLineDataBlock(model)
            
        })
    }

    func checkHourStepsAndCosts(withBlock dayHourDataBlock: @escaping (_ steps: [Any]?, _ costs: [Any]?) -> Void) {
        CositeaBlueTooth.instance.checkHourStepsAndCosts(with: { [weak self] steps, costs, timeSeconds in
            self?.saveHourData(withTimeSeconds: timeSeconds, steps: steps, costs: costs)
            //if dayHourDataBlock
            
            dayHourDataBlock(steps, costs)
            
        })
    }

    func checkTodaySleepState(withBlock sleepStateArrayBlock: @escaping (_ timeSeconds: Int, _ sleepArray: [Any]?) -> Void) {
        CositeaBlueTooth.instance.checkTodaySleepState(with: { [weak self] model in
            self?.saveSleepData(with: model)
            //if sleepStateArrayBlock
            if let timeSeconds = model?.timeSeconds {
                sleepStateArrayBlock(timeSeconds, model?.sleepArary)
            }
        })
    }

    func checkTodayHeartRate(withBlock heartRateArrayBlock: @escaping (_ timeSeconds: Int, _ index: Int, _ heartArray: [Any]?) -> Void) {
        
        CositeaBlueTooth.instance.checkTodayHeartRate(with: { [weak self] timeSeconds, index, array in
            let heartDateIndex: Int = timeSeconds + index //8个包
            self?.saveHeartRateArray(withTiemIndex: heartDateIndex, heartRateArray: array)
            //if heartRateArrayBlock
            
            heartRateArrayBlock(timeSeconds, index, array)
            
        })
    }

    func checkHRVData(withHRVBlock HRVDataBlock: @escaping (_ number: Int, _ array: [Int]) -> Void) {
        CositeaBlueTooth.instance.checkHRV(withHRVBlock: { [weak self] number, array in
            self?.saveHRVData(withTimeSeconds: number, hrvDataArray: array)
            //        [[TimingUploadData sharedInstance] updataPilaoWarning];
            
            guard let array = array else { return }
            
            HRVDataBlock(number, array)
            
            for i in 0..<array.count {
                let pilaoValue = array[i]
                if pilaoValue < HCHCommonManager.instance.pilaoWarning && i < (array.count - 3) {
                    let secondValue = array[i + 1]
                    if secondValue < HCHCommonManager.instance.pilaoWarning {
                        let thirdValue = array[i + 2]
                        if thirdValue < HCHCommonManager.instance.pilaoWarning {
                            let timeSeconds = UserDefaults.standard.integer(forKey: "pilaoWarningTime")
                            if timeSeconds != HCHCommonManager.instance.todayTimeSeconds {
                                #warning("TimingUploadData 還未建立")
//                                TimingUploadData.sharedInstance().updataPilaoWarning()
                            }
                            return
                        }
                    }
                }
            }
        })
    }

    func checkVerSion(withBlock versionBlock: @escaping (_ firstHardVersion: Int, _ secondHardVersion: Int, _ softVersion: Int, _ blueToothVersion: Int) -> Void) {
        CositeaBlueTooth.instance.checkVerSion(with: { firstHardVersion, secondHardVersion, softVersion, blueToothVersion in
            
            var bigVersion: Int = (blueToothVersion >> 4) & 0x0f
            var smallVersion: Int = blueToothVersion & 0x0f
            let versionStr = String(format: "%d.%02d", bigVersion, smallVersion)
            
            bigVersion = (softVersion >> 4) & 0x0f
            smallVersion = softVersion & 0x0f
            let softStr = String(format: "%d.%02d", bigVersion, smallVersion)
            
            HCHCommonManager.instance.curBlueToothVersion = Float(versionStr) ?? 0.0
            HCHCommonManager.instance.curSoftVersion = Float(softStr) ?? 0.0
            //        [NSString stringWithFormat:@"%02x",secondHardVersion];
            if secondHardVersion == 161616 {
                HCHCommonManager.instance.curHardVersion = firstHardVersion
            } else {
                HCHCommonManager.instance.curHardVersion = firstHardVersion
                HCHCommonManager.instance.curHardVersionTwo = secondHardVersion
            }
            HCHCommonManager.instance.softVersion = softVersion
            HCHCommonManager.instance.blueVersion = blueToothVersion
            //if versionBlock
            
            versionBlock(firstHardVersion, secondHardVersion, softVersion, blueToothVersion)
            
        })
    }

    func connectedStateChanged(with stateChanged: @escaping intBlock) {
        if isSetBlocks == 0 {
            setBlocks()
            isSetBlocks = 66
        }
        CositeaBlueTooth.instance.connectedStateChanged(with: { [weak self] number in
            //adaLog(@"进来了");
            if number != 0 {
                UserDefaults.standard.set(CositeaBlueTooth.instance.connectUUID, forKey: GlobalProperty.kLastDeviceUUID)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set(CositeaBlueTooth.instance.deviceName, forKey: GlobalProperty.kLastDeviceNAME)
                self?.perform(#selector(PZBlueToothManager.openActuralHeart), with: nil, afterDelay: 2.0)
            }
            //if stateChanged
            
            self?.connectStateBlock = stateChanged
            
            if number != 0 {
                self?.delegate?.blueToothIsConnected(Bool(truncating: NSNumber(integerLiteral: number)))
            }
            
            self?.connectStateBlock?(number)
        })
    }

    func setBindDatepz() {
        let unitState = kState
        CositeaBlueTooth.instance.setUnitStateWithState(unitState == 2)
        
        let formatStringForHours = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
        let containsA: NSRange? = (formatStringForHours as NSString?)?.range(of: "a")
        let hasAMPM: Bool = Int(containsA?.location ?? 0) != NSNotFound
        CositeaBlueTooth.instance.setBindDateStateWithState(!hasAMPM)
        
        //    [[CositeaBlueTooth sharedInstance] checkHeartRateAlarmWithHeartRateAlarmBlock:^(int state, int max, int min) {
        //        NSArray *heartAlarmArray = @[[NSNumber numberWithInt:min],[NSNumber numberWithInt:max]];
        //        [[NSUserDefaults standardUserDefaults] setObject:heartAlarmArray forKey:kHeartRateAlarm];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //    }];
        
        //    [[CositeaBlueTooth sharedInstance] checkBandPowerWithPowerBlock:^(int number) {
        //        [HCHCommonManager getInstance].curPower = number;
        //    }];

        sendUserInfoToBind()
    }

    
    
    // MARK: -- 内部方法
    func sendUserInfoToBind() {
        
        let dic = UserDefaults.standard.object(forKey: "loginCache") as? [String : Any]
        //    adaLog(@"pz 身高体重 = %@",dic);
        if let dic = dic {
            let height = dic["height"] as? Int ?? 0
            let weight = dic["weight"] as? Int ?? 0
            let male = dic["gender"] as? Int ?? 0
            var age: Int = 25
            let formates = DateFormatter()
            formates.dateFormat = "yyyy-MM-dd"
            let assignDate: Date? = formates.date(from: dic["birthdate"] as? String ?? "")
            let time = Int(abs(Float(assignDate?.timeIntervalSinceNow ?? 0.0)))
            age = Int(trunc(Double(time / (60 * 60 * 24))) / 365)
            
            
            CositeaBlueTooth.instance.sendUserInfoToBind(withHeight: height, weight: weight, male: Bool(truncating: NSNumber(integerLiteral: male - 1)), age: age)
        }
    }

    func checkHeartRateAlarm(with heartRateAlarmBlock: @escaping heartRateAlarmBlock) {
        CositeaBlueTooth.instance.checkHeartRateAlarm(with: { state, max, min in
            let heartAlarmArray = [Int32(min), Int32(max)]
            UserDefaults.standard.set(heartAlarmArray, forKey: GlobalProperty.kHeartRateAlarm)
            UserDefaults.standard.synchronize()
            //if heartRateAlarmBlock
            
            heartRateAlarmBlock(state, max, min)
            
        })
    }

    func changeHeartState(withState isON: Bool, block: intBlock?) {
        //if block
        
        heartRateBlock = block
        
        if isON {
            CositeaBlueTooth.instance.openActualHeartRate(withBolock: { [weak self] number in
                guard let `self` = self else { return }
                self.heartRateBlock?(number)
                if self.actualHeartArray.count < 60 {
                    self.actualHeartArray.append(self.intToString(number))
                } else if self.actualHeartArray.count == 60 {
                    self.actualHeartArray.remove(at: 0)
                    self.actualHeartArray.append(self.intToString(number))
                    var count: Float = 0
                    var totalHeart: Float = 0
                    for i in 0..<self.actualHeartArray.count {
                        
                        let timeSeconds = UserDefaults.standard.integer(forKey: "heartWarningTime")
                        let date = Date()
                        let nowTime: TimeInterval = date.timeIntervalSince1970
                        if Int(nowTime) - timeSeconds < 1800 {
                            return
                        }
                        
                        let string = self.actualHeartArray.item(at: i)
                        
                        let heart = Int(string ?? "") ?? 0
                        if heart != 0 {
                            count += 1
                            totalHeart += Float(heart)
                        }
                        if count == 0 {
                            self.actualHeartArray.removeAll()
                        } else {
                            let avgHeart: Float = totalHeart / count
                            if avgHeart < 40 || avgHeart > 180 {
                                #warning("TimingUploadData 還未建立")
//                                TimingUploadData.sharedInstance().updataHeartRateWarning()
                            }
                        }
                    }
                } else {
                    self.actualHeartArray.removeAll()
                }
            })
        } else {
            CositeaBlueTooth.instance.closeActualHeartRate()
        }
    }

    //      获取血压的数据
    func checkBloodPressure(_ bloodPressure: @escaping (_ bloodPre: BloodPressureModel?) -> Void) {
        CositeaBlueTooth.instance.getBloodPressure({ [weak self] bloodPre in
            
            self?.saveBloodPressure(with: bloodPre)
            //if bloodPressure
            
            bloodPressure(bloodPre)
            
        })
    }

    /**
     *  收到全天概览历史数据，可以接收后保存或上传服务器
     *
     *  @param historyAllDayDataBlock 返回DayOverViewDataModel
     */
    func recieveHistoryAllDayData(with historyAllDayDataBlock: @escaping allDayModelBlock) {
        CositeaBlueTooth.instance.recieveHistoryAllDayData(with: { [weak self] model in
            
            guard let model = model else { return }
            let _ = self?.saveAllDayData(with: model)
            //adaLog(@"historyAllDayDataBlock - %@",historyAllDayDataBlock);
            //if historyAllDayDataBlock
            
            historyAllDayDataBlock(model)
            
        })
    }

    /**
     接收历史每小时计步和消耗
     
     @param historyHourDataBlock 同查询当天计步和消耗
     */
    func recieveHistoryHourData(with historyHourDataBlock: @escaping doubleArrayBlock) {
        CositeaBlueTooth.instance.recieveHistoryHourData(with: { [weak self] steps, costs, timeSeconds in
            self?.saveHourData(withTimeSeconds: timeSeconds, steps: steps, costs: costs)
            //if historyHourDataBlock
            
            historyHourDataBlock(steps, costs, timeSeconds)
            
        })
        
    }

    /**
     接收历史睡眠数据
     
     @param historySleepDataBlock 同查询当天睡眠数据
     */
    func recieveHistorySleepData(with historySleepDataBlock: @escaping sleepModelBlock) {
        CositeaBlueTooth.instance.recieveHistorySleepData(with: { [weak self] model in
            self?.saveSleepData(with: model)
            //if historySleepDataBlock
            
            historySleepDataBlock(model)
            
        })
        
    }

    /**
     接收历史心率
     
     @param historyHeartRateBlock 格式同查询当天心率
     */
    func recieveHistoryHeartRate(with historyHeartRateBlock: @escaping doubleIntArrayBlock) {
        CositeaBlueTooth.instance.recieveHistoryHeartRate(with: { [weak self] timeSeconds, index, array in
            self?.saveHeartRateArray(withTiemIndex: timeSeconds + index, heartRateArray: array)
            //if historyHeartRateBlock
            
            historyHeartRateBlock(timeSeconds, index, array)
            
        })
        
    }

    /**
     接收历史HRV数据
     
     @param historyHRVDataBlock 格式同查询当天历史数据
     */
    func recieveHistoryHRVData(with historyHRVDataBlock: @escaping intArrayBlock) {
        CositeaBlueTooth.instance.recieveHistoryHRVData(with: { [weak self] number, array in
            self?.saveHRVData(withTimeSeconds: number, hrvDataArray: array)
            //if historyHRVDataBlock
            
            historyHRVDataBlock(number, array)
            
        })
    }

    
    

    

    
    

    
    

    
    
    
    
    
    


    @objc func openActuralHeart() {
        changeHeartState(withState: true, block: nil)
    }


   




    func getActualHeartArray() -> [String] {
        return self.actualHeartArray
    }

   


// MARK: -- 保存数据具体方法
    func saveHRVData(withTimeSeconds timeSeconds: Int, hrvDataArray HRVDataArray: [Any]?) {
        var pilaoData: Data? = nil
        if let HRVDataArray = HRVDataArray {
            pilaoData = NSKeyedArchiver.archivedData(withRootObject: HRVDataArray)
        }
        #warning("CoreDataManage 還未建立")
//        let dic = CoreDataManage.shareInstance().querDayDetail(withTimeSeconds: timeSeconds)
        let dic = [String: Any]()
        if dic != nil {
            var mutDic = dic
            mutDic[GlobalProperty.kPilaoData] = pilaoData
            mutDic[GlobalProperty.ISUP] = "0"
            //        if( [AllTool isNeedAmendMacAddress:mutDic[DEVICEID]])
            //        {
            let deviceId = ToolBox.amendMacAddressGetAddress()
            mutDic[GlobalProperty.DEVICEID] = deviceId
            //        }
            //        if (!mutDic[DEVICEID]) {
            //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //            if (!deviceId) {
            //                deviceId =  DEFAULTDEVICEID;
            //            }
            //            [mutDic setValue:deviceId forKey:DEVICEID];
            //        }
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().updataDayDetailTable(withDic: mutDic)
        } else {
            let deviceType = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
            let deviceId = ToolBox.amendMacAddressGetAddress()
            var dictionnary: [AnyHashable : Any]? = nil
            if let pilaoData = pilaoData {
                dictionnary = [
                GlobalProperty.CurrentUserName_HCH : HCHCommonManager.instance.userAcount,
                GlobalProperty.DataTime_HCH : Int32(timeSeconds),
                GlobalProperty.kPilaoData : pilaoData,
                GlobalProperty.ISUP : "0",
                GlobalProperty.DEVICETYPE : deviceType,
                GlobalProperty.DEVICEID : deviceId
            ]
            }
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().creatDayDetailTabel(withDic: dictionnary)
        }
    }

    func saveHeartRateArray(withTiemIndex timeIndex: Int, heartRateArray array: [Any]?) {

        //    //adaLog(@"chakan -- %d",timeIndex);
        //    for (NSString * heart in array) {
        //        //adaLog(@"chakan -- %d",[heart intValue]);
        //    }
        var heartData: Data? = nil
        if let array = array {
            heartData = NSKeyedArchiver.archivedData(withRootObject: array)
        }
        #warning("CoreDataManage 還未建立")
//        var dic = CoreDataManage.shareInstance().querHeartData(withTimeSeconds: timeIndex)
        var dic = [String: Any]()
        if dic != nil {
            var mutDic = dic
            mutDic[GlobalProperty.HeartRate_ActualData_HCH] = heartData
            mutDic[GlobalProperty.ISUP] = "0"
            //        if( [AllTool isNeedAmendMacAddress:mutDic[DEVICEID]])
            //        {
            let deviceId = ToolBox.amendMacAddressGetAddress()
            mutDic[GlobalProperty.DEVICEID] = deviceId
            //        }
            //        if (!mutDic[DEVICEID]) {
            //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //            if (!deviceId) {
            //                deviceId =  DEFAULTDEVICEID;
            //            }
            //            [mutDic setValue:deviceId forKey:DEVICEID];
            //        }
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().updataHeartRate(withDic: mutDic)
        } else {
            let deviceType = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
            let deviceId = ToolBox.amendMacAddressGetAddress()
            //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //        if (!deviceId) {
            //            deviceId =  DEFAULTDEVICEID;
            //        }
            if let heartData = heartData {
                dic = [
                GlobalProperty.CurrentUserName_HCH : HCHCommonManager.instance.userAcount,
                GlobalProperty.DataTime_HCH : Int32(timeIndex),
                GlobalProperty.HeartRate_ActualData_HCH : heartData,
                GlobalProperty.ISUP : "0",
                GlobalProperty.DEVICETYPE : deviceType,
                GlobalProperty.DEVICEID : deviceId
            ]
            }
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().creatHeartRate(withDic: dic)
        }
    }

    //144 ，每个值表示十分钟
    func saveSleepData(with model: SleepModel?) {
        var sleepData: Data? = nil
        if let sleepArary = model?.sleepArary {
            sleepData = NSKeyedArchiver.archivedData(withRootObject: sleepArary)
        }
        #warning("CoreDataManage 還未建立")
//        var dic = CoreDataManage.shareInstance().querDayDetail(withTimeSeconds: model?.timeSeconds)
        var dic = [String: Any]()
        if dic != nil {
            var multDic = dic
            multDic[GlobalProperty.DataValue_SleepData_HCH] = sleepData
            multDic[GlobalProperty.kLightSleep] = model?.lightSleepTime ?? 0
            multDic[GlobalProperty.kDeepSleep] = model?.deepSleepTime ?? 0
            multDic[GlobalProperty.kAwakeSleep] = model?.awakeSleepTime ?? 0
            multDic[GlobalProperty.ISUP] = "0"
            //        if( [AllTool isNeedAmendMacAddress:multDic[DEVICEID]])
            //        {
            let deviceId = ToolBox.amendMacAddressGetAddress()
            multDic[GlobalProperty.DEVICEID] = deviceId
            //        }
            //        if (!multDic[DEVICEID]) {
            //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //            if (!deviceId) {
            //                deviceId =  DEFAULTDEVICEID;
            //            }
            //            [multDic setValue:deviceId forKey:DEVICEID];
            //        }
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().updataDayDetailTable(withDic: multDic)
        } else {
            let deviceType = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
            let deviceId = ToolBox.amendMacAddressGetAddress()
            //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //        if (!deviceId) {
            //            deviceId =  DEFAULTDEVICEID;
            //        }
            if let sleepData = sleepData {
                dic = [
                GlobalProperty.DataValue_SleepData_HCH : sleepData,
                GlobalProperty.DataTime_HCH : model?.timeSeconds ?? 0,
                GlobalProperty.CurrentUserName_HCH : HCHCommonManager.instance.userAcount,
                GlobalProperty.kLightSleep : model?.lightSleepTime ?? 0,
                GlobalProperty.kDeepSleep : model?.deepSleepTime ?? 0,
                GlobalProperty.kAwakeSleep : model?.awakeSleepTime ?? 0,
                GlobalProperty.ISUP : "0",
                GlobalProperty.DEVICEID : deviceId,
                GlobalProperty.DEVICETYPE : deviceType
            ]
            }
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().creatDayDetailTabel(withDic: dic)
        }
    }

    func saveOffLineData(withModel sport: SportModelMap) {
        //如果有这个开始
        if sport.fromTime.isEmpty == false {
            
            #warning("SQLdataManger 還未建立")
//            let array = SQLdataManger.getInstance().queryHeartRateData(withFromtime: sport?.fromTime)
            let array = [Int]()
            
            
            if array.count > 0 {
                #if DEBUG
                print("\(#function)\n在线运动  有重复的值")
                #endif
                return
            }
        } else {
            return
        }
        var dictionary: [AnyHashable : Any] = [:]
        dictionary["sportID"] = sport.sportID
        dictionary[GlobalProperty.CurrentUserName_HCH] = HCHCommonManager.instance.userAcount()
        //    [dictionary setValue:[AllTool compatibleDeviceType:sport.sportType] forKey:@"sportType"];
        dictionary["sportType"] = sport.sportType
        dictionary["sportDate"] = sport.sportDate
        dictionary["fromTime"] = sport.fromTime
        dictionary["toTime"] = sport.toTime
        dictionary["stepNumber"] = sport.stepNumber
        dictionary["kcalNumber"] = sport.kcalNumber
        dictionary["sportName"] = setupTitle(sport.sportType)
        let deviceType = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
        let deviceId = ToolBox.amendMacAddressGetAddress()

        dictionary[GlobalProperty.DEVICEID] = deviceId
        dictionary[GlobalProperty.DEVICETYPE] = deviceType
        dictionary[GlobalProperty.ISUP] = "0"
        dictionary[GlobalProperty.HAVETRAIL] = "0"

        let beginTime = (sport.startTimeSeconds - sport.timeSeconds) / 60 //开始分钟
        var endTime = (sport.stopTimeSeconds - sport.timeSeconds) / 60 //结束分钟

        if beginTime > 1439 {
            return
        }
        if endTime > 1439 {
            endTime = 1439
        }
        var heartArray2: [AnyHashable] = []
        if beginTime < endTime {
            //        int beginBao = beginTime/180 + 1;
            var stopBao = Int(Double(endTime) / 180.0 + 1)
            var number = TimeCallManager.instance.getIntervalOneMin(with: sport.startTimeSeconds, andEndTime: sport.stopTimeSeconds)
            //1～8 8个包，一个包3小时
            if stopBao > 8 {
                stopBao = 8
            }
            for i in 1...stopBao {
                //adaLog(@"第几个包  i= %d",i);
                
                
                #warning("CoreDataManage 還未建立")
//                let heartDic = CoreDataManage.shareInstance().querHeartData(withTimeSeconds: sport?.timeSeconds + i)
                let heartDic = [String: Any]()
                
                
                var array: [Any]? = nil
                if let hch = heartDic[GlobalProperty.HeartRate_ActualData_HCH] as? Data {
                    array = NSKeyedUnarchiver.unarchiveObject(with: hch) as! [Any]
                    let iii = NSKeyedUnarchiver.unarchiveObject(with: hch)
                }
                if array != nil && array?.count != 0 {
                    if let array = array as? [AnyHashable] {
                        heartArray2.append(contentsOf: array)
                    }
                } else {
                    for aa in 0..<180 {
                        heartArray2.append(0)
                    }
                }
            }
            assert(beginTime + number <= heartArray2.count, "离线心率溢出")
            if beginTime >= heartArray2.count {
                return
            }
            if beginTime + number > heartArray2.count {
                number = heartArray2.count - beginTime
            }
            let cunArray = (heartArray2 as NSArray).subarray(with: NSRange(location: beginTime, length: number))
            ////adaLog(@"截取前  - - - %@",heartArray2);
            //adaLog(@"离线 存储 心率的cunArray  - - - %@",cunArray);
            let heartData = NSKeyedArchiver.archivedData(withRootObject: cunArray)
            dictionary["heartRate"] = heartData
        }

        //adaLog(@"dictionary - - %@",dictionary);
        
        
        #warning("SQLdataManger 還未建立")
//        SQLdataManger.getInstance().insertData(withColumns: dictionary, toTableName: "ONLINESPORT")

    }

    func setupTitle(_ type: String?) -> String? {
        var titleString = ""
        var intType = Int(type ?? "") ?? 0
        if intType > 100 {
            intType = intType - 100
        }
        switch intType {
            case 0:
                titleString = NSLocalizedString("徒步", comment: "")
            case 1:
                titleString = NSLocalizedString("跑步", comment: "")
            case 2:
                titleString = NSLocalizedString("登山", comment: "")
            case 3:
                titleString = NSLocalizedString("球类", comment: "")
            case 4:
                titleString = NSLocalizedString("力量训练", comment: "")
            case 5:
                titleString = NSLocalizedString("有氧训练", comment: "")
            case 6:
                titleString = NSLocalizedString("自定义", comment: "")
            default:
                titleString = NSLocalizedString("徒步", comment: "")
        }

        return titleString
    }

    //- (void)hehesaveOffLineDataWithModel:(OffLineDataModel *)model
    //{
    //    NSDictionary *dic = [[SQLdataManger getInstance]getTotalDataWith:model.timeSeconds];
    //    if (dic) {
    //        testEventCount = [[dic objectForKey:TotalDayEventCount_DayData_HCH] intValue] + 1;
    //        [dic setValue:[NSNumber numberWithInt:testEventCount] forKey:TotalDayEventCount_DayData_HCH];
    //        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
    //    }else {
    //        testEventCount = 1;
    //        dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //               [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
    //               [NSNumber numberWithInt:model.timeSeconds],  DataTime_HCH,
    //               [NSNumber numberWithInt:0], TotalSteps_DayData_HCH,
    //               [NSNumber numberWithInt:0], TotalMeters_DayData_HCH,
    //               [NSNumber numberWithInt:0], TotalCosts_DayData_HCH,
    //               [NSNumber numberWithInt:[HCHCommonManager getInstance].sleepPlan ], Sleep_PlanTo_HCH,
    //               [NSNumber numberWithInt:[HCHCommonManager getInstance].stepsPlan ], Steps_PlanTo_HCH,
    //               [NSNumber numberWithInt:0],TotalDeepSleep_DayData_HCH,
    //               [NSNumber numberWithInt:0],TotalLittleSleep_DayData_HCH,
    //               [NSNumber numberWithInt:0],TotalWarkeSleep_DayData_HCH,
    //               [NSNumber numberWithInt:0],TotalSleepCount_DayData_HCH,
    //               [NSNumber numberWithInt:testEventCount],TotalDayEventCount_DayData_HCH,
    //               [NSNumber numberWithInt:0],TotalDataActivityTime_DayData_HCH,
    //               [NSNumber numberWithInt:[[TimeCallManager getInstance] getWeekIndexInYearWith:model.timeSeconds]], TotalDataWeekIndex_DayData_HCH,
    //               nil];
    //        [[SQLdataManger getInstance]insertSignalDataToTable:DayTotalData_Table withData:dic];
    //    }
    //
    //    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                             [[HCHCommonManager getInstance]UserAcount],CurrentUserName_HCH,
    //                             [NSNumber numberWithInt:model.timeSeconds],  DataTime_HCH,
    //                             [NSNumber numberWithInt:model.startSeconds], StartTime_ActualData_HCH,
    //                             [NSNumber numberWithInt:model.stopSeconds], StopTime_ActualData_HCH,
    //                             [NSNumber numberWithInt:testEventCount],SportEventIndex_HCH,
    //                             [NSNumber numberWithInt:-1], SportType_ActualData_HCH,
    //                             [NSNumber numberWithInt:model.steps],StepCount_ActualData_HCH,
    //                             [NSNumber numberWithInt:model.costs],CostCount_ActualData_HCH,
    //                             nil];
    //    [[SQLdataManger getInstance] insertSignalDataToTable:ACtualTimeData_Table withData:dataDic];
    //    if (self.offLineDataBlock)
    //    {
    //        self.offLineDataBlock(dic);
    //    }
    //}

    //保存包头为 0 ，全天的数据
    func saveAllDayData(with model: DayOverViewDataModel) -> [String : Any]? {
        
        
        #warning("SQLdataManger 還未建立")
//        var dic = SQLdataManger.getInstance().getTotalData(with: model?.timeSeconds)
        var dic = [String: Any]()
        
        
        let deviceId = ToolBox.amendMacAddressGetAddress()
        let macAddress = deviceId
        //    NSString *macAddress = [ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
        //    if (!macAddress)
        //    {
        //        macAddress = DEFAULTDEVICEID;
        //    }
        if dic != nil {
            dic[GlobalProperty.TotalSteps_DayData_HCH] = intToString(model.steps)
            dic[GlobalProperty.TotalMeters_DayData_HCH] = intToString(model.meters)
            dic[GlobalProperty.TotalCosts_DayData_HCH] = intToString(model.costs)
            dic[GlobalProperty.Sleep_PlanTo_HCH] = intToString(HCHCommonManager.instance.sleepPlan)
            dic[GlobalProperty.Steps_PlanTo_HCH] = intToString(HCHCommonManager.instance.stepsPlan)
            dic[GlobalProperty.TotalDataActivityTime_DayData_HCH] = intToString(model.activityTime)
            dic[GlobalProperty.TotalDataCalmTime_DayData_HCH] = intToString(model.calmTime)
            dic[GlobalProperty.kTotalDayActivityCost] = intToString(model.activityCosts)
            dic[GlobalProperty.kTotalDayCalmCost] = intToString(model.calmCosts)

            dic[GlobalProperty.DEVICETYPE] = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
            dic[GlobalProperty.DEVICEID] = macAddress
            dic[GlobalProperty.ISUP] = "0"
        } else {
            dic = [
            GlobalProperty.CurrentUserName_HCH : HCHCommonManager.instance.userAcount,
            GlobalProperty.DataTime_HCH : intToString(model.timeSeconds),
            GlobalProperty.TotalSteps_DayData_HCH : intToString(model.steps),
            GlobalProperty.TotalMeters_DayData_HCH : intToString(model.meters),
            GlobalProperty.TotalCosts_DayData_HCH : intToString(model.costs),
            GlobalProperty.Sleep_PlanTo_HCH : intToString(HCHCommonManager.instance.sleepPlan),
            GlobalProperty.Steps_PlanTo_HCH : intToString(HCHCommonManager.instance.stepsPlan),
            GlobalProperty.TotalDataActivityTime_DayData_HCH : intToString(model.activityTime),
            GlobalProperty.TotalDataCalmTime_DayData_HCH : intToString(model.calmTime),
            GlobalProperty.kTotalDayActivityCost : intToString(model.activityCosts),
            GlobalProperty.kTotalDayCalmCost : intToString(model.calmCosts),
            GlobalProperty.DEVICETYPE : String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE)),
            GlobalProperty.DEVICEID : macAddress,
            GlobalProperty.ISUP : "0"
        ]
        }
        
        
        #warning("SQLdataManger 還未建立")
//        SQLdataManger.getInstance().insertSignalData(toTable: DayTotalData_Table, withData: dic)
        
        
        
        return dic
    }

    func saveHourData(withTimeSeconds timeSeconds: Int, steps: [Any]?, costs: [Any]?) {
        var stepData: Data? = nil
        if let steps = steps {
            stepData = NSKeyedArchiver.archivedData(withRootObject: steps)
        }
        var costsData: Data? = nil
        if let costs = costs {
            costsData = NSKeyedArchiver.archivedData(withRootObject: costs)
        }

        
        #warning("CoreDataManage 還未建立")
//        let dic = CoreDataManage.shareInstance().querDayDetail(withTimeSeconds: timeSeconds)
        let dic = [String: Any]()
        
        
        
        if dic != nil {
            var dictionnaray = dic
            dictionnaray[GlobalProperty.kDayStepsData] = stepData
            dictionnaray[GlobalProperty.kDayCostsData] = costsData
            dictionnaray[GlobalProperty.ISUP] = "0"

            //        if( [AllTool isNeedAmendMacAddress:dictionnaray[DEVICEID]])
            //        {
            let deviceId = ToolBox.amendMacAddressGetAddress()
            dictionnaray[GlobalProperty.DEVICEID] = deviceId
            //        }
            //        if (!dictionnaray[DEVICEID]) {
            //            NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //            if (!deviceId) {
            //                deviceId =  DEFAULTDEVICEID;
            //            }
            //            [dictionnaray setValue:deviceId forKey:DEVICEID];
            //        }
            
            
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().updataDayDetailTable(withDic: dictionnaray)
            
            
            
        } else {
            let deviceType = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
            let deviceId = ToolBox.amendMacAddressGetAddress()
            //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //        if (!deviceId) {
            //            deviceId =  DEFAULTDEVICEID;
            //        }
            var dictionnary: [String : Any]? = nil
            if let stepData = stepData, let costsData = costsData {
                dictionnary = [
                GlobalProperty.CurrentUserName_HCH : HCHCommonManager.instance.userAcount,
                GlobalProperty.DataTime_HCH : Int32(timeSeconds),
                GlobalProperty.kDayStepsData : stepData,
                GlobalProperty.kDayCostsData : costsData,
                GlobalProperty.ISUP : "0",
                GlobalProperty.DEVICEID : deviceId,
                GlobalProperty.DEVICETYPE : deviceType]
            }
            
            
            #warning("CoreDataManage 還未建立")
//            CoreDataManage.shareInstance().creatDayDetailTabel(withDic: dictionnary)
            
            
            
        }
    }

    func saveBloodPressure(with bloodPre: BloodPressureModel?) {
        if bloodPre != nil {
            
            let deviceType = String(format: "%03d", UserDefaults.standard.integer(forKey: GlobalProperty.AllDEVICETYPE))
            let deviceId = ToolBox.amendMacAddressGetAddress()
            //        NSString *deviceId =[ADASaveDefaluts objectForKey:kLastDeviceMACADDRESS];
            //        if (!deviceId) {
            //            deviceId =  DEFAULTDEVICEID;
            //        }
            var dic: [AnyHashable : Any]? = nil
            if let BloodPressureID = bloodPre?.bloodPressureID, let userAcount = HCHCommonManager.instance.userAcount(), let BloodPressureDate = bloodPre?.bloodPressureDate, let StartTime = bloodPre?.startTime, let systolicPressure = bloodPre?.systolicPressure, let diastolicPressure = bloodPre?.diastolicPressure, let heartRate = bloodPre?.heartRate, let SPO2 = bloodPre?.spo2, let HRV = bloodPre?.hrv {
                dic = [
                GlobalProperty.BloodPressureID_def : BloodPressureID,
                GlobalProperty.CurrentUserName_HCH : userAcount,
                GlobalProperty.BloodPressureDate_def : BloodPressureDate,
                GlobalProperty.StartTime_def : StartTime,
                GlobalProperty.systolicPressure_def : systolicPressure,
                GlobalProperty.diastolicPressure_def : diastolicPressure,
                GlobalProperty.heartRateNumber_def : heartRate,
                GlobalProperty.SPO2_def : SPO2,
                GlobalProperty.HRV_def : HRV,
                GlobalProperty.ISUP : "0",
                GlobalProperty.DEVICEID : deviceId,
                GlobalProperty.DEVICETYPE : deviceType
            ]
            }
            ////adaLog(@"dic -- %@",dic);
            
            
            
            #warning("SQLdataManger 還未建立")
//            SQLdataManger.getInstance().insertSignalData(toTable: BloodPressure_Table, withData: dic)
            
            
            

            //NSDate *date = [[NSDate alloc]init];
            //NSString * currentDateStr = [date GetCurrentDateStr];

            //  NSArray * bloodArray  = [[SQLdataManger getInstance] queryBloodPressureWithDay:currentDateStr];
        }
    }
    
    func intToString(_ arguments: CVarArg...) -> String {
        return String(format: "%d", arguments)
    }
}
