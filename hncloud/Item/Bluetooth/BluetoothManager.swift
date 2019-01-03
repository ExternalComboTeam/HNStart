//
//  BluetoothManager.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import CoreBluetooth
import UIKit
import SwifterSwift

let Service_UUID = "FFF0"
let OAD_Service_UUID = "FEF5"
var HeartRate_Service_UUID: String {
    if #available(iOS 8, *) {
        return "Heart Rate"
    } else {
        return "180D"
    }
}

//#define HeartRate_Service_UUID  @"Heart Rate"
//#define HeartRate_Service_UUID  @"180D"
//#define WriteService_UDID @"FFF0"
//#define WriteCharactic_UUID  @"FFF3"

let Charatic_UDID1 = "FFF2"
let Notiify_Charatic = "FFF1"
let HeartRate_Notify_Charatic = "2A37"
let BodySensor_Charatic = "2A38"


let kState = UserDefaults.standard.integer(forKey: GlobalProperty.kUnitStateKye)

enum UnitState : Int {
    case none = 1
    case britishSystem
    case metric
}


@objc protocol BlueToothManagerDelegate: NSObjectProtocol {
    //蓝牙是否连接，YES表示连接,NO表示断开
    @objc optional func blueToothManagerIsConnected(_ isConnected: Bool, connect peripheral: CBPeripheral?)
    @objc optional func blueToothManagerReceiveNotify(_ Dat: Data?)
    @objc optional func blueToothManagerReceiveHeartRateNotify(_ Dat: Data?)
    @objc optional func callbackConnectTimeAlert(_ TimeAlert: Int)
    @objc optional func callbackCBCentralManagerState(_ state: CBManagerState)
}

class BlueToothManager: NSObject {
    
    
    // MARK: - Singleton.
    
    static let instance = BlueToothManager()
    
    
    // MARK: - Property.
    
    //1为未提示，2为已提示
    var isSeek: Int = 0
    /*是否找到外设  1 没有找到  2 找到了 */
    
    weak var delegate: BlueToothManagerDelegate?
    var connectUUID: String? = ""
    
    // 连接与否
    var isConnected = false
    
    var deviceName: String? = ""
    var dataArray: [Data] = []
    var sendingData: Data?
    var resendCount: Int = 0
    var canPaired = false
    var romURL = ""
    
    
    
    var cbCenterManger: CBCentralManager?
    var cbServices: CBService?
    var cbCharacteristcs: CBCharacteristic?
    //    CBPeripheral *cbPeripheral;
    
    var rdCharactic1: CBCharacteristic?
    var notifyCharactic: CBCharacteristic?
    var heartRateNotifyCharactic: CBCharacteristic?
    var PairCharactic: CBCharacteristic?
    var OAD_notifyCharactic: CBCharacteristic?
    var OAD_rdCharactic_Uuid1: CBCharacteristic?
    var OAD_rdCharactic_Uuid4: CBCharacteristic?
    var OAD_rdCharactic_Uuid5: CBCharacteristic?
    var transString = ""
    var uuidArray: [AnyHashable] = []
    var sendData: Data?
    var reviceData: NSMutableData?
    var toSendData_OAD: Data?
    var isPersonOper = false
    //    BOOL isConnecting;
    var myTimer: Timer? //定时连接外设
    var weatherTimer: Timer? //天气定时器
    var connectTime: Int = 0 //连接了几次蓝牙
    var hearRateTime: Timer? //定时请求当天全天心率

    
    var cbPeripheral: CBPeripheral?
    var isConnecting = false
    var checkPageManagerNum: Int = 0
    /*  保证一秒内 只发送一次 */
    var queryCustomAlarmNum: Int = 0
    /*  保证一秒内 只发送一次 */
    var queryJiuzuoAlarmNum: Int = 0
    /*  保证一秒内 只发送一次 *///
    var queryHeartAndtiredNum: Int = 0
    //  保证一秒内 只发送一次
    var sendWeatherNum: Int = 0
    /*发送天气 保证一秒内 只发送一次 */
    var coreBlueRefreshNum: Int = 0
    //两秒内刷新一次
    
    
    // MARK: - Init.
    
    override init() {
        super.init()
        
        connectTime = 0
        isSeek = 1
        //没有找到
        UserDefaults.standard.set("1", forKey: GlobalProperty.SEARCHDEVICEISSEEK)
        reviceData = NSMutableData()
        canPaired = true
        startScan()
        
        //初始化属性
        checkPageManagerNum = 0
        queryCustomAlarmNum = 0
        queryJiuzuoAlarmNum = 0
        //    self.queryHeartAndtiredNum = 0;
        sendWeatherNum = 0
        coreBlueRefreshNum = 0

    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        cbCenterManger?.stopScan()
        cbPeripheral?.delegate = nil
        cbCenterManger?.delegate = nil
        cbCenterManger = nil
        
        if cbPeripheral != nil {
            cbCenterManger?.cancelPeripheralConnection(cbPeripheral!)
        }
        
        cbServices = nil
        cbCharacteristcs = nil
        rdCharactic1 = nil
        sendData = nil
        isSeek = 1
        
        //没有找到
        UserDefaults.standard.set("1", forKey: GlobalProperty.SEARCHDEVICEISSEEK)
    }




    
    
    func ArraySize(_ ARR: [Any]) -> Int {
        
        return MemoryLayout.size(ofValue: ARR) / MemoryLayout.size(ofValue: ARR[0])
    }
    
    
    // MARK: - 蓝牙模块(发送蓝牙指令)
    
    /// 开始扫描
    func startScan() {
        
        cbCenterManger?.stopScan()
        cbCenterManger = nil
        if cbCenterManger == nil {
            cbCenterManger = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    /// 停止扫描设备
    func stopScanDevice() {
        
        if cbCenterManger != nil {
            cbCenterManger?.stopScan()
            //cbCenterManger = nil;
            uuidArray.removeAll()
        }
    }
    
    
    /// 根据UUID连接设备
    ///
    /// - Parameter connectUUID: 要连接设备的UUID，NSString格式，此方法不提供连接是否成功的判断，请用下方监测蓝牙连接状态方法来监测连接成功或设备断开
    func connect(withUUID connectUUID: String) {
        
        // 没有找到
        isSeek = 1
        UserDefaults.standard.set("1", forKey: GlobalProperty.SEARCHDEVICEISSEEK)
        
        self.connectUUID = connectUUID
        
        guard cbCenterManger != nil, cbCenterManger?.state == .poweredOn else {
            return
        }
        
        var peripheral: CBPeripheral?
        
        if let nsUUID = UUID(uuidString: connectUUID) {
            let peripheralArray = cbCenterManger?.retrievePeripherals(withIdentifiers: [nsUUID])
            var devPerpheral: CBPeripheral?
            if let peripherals = peripheralArray, peripherals.count > 0 {
                for item in peripherals {
                    devPerpheral = item
                }
                peripheral = devPerpheral
            }
        }
        
        cbPeripheral = peripheral
        isConnecting = false
        
        if cbPeripheral != nil {
            cbCenterManger?.connect(cbPeripheral!, options: nil)
            perform(#selector(self.connectOutTime), with: nil, afterDelay: 5.0)
            if cbPeripheral?.state == .connected || cbPeripheral?.state == .connecting {
                //adaLog(@"------------------!!!!!-----------   外设已经被连接！");
            } else {
                cbCenterManger?.stopScan()
                cbCenterManger?.scanForPeripherals(withServices: [CBUUID(string: "180d"), CBUUID(string: "1814")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            }
        } else {
            cbCenterManger?.stopScan()
            cbCenterManger?.scanForPeripherals(withServices: [CBUUID(string: "180d"), CBUUID(string: "1814")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }

    }
    
    /// 连接外设
    func connect(_ peripheral: CBPeripheral?) {
        guard let _peripheral = peripheral else { return }
        cbCenterManger?.connect(_peripheral, options: nil)
    }
    
    /// 断开蓝牙方法
    ///
    /// - Parameter uuid: 当前连接设备的UUID
    func disConnectPeripheral(withUuid uuid: String?) {
        
        if cbPeripheral != nil && heartRateNotifyCharactic != nil && notifyCharactic != nil {
            cbPeripheral?.setNotifyValue(false, for: heartRateNotifyCharactic!)
            cbPeripheral?.setNotifyValue(false, for: notifyCharactic!)
        }
        if cbPeripheral != nil && cbCenterManger != nil {
            cbCenterManger?.cancelPeripheralConnection(cbPeripheral!)
            cbCenterManger?.stopScan()
        }
        isPersonOper = true
        connectUUID = ""
        if let isValid = myTimer?.isValid, isValid {
            myTimer?.invalidate()
            myTimer = nil
        }
        if let isValid = weatherTimer?.isValid, isValid {
            weatherTimer?.invalidate()
            weatherTimer = nil
        }
        if let isValid = hearRateTime?.isValid, isValid {
            hearRateTime?.invalidate()
            hearRateTime = nil
        }
        
        connectUUID = nil

        
    }
    
    /**
     *  获取设备是否已连接
     *
     *  @param device 设备对象
     *
     *  @return YES 已连接  NO 未连接
     */
    func readDeviceIsConnect(_ device: CBPeripheral?) -> Bool {
        
        if device?.state == .connected {
            return true //连接状态
        } else {
            return false //未连接状态(断开状态)
        }

    }
    
    
    // MARK:   --   设置模块(发送命令指令，例如同步时间)
    
    /**
     *
     *app与手环的时间同步
     *
     */
    @objc func synsCurTime() {
        
        let seconds = UInt32(Date().timeIntervalSince1970) + UInt32(NSTimeZone.system.secondsFromGMT())
        //    UInt32 seconds = [[TimeCallManager getInstance]getYYYYMMDDHHmmSecondsWith:@"2014-12-24 23:58"] + 8*60*60;
        var checkNum: UInt32 = 0x68 + UInt32(BlueToothFunctionIndexEnum.timeSync.rawValue) + (seconds & 255) + ((seconds >> 8) & 255) + ((seconds >> 16) & 255) + ((seconds >> 24) & 255) + 0x04
        checkNum = checkNum % 256
        var transData: [UInt32] = [0x68, UInt32(BlueToothFunctionIndexEnum.timeSync.rawValue), 0x04, 0x00, seconds, seconds >> 8, seconds >> 16, seconds >> 24, checkNum, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
        
    }
    
    /**
     *
     *同步语言。支持中，英，泰。不是这三种语言。就是英文
     *
     */
    @objc func setLanguage() {
        
        #warning("BLETool 尚未建立")
        
//        var langage: Int = BleTool.setLanguage()
//        setLanguageByte(langage)

    }
    
    /**
     *
     *发送手环的显示日期的格式 日月
     *
     */
    @objc func sendBraMMDDformat() {
        var transData = [0x68, BlueToothFunctionIndexEnum.unitSet.rawValue, 0x03, 0x00, 0x01, 0x05, (BLETool.getMMDDformat() - 1)]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *读取信息提醒的支持
     *
     */
    @objc func checkInformation() {
        
        var transData = [0x68, BlueToothFunctionIndexEnum.openAntiLoss.rawValue, 0x02, 0x00, 0x02, 0x10]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        //adaLog(@"checkInformation - -%@",lData);
        
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)

    }
    
    /**
     *
     *app设置手环的公制/英制    NO:公制     YES:英制
     *
     */
    func setUnitStateWithState(_ state: Bool) {
        var transData = [0x68, 0x02, 0x03, 0x00, 0x01, 0x01, state.int]
        var data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)

    }
    
    /**
     *
     * app设置手环的时间是12小时制或24小时制
     *  NO:12小时制    YES:24小时制
     */
    @objc func setBindDateStateWithState(_ state: Bool) {
        
//        var formatStringForHours = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
//        var containsA: NSRange? = (formatStringForHours as NSString?)?.range(of: "a")
//        var hasAMPM: Bool = Int(containsA?.location ?? 0) != NSNotFound
        #warning("CositeaBlueTooth 還未建立")
        // app设置手环的时间是12小时制或24小时制
//        CositeaBlueTooth.sharedInstance().setBindDateStateWithState(!hasAMPM)
    }
    
    /**
     *
     *检查手环电量
     *
     */
    @objc func checkPower() {

        var transData = [0x68, BlueToothFunctionIndexEnum.checkPower.rawValue, 0x00, 0x00, 0x6b, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)

    }
    
    /**
     *
     * 拍照功能  - 开关
     * YES - 打开拍照  NO - 关闭拍照
     */
    func setPhotoWithState(_ state: Bool) {
        var transData = [0x68, 0x0d, 0x01, 0x00, (!state).int]
        var data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
    }
    
    /**
     *
     *找手环功能
     *
     */
    func findBindState(_ state: Bool) {
        let state = !state
        var transData = [0x68, 0x13, 0x01, 0x00, state.int]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
    }

    
    /**
     *
     *清除手环数据
     *
     */
    func resetDevice() {
        var transData = [0x68, BlueToothFunctionIndexEnum.resetDevice.rawValue, 0x01, 0x00, 0x01, 0x7b, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
        perform(#selector(self.synsCurTime), with: nil, afterDelay: 0.6)

    }
    
    /**
     *
     *检查手环版本
     *
     */
    func checkVersion() {
        var transData = [0x68, BlueToothFunctionIndexEnum.checkVersion.rawValue, 0x00, 0x00, 0x6f, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *开启实时心率
     *
     */
    func heartRateNotifyEnable(_ isEnable: Bool) {
        
        if let cbPeripheral = cbPeripheral, let heartRateNotifyCharactic = heartRateNotifyCharactic {
            cbPeripheral.setNotifyValue(isEnable, for: heartRateNotifyCharactic)
            //adaLog(@"使能心率");
        }

    }
    
    /**
     *
     *设置自定义闹铃
     *
     */
    func setCustomAlarmWithStatus(_ status: Int, alarmIndex: Int, alarmType: Int, alarmCount: Int, alarmtimeArray: [String], `repeat`: inout Int, notice noticeString: String?) {
        
        let noticeString = noticeString?.replacingOccurrences(of: " ", with: " ")
        var strData: Data? = utf8(toUnicode: noticeString)
        //adaLog(@"test - data  - pang- %@",strData);
        var len: Int = 0
        if alarmType == 6 {
            len = 5 + alarmtimeArray.count * 2 + (strData?.count ?? 0)
        } else {
            len = 5 + alarmtimeArray.count * 2
        }
        
        var checkNum: Int = 0x68 + BlueToothFunctionIndexEnum.customAlarm.rawValue + len + status + alarmIndex + alarmCount + alarmType
        var transData = [0x68, BlueToothFunctionIndexEnum.customAlarm.rawValue, len, 0x00, status, alarmIndex, alarmType, alarmCount]
        let lData = NSMutableData(bytes: &transData, length: ArraySize(transData))
        for index in 0..<alarmtimeArray.count {
            
            let hour = (alarmtimeArray[index] as NSString).intValue
            let min = ((alarmtimeArray[index] as NSString).substring(from: 3) as NSString).intValue
            
            var timeData = [hour, min]
            checkNum = checkNum + Int(hour) + Int(min)

            lData.append(&timeData, length: ArraySize(timeData))
        }
        checkNum = checkNum + `repeat`
        if alarmType == 6 {
            if let data = strData {
                var dat = [UInt8](data)
                for index in 0..<data.count {
                    checkNum += Int(dat[index])
                }
            }
        }
        
        checkNum = checkNum % 256
        lData.append(&`repeat`, length: 1)
        if alarmType == 6 {
            if let data = strData {
                lData.append(data)
            }
        }
        lData.append(&checkNum, length: 1)
        var endData: [UInt8] = [0x16]
        lData.append(&endData, length: 1)
        if rdCharactic1 != nil {
            if lData.length > 20 {
                let cishu: Int = lData.length / 20
                var cache: Data = lData as Data
                for _ in 0...cishu {
                    if cache.count > 20 {
                        #if DEBUG
                        print("cache = \(cache)")
                        #endif
                        cbPeripheral?.writeValue(cache.subdata(in: 0..<20), for: rdCharactic1!, type: .withoutResponse)
                        cache = cache.subdata(in: 20..<cache.count)
                    } else {
                        #if DEBUG
                        print("cache = \(cache)")
                        #endif
                        cbPeripheral?.writeValue(cache, for: rdCharactic1!, type: .withoutResponse)
                    }
                }
            } else {
                cbPeripheral?.writeValue(Data(referencing: lData), for: rdCharactic1!, type: .withoutResponse)
            }
        }
        
        //    [self  sendupdateData:lData];
        //    if (rdCharactic1) {
        //        if (lData.length > 20)
        //        {
        //            [cbPeripheral writeValue:[lData subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        //            NSData *cache = [lData subdataWithRange:NSMakeRange(20, lData.length - 20)];
        //            if ([cache length] > 20)
        //            {
        //                [cbPeripheral writeValue:[cache subdataWithRange:NSMakeRange(0, 20)] forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        //                cache = [cache subdataWithRange:NSMakeRange(20, cache.length - 20)];
        //                if (cache.length > 20)
        //                {
        //                    [cbPeripheral writeValue:cache forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        //                }
        //                else
        //                {
        //                }
        //            }
        //            else
        //            {
        //                [cbPeripheral writeValue:cache forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        //            }
        //
        //        }else {
        //            [cbPeripheral writeValue:lData forCharacteristic:rdCharactic1 type:CBCharacteristicWriteWithoutResponse];
        //        }
        //    }
    }
    
    /**
     *
     *查询自定义闹铃
     *
     */
    func queryCustomAlarm() {
        if queryCustomAlarmNum <= 0 {
            queryCustomAlarmNum += 1
            for i in 0..<8 {
                var transData = [0x68, BlueToothFunctionIndexEnum.customAlarm.rawValue, 0x02, 0x00, 0x00, i]
                let lData = NSData(bytes: &transData, length: ArraySize(transData))
                appendingCheckNumData(Data(referencing: lData), isNeedResponse: true)
            }
            perform(#selector(self.queryCustomAlarmNumber), with: nil, afterDelay: 1.0)
        }
    }
    
    /**
     *
     *删除自定义闹铃
     *
     */
    func closeCustomAlarm(with index: Int) {
        var transData = [0x68, BlueToothFunctionIndexEnum.customAlarm.rawValue, 0x02, 0x00, 0x02, index]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: true)
    }

    /**
     *
     *心率监控间隔 - 心率自动监控开关 -查询
     *
     */
    func queryHeartAndtired() {
        //    if(self.queryHeartAndtiredNum<=0)
        //    {
        
        //    if(self.queryHeartAndtiredNum<=0)
        //    {
        var transData = [0x68, 0x02, 0x03, 0x00, 0x00, 0x02, 0x04]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
        
        //        self.queryHeartAndtiredNum++;
        //        [self performSelector:@selector(queryHeartAndtiredNumber) withObject:nil afterDelay:1.0f];
        //    }
    }
    
    /**
     *
     * 心率自动监控开关
     * NO：关闭    YES：开启
     */
    func setHeartHZState(_ state: Int) {
        var transData = [0x68, 0x02, 0x03, 0x00, 0x01, 0x04, state]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
    }
    
    /**
     *
     * 心率监控间隔 -- 设置 -- 常常设置30分钟或60分钟
     *
     */
    func setHeartDuration(_ state: Int) {
        
        if state == GlobalProperty.continuityMonitorNumber {
            var transData = [0x68, 0x02, 0x03, 0x00, 0x01, 0x02, 0x01]
            let data = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
            //        interfaceLog(@"连续心率监测 APP set %@",data);
        } else {
            var transData = [0x68, 0x02, 0x03, 0x00, 0x01, 0x02, state]
            let data = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
        }
        
    }
    
    /**
     *
     * 心率预警 - 读取
     *
     */
    @objc func queryHeartAlarm() {
        var transData = [0x68, BlueToothFunctionIndexEnum.heartRateAlarm.rawValue, 0x01, 0x00, 0x02, 0x7b, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     * 心率预警 - 设置
     *
     */
    func setHeartAlarmWithMin(_ minHeart: Int, andMax maxHeart: Int, andState state: Int) {
        
        var newState: Int {
            switch state {
            case 0:
                return 1
            case 1:
                return 0
            default:
                return 0
            }
        }
        
        let checkNum: Int = 0x68 + BlueToothFunctionIndexEnum.heartRateAlarm.rawValue + 0x04 + 0x01 + newState + maxHeart + minHeart
        var transData = [0x68, BlueToothFunctionIndexEnum.heartRateAlarm.rawValue, 0x04, 0x00, 0x01, newState, maxHeart, minHeart, checkNum, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *固件升级
     *
     */
    func startUpdateHard(withURL romURL: String?) {
    }
    
    /**
     *
     *设置计步参数
     *
     */
    func setStepPramWithHeight(_ height: Int, andWeight weight: Int, andSexIndex sexIndex: Int, andAge age: Int) {
        var checkNum: Int = 0x68 + BlueToothFunctionIndexEnum.setStepPram.rawValue + 0x04 + height + weight + age + sexIndex
        checkNum = checkNum % 256
        var transData = [0x68, BlueToothFunctionIndexEnum.setStepPram.rawValue, 0x04, 0x00, height, weight, sexIndex, age, checkNum, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        //    adaLog(@"设置计步参数 app set %@",lData);
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *查询设备是否支持某功能
     *
     */
    @objc func checkAction() {
        
        UserDefaults.standard.set("44", forKey: GlobalProperty.NEWALARM)
        UserDefaults.standard.set("0", forKey: GlobalProperty.HEARTCONTINUITY)
        
        //    Byte transData[] = {0x68,0x32,0x04,0x00,0x01,0x01,0x02,0x03};注意： 原来的0x01,0x02暂时保留不用。
        
        var transData = [0x68, BlueToothFunctionIndexEnum.checkAction.rawValue, 0x04, 0x00, 0x01, 0x03, 0x04, 0x05]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        //    interfaceLog(@" APP查询功能支持码 ask%@",data);
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)

    }
    
    /**
     *
     *APP查询设备能支持的参数
     *
     */
    @objc func checkParameter() {
    
        var transData = [0x68, BlueToothFunctionIndexEnum.checkAction.rawValue, 0x03, 0x00, 0x02, 0x01, 0x02]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        
        //     interfaceLog(@"  APP查询设备能支持的参数 ask%@",data);
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)

    }
    
    // MARK:   --   功能模块(发送数据指令）
    /**
     *
     *读取对应的提醒状态
     *
     */
    func querySystemAlarm(with index: Int) {
        var transData = [0x68, BlueToothFunctionIndexEnum.openAntiLoss.rawValue, 0x02, 0x00, 0x01, index]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *设置对应的提醒状态
     *
     */
    func setSystemAlarmWith(_ index: Int, status: Int) {
        var transData = [0x68, BlueToothFunctionIndexEnum.openAntiLoss.rawValue, 0x03, 0x00, 0x00, index, status]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *电话提醒延时功能
     *
     */
    func queryPhoneDelay() {
        var transData = [0x68, BlueToothFunctionIndexEnum.phoneDelay.rawValue, 0x01, 0x00, 0x02, 0x7d, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *电话提醒延时功能 - 设置
     *
     */
    func setPhoneDelay(_ seconds: Int) {
        var transData = [0x68, BlueToothFunctionIndexEnum.phoneDelay.rawValue, 0x02, 0x00, 0x01, seconds]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *运动目标 。睡眠目标  睡眠时间 - 主动发送
     *
     */
    func activeCompletionDegree() {
        
        if UserDefaults.standard.integer(forKey: GlobalProperty.COMPLETIONDEGREESUPPORT) != 1 {
            return
        }
        #warning("TimeCallManager has not been created.")
//        var timeSeconds: Int = TimeCallManager.getInstance().getSecondsOfCurDay()
//        var dic = SQLdataManger.getInstance().getTotalData(with: timeSeconds)
//        var sleepPlan: Int = 0
//        var stepPlan: Int = 0
//        sleepPlan = Int(dic[Sleep_PlanTo_HCH])
//        stepPlan = Int(dic[Steps_PlanTo_HCH])
//        var sleepArr = AllTool.number(toArray: sleepPlan)
//        var stepArr = AllTool.number(toArray: stepPlan)
//        var length: Int = SleepTool.sleepLengthSeek()
//        //    int time = [dict[@"time"] intValue];
//        //    int min = [dict[@"min"] intValue];
//        //    length =  600;
//        var shi = Int(Double(length) / 60.0)
//        var min: Int = length % 60
//
//        var transData = [0x68, 0x2d, 0x0b, 0x00, 0x02, Int(stepArr[0]), Int(stepArr[1]), Int(stepArr[2]), Int(stepArr[3]), Int(sleepArr[0]), Int(sleepArr[1]), Int(sleepArr[2]), Int(sleepArr[3]), min, shi]
        //        var data = Data(bytes: &trletData, length: ArraySize(transData))
//        appendingCheckNumData(data, isNeedResponse: true)
//        //    interfaceLog(@"CompletionDegree  222   == APP - set %@",data);
//        adaLog("target ==  APP - set %@", data)
        
    }
    
    // MARK:   --   获取手环数据模块(例如步数)
    /**
     *
     * 获取当天全天数据概览
     *
     */
    @objc func getCurDayTotalData() {
        
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        
        let comps = calendar.dateComponents([.year, .month, .day], from: now)
        if let day = comps.day, let month = comps.month, let year = comps.year {
            var transData = [0x68, BlueToothFunctionIndexEnum.updateTotalData.rawValue, 0x04, 0x00, day, month, year % 100, 0x00]
            let data = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: data), isNeedResponse: true)
        }
    }

    
    /**
     *
     *查询每小时步数及卡路里消耗
     *
     */
    @objc func getCurDayTotalDataWith(type: NSNumber) {
        
        let type = type.intValue
        
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        
        let comps = calendar.dateComponents([.year, .month, .day], from: now)
        if let day = comps.day, let month = comps.month, let year = comps.year {
            var transData = [0x68, BlueToothFunctionIndexEnum.updateTotalData.rawValue, 0x04, 0x00, day, month, year % 100, type]
            let data = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: data), isNeedResponse: true)
        }
    }
    
    /**
     *
     *请求最新的两个心率包
     *
     */
    func getNewestCurDayTotalHeartData() {
        let queue = DispatchQueue.global(qos: .default)
        queue.async(execute: {
            let calendar = Calendar(identifier: .gregorian)
            let now = Date()
            var comps = calendar.dateComponents([.year, .month, .day], from: now)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            let string = formatter.string(from: now)
            
            var packNumber = Int(string) ?? 0 / 3 + 1
            let packNumberSpecific = packNumber
            var isChao = false
            if packNumber > 2 {
                packNumber = 2
                isChao = true
            }
            
            for i in 0..<packNumber {
                if isChao {
                    HCHCommonManager.instance.requestIndex = packNumberSpecific - 2 + i + 1
                } else {
                    HCHCommonManager.instance.requestIndex = i + 1
                }
                if let day = comps.day, let month = comps.month, let year = comps.year {
                    var transData = [0x68, BlueToothFunctionIndexEnum.updateTotalData.rawValue, 0x06, 0x00, day, month, year % 100, 0x03, 0x08, HCHCommonManager.instance.requestIndex]
                    let data = NSData(bytes: &transData, length: self.ArraySize(transData))
                    DispatchQueue.main.async(execute: {
                        self.appendingCheckNumData(Data(referencing: data), isNeedResponse: true)
                    })
                }
            }
        })
        
    }
    
    /**
     *
     *查看当天心率数据
     *
     */
    @objc func getCurDayTotalHeartData() {
        
        var queue = DispatchQueue.global(qos: .default)
        queue.async(execute: {
            
            let calendar = Calendar(identifier: .gregorian)
            let now = Date()
            
            let comps = calendar.dateComponents([.year, .month, .day], from: now)
//
//
//            var calendar = Calendar(identifier: NSCalendar.Identifier(NSGregorianCalendar))
//            var now: Date?
//            var unitFlags: NSCalendar.Unit = [.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit]
//            now = Date()
//            var comps: DateComponents? = nil
//            if let now = now {
//                comps = calendar?.components(unitFlags, from: now)
//            }
//
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            let string = formatter.string(from: now)
            
            var packNumber = Int(string) ?? 0 / 3 + 1
            let packNumberSpecific = packNumber
            var isChao = false
            if packNumber > 2 {
                packNumber = 2
                isChao = true
            }
            for i in 0..<packNumber {
                if isChao {
                    HCHCommonManager.instance.requestIndex = packNumberSpecific - 2 + i + 1
                } else {
                    HCHCommonManager.instance.requestIndex = i + 1
                }
                if let day = comps.day, let month = comps.month, let year = comps.year {
                    var transData = [0x68, BlueToothFunctionIndexEnum.updateTotalData.rawValue, 0x06, 0x00, day, month, year % 100, 0x03, 0x08, HCHCommonManager.instance.requestIndex]
                    let data = NSData(bytes: &transData, length: self.ArraySize(transData))
                    DispatchQueue.main.async(execute: {
                        self.appendingCheckNumData(Data(referencing: data), isNeedResponse: true)
                    })
                }
            }
        })
    }
    
    /**
     *
     *查询HRV值
     *
     */
    @objc func getPilaoData() {
        
        if !HCHCommonManager.instance.pilaoValue {
            return
        }
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async(execute: {
            let calendar = Calendar(identifier: .gregorian)
            let now = Date()
            
            let comps = calendar.dateComponents([.year, .month, .day], from: now)
            
            if let year = comps.year, let month = comps.month, let day = comps.day {
                var transData = [0x68, BlueToothFunctionIndexEnum.updateTiredData.rawValue, 0x03, 0x00, day, month, year % 100]
                let data = NSData(bytes: &transData, length: self.ArraySize(transData))
                DispatchQueue.main.async(execute: {
                    self.appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
                })
            }
        })
    }
    
    /**
     *
     *久坐提醒功能 - 查询
     *
     */
    func queryJiuzuoAlarm() {
        if queryJiuzuoAlarmNum <= 0 {
            var transData = [0x68, 0x14, 0x02, 0x00, 0x00, 0xff]
            let data = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
            queryJiuzuoAlarmNum += 1
            perform(#selector(self.queryJiuzuoAlarmNumber), with: nil, afterDelay: 1.0)
        }
        
    }
    
    @objc func queryJiuzuoAlarmNumber() {
        queryJiuzuoAlarmNum -= 1
    }

    
    /**
     *
     *久坐提醒功能 - 设置
     *
     */
    func setJiuzuoAlarmWithTag(_ tag: Int, isOpen: Bool, beginHour: Int, minite beginMinite: Int, endHour: Int, minite endMinite: Int, duration: Int) {
        var transData = [0x68, 0x14, 0x08, 0x00, 0x01, tag, isOpen.int, beginMinite, beginHour, endMinite, endHour, duration]
        var data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)

    }
    
    /**
     *
     *久坐提醒功能 - 删除
     *
     */
    func deleteJiuzuoAlarm(withTag tag: Int) {
        var transData = [0x68, 0x14, 0x02, 0x00, 0x02, tag]
        var data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
    }
    
    // MARK: -- ada 写
    /**
     *
     *打开心率的命令
     *
     */
    @objc func openHeartRate() {
        var transData = [0x68, BlueToothFunctionIndexEnum.getActualData.rawValue, 0x01, 0x00, 0x01]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *定时获取数据  用于在线运动
     *
     */
    func timerGetHeartRateData() {
        var transData = [0x68, BlueToothFunctionIndexEnum.getActualData.rawValue, 0x01, 0x00, 0x00, 0x6f, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        //    [self appendingCheckNumData:lData isNeedResponse:NO];
        if rdCharactic1 != nil {
            cbPeripheral?.writeValue(Data(referencing: lData), for: rdCharactic1!, type: .withoutResponse)
        }
    }
    
    /**
     *
     *关闭心率的命令
     *
     */
    func closeHeartRate() {
        var transData = [0x68, BlueToothFunctionIndexEnum.getActualData.rawValue, 0x01, 0x00, 0x02]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *回复血压
     *
     */
    func answerBloodPressure() {
        var transData = [0x68, BlueToothFunctionIndexEnum.bloodPressure.rawValue, 0x01, 0x00, 0x00] //{0x68,0x06,0x01,0x00,0x02};
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *  告诉设备，是否准备接收数据
     *
     */
    func readyReceive(_ number: Int) {
        //    Byte transData[] = {0x68,0x2a,0x02,0x00,0x01,number};
        var transData = [0x68, BlueToothFunctionIndexEnum.bloodPressure.rawValue, 0x02, 0x00, 0x01, 0x00] //不想接收原始数据
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *  回答设备，是否准备接收数据
     *
     */
    func answerReadyReceive(_ number: Int) {
        //    Byte transData[] = {0x68,0x2a,0x02,0x00,0x02,number};//不想接收原始数据
        var transData = [0x68, BlueToothFunctionIndexEnum.bloodPressure.rawValue, 0x02, 0x00, 0x02, 0x00] //不想接收原始数据
        var lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
        
        //     interfaceLog(@"准备好接收血压原始数据  app answer %@",lData);
    }
    
    /**
     *
     *  回答设备， 校正值
     *
     */
    func answerCorrectNumber() {
        
        let diya = UserDefaults.standard.integer(forKey: GlobalProperty.BLOODPRESSURELOW)
        let gaoya = UserDefaults.standard.integer(forKey: GlobalProperty.BLOODPRESSUREHIGH)
        
        //    40-100，收缩压90-180
        if diya >= 40 && gaoya >= 90 {
            var transData = [0x68, BlueToothFunctionIndexEnum.bloodPressure.rawValue, 0x03, 0x00, 0x04, gaoya, diya]
            let lData = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
        } else {
            
        }
    }
    
    /**
     *
     * 回答设备手环设置APP参数
     *
     */
    func answerBraceletSetParam(_ code: Int) {
        var transData = [0x68, BlueToothFunctionIndexEnum.checkNewLength.rawValue, 0x02, 0x00, code, 0x00]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        //     interfaceLog(@"手环设置APP参数 app answer %@",lData);
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *  设置设备， 校正值   APP设置血压测量配置参数
     *
     */
    @objc func setupCorrectNumber() {
        let diya = UserDefaults.standard.integer(forKey: GlobalProperty.BLOODPRESSURELOW)
        let gaoya = UserDefaults.standard.integer(forKey: GlobalProperty.BLOODPRESSUREHIGH)
        if diya > 0 && gaoya > 0 {
            var transData = [0x68, BlueToothFunctionIndexEnum.bloodPressure.rawValue, 0x03, 0x00, 0x05, gaoya, diya]
            let lData = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
        } else {
        }
        
    }
    
    /**
     *
     *  set  页面管理
     *
     */
    func setupPageManager(_ pageString: UInt32) {
        let b1 = pageString & 0xff
        let b2 = (pageString >> 8) & 0xff
        let b3 = (pageString >> 16) & 0xff
        let b4 = (pageString >> 24) & 0xff
        var transData = [0x68, UInt32(BlueToothFunctionIndexEnum.pageManager_None.rawValue), 0x05, 0x00, 0x01, b1, b2, b3, b4]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
        
        //    interfaceLog(@"page 333 APP ask %@",lData);
    }
    
    /**
     *
     *发送天气
     *
     */
    #warning("PZWeatherModel has not been created.")
    /*
    func sendWeather(_ weather: PZWeatherModel?) {
        
        //adaLog(@"       ========       发送天气");
        var isYes: Bool = sendWeatherFilter()
        if !isYes {
            return
        }
        if sendWeatherNum <= 0 {
            if weather {
                //时间
                var timeArray = AllTool.weatherDate(toArray: weather.weatherDate)
                //地点
                var cityData: Data? = weather.weather_city.data(using: .utf8)
                cityData = BleTool.checkLocaleLength(cityData)
                
                assert((cityData is Data), "是这个类型 = cityData weather")
                var cityDataLength: Int = cityData?.count ?? 0
                
                var hour: Int = 0
                if weather.realtimeShi.length > 2 {
                    hour = Int(truncating: weather.realtimeShi.substring(with: NSRange(location: 0, length: 2))) ?? 0
                } else {
                    hour = weather.realtimeShi
                }
                
                var contentByte1 = [0x00, 0x04, hour, Int(timeArray[0]), Int(timeArray[1]), Int(timeArray[2]) % 100, 0x01, (cityData?.count ?? 0)]
                var contentByte1Length: Int = ArraySize(contentByte1)
                var contentData1 = Data(bytes: &contentByte1, length: ArraySize(contentByte1)) //contentData1   为主要内容的容器
                
                if let data = cityData {
                    contentData1.append(data)
                }
                
                //天气内容
                var weatherContentData: Data? = weather.weatherContent.data(using: .utf8)
                weatherContentData = BleTool.checkWeatherContentLength(weatherContentData)
                var weatherContentDataLength: Int = weatherContentData?.count ?? 0
                //天气
                var contentByte2 = [0x02, 0x01, weather.weatherType, 0x03, (weatherContentData?.count ?? 0)]
                var contentByte2Length: Int = ArraySize(contentByte2)
                var contentData2 = Data(bytes: &contentByte2, length: ArraySize(contentByte2))
                if let data = weatherContentData {
                    contentData2.append(data)
                }
                
                contentData1.append(contentData2)
                
                //温度
                var contentByte3 = [0x04, 0x03, weather.tempArray[0], weather.tempArray[1], weather.tempArray[2], 0x05, 0x01, weather.weather_uv, 0x06, 0x01, weather.weather_fl, 0x07, 0x01, weather.weather_fx]
                
                var contentByte3Length: Int = ArraySize(contentByte3)
                var contentData3 = Data(bytes: &contentByte3, length: ArraySize(contentByte3))
                contentData1.append(contentData3)
                
                //aqi 有时有，有时没有
                var contentByte4Length: Int = 0
                var contentData4 = Data()
                var aqiNumber: Int = weather.weather_aqi
                var aqilength: Int = 1
                if aqiNumber == 1000 {
                    aqilength = 0
                    var contentByte4 = [0x08, aqilength]
                    contentByte4Length = ArraySize(contentByte4)
                    contentData4 = Data(bytes: &contentByte4, length: ArraySize(contentByte4))
                } else {
                    aqilength = 1
                    var contentByte5 = [0x08, aqilength, aqiNumber]
                    contentByte4Length = ArraySize(contentByte5)
                    contentData4 = Data(bytes: &contentByte5, length: ArraySize(contentByte5))
                }
                contentData1.append(contentData4)
                
                
                var length: Int = contentByte1Length + cityDataLength + contentByte2Length + weatherContentDataLength + contentByte3Length + contentByte4Length
                var headByte = [0x68, sendWeatherSuc_Enum, length, 0x00]
                var headData = Data(bytes: &headByte, length: ArraySize(headByte))
                headData.append(contentData1)
                
                
                var headUseData = headData.bytes as? Byte
                var checkNum = 0 as? uint
                for i in 0..<headData.count {
                    checkNum += headUseData?[i]
                }
                checkNum = Int(checkNum ?? 0) % 256
                var footData = [checkNum, 0x16]
                headData.append(&footData, length: ArraySize(footData))
                var weatherData = Data(base64Encoded: headData)
                //            adaLog(@"weatherData = %@",weatherData);
                sendWeatherNum += 1
                sendupdateData(weatherData)
                perform(#selector(self.delaySendWeather), with: nil, afterDelay: 2.0)
            }
        } else {
            adaLog("发送天气被拦截")
        }

    }
 
 
    /**
     *
     *发送未来几天天气
     *
     */
    func sendWeatherArray(_ weatherArr: [WeatherDays], day: Int, number: Int) {
        
        var _number: Int {
            if number > 3 {
                return 3
            } else {
                return number
            }
        }
        
        let length: Int = _number * 6 + 1
        //温度
        var headByte = [0x68, BlueToothFunctionIndexEnum.queryWeather.rawValue, length, 0x00, 0x02]
        //headByte   为主要内容的容器
        let headData = NSMutableData(bytes: &headByte, length: ArraySize(headByte))
        
        for i in 0..<number {
            let days = weatherArr[i]
            let ri = days.weatherDateArray[0]
            let yue = days.weatherDateArray[1]
            let year = days.weatherDateArray[2] % 100
            //[[days.weatherDateArray[2]  substringWithRange:NSMakeRange(2, 2)] integerValue];
            
            if let type = Int(days.weatherType), let max = Int(days.weatherMax), let min = Int(days.weatherMin) {
                var contentByte: [UInt8] = [UInt8(ri), UInt8(yue), UInt8(year) % 100, UInt8(type), UInt8(min), UInt8(max)]
                headData.append(&contentByte, length: ArraySize(contentByte))
            }
//            var type: Int = Int(days.weatherType)!
//            var max: Int = Int(days.weatherMax)!
//            var min: Int = Int(days.weatherMin)!
//            //协议改了。小的天气在前面
//            var contentByte = [ri, yue, year % 100, type, min, max] as? [UInt8]
//            //            NSMutableData *headData = [NSMutableData dataWithBytes:headByte length:ArraySize(headByte)];
            
        }
        var headUseData = [UInt8](Data(referencing: headData))
        var checkNum: UInt32 = 0
        for i in 0..<headData.length {
            checkNum += UInt32(headUseData[i])
        }
        checkNum = UInt32(Int(checkNum) % 256)
        var footData = [checkNum, 0x16]
        headData.append(&footData, length: ArraySize(footData))
        let daysData = Data(base64Encoded: Data(referencing: headData))
        #if DEBUG
        print("未来几天的数据 - daysData - daysData")
        #endif
        sendupdateData(daysData)

    }
 */
 
    /**
     *
     *发送某天天气   今天
     *
     */
    /*
    func sendOneDayWeather(_ weather: PZWeatherModel) {
    
        //以下是内容的拼接
        //时间
        var timeArray = ToolBox.weatherDate(toArray: weather.weatherDate)
        //地点
        var cityData: Data? = weather.weather_city.data(using: .utf8)
        cityData = BleTool.checkLocaleLength(cityData) //地点  最大24个字节  地点的长度不能太长
        var cityDataLength: Int = cityData?.count ?? 0
        
        var hour: Int = 0
        if weather.realtimeShi.length > 2 {
            hour = Int(truncating: weather.realtimeShi.substring(with: NSRange(location: 0, length: 2))) ?? 0
        } else {
            hour = weather.realtimeShi
        }
        
        var contentByte1 = [0x01, 0x00, 0x04, hour, Int(timeArray[0]), Int(timeArray[1]), Int(timeArray[2]) % 100, 0x01, (cityData?.count ?? 0)]
        var contentByte1Length: Int = ArraySize(contentByte1)
        var contentData1 = Data(bytes: &contentByte1, length: ArraySize(contentByte1)) //contentData1   为主要内容的容器
        
        
        if let data = cityData {
            contentData1.append(data)
        }
        
        //天气内容
        var weatherContentData: Data? = weather.weatherContent.data(using: .utf8)
        weatherContentData = BleTool.checkWeatherContentLength(weatherContentData) //天气内容  最大48个字节
        var weatherContentDataLength: Int = weatherContentData?.count ?? 0
        //天气
        var contentByte2 = [0x02, 0x01, weather.weatherType, 0x03, (weatherContentData?.count ?? 0)]
        var contentByte2Length: Int = ArraySize(contentByte2)
        var contentData2 = Data(bytes: &contentByte2, length: ArraySize(contentByte2))
        if let data = weatherContentData {
            contentData2.append(data)
        }
        
        contentData1.append(contentData2)
        
        //温度
        var contentByte3 = [0x04, 0x03, weather.tempArray[0], weather.tempArray[1], weather.tempArray[2], 0x05, 0x01, weather.weather_uv, 0x06, 0x01, weather.weather_fl, 0x07, 0x01, weather.weather_fx]
        var contentByte3Length: Int = ArraySize(contentByte3)
        var contentData3 = Data(bytes: &contentByte3, length: ArraySize(contentByte3))
        
        contentData1.append(contentData3)
        
        //aqi 有时有，有时没有  ,0x08,0x01,[weather.weather_aqi integerValue]
        var contentByte4Length: Int = 0
        var contentData4 = Data()
        var aqiNumber: Int = weather.weather_aqi
        var aqilength: Int = 1
        if aqiNumber == 1000 {
            aqilength = 0
            var contentByte4 = [0x08, aqilength]
            contentByte4Length = ArraySize(contentByte4)
            contentData4 = Data(bytes: &contentByte4, length: ArraySize(contentByte4))
        } else {
            aqilength = 1
            var contentByte5 = [0x08, aqilength, aqiNumber]
            contentByte4Length = ArraySize(contentByte5)
            contentData4 = Data(bytes: &contentByte5, length: ArraySize(contentByte5))
        }
        contentData1.append(contentData4)
        
        
        
        
        //总长度
        var length: Int = contentByte1Length + cityDataLength + contentByte2Length + weatherContentDataLength + contentByte3Length + contentByte4Length
        var headByte = [0x68, queryWeather_Enum, length, 0x00]
        var headData = Data(bytes: &headByte, length: ArraySize(headByte))
        headData.append(contentData1)
        
        
        var headUseData = headData.bytes as? Byte
        var checkNum = 0 as? uint
        for i in 0..<headData.count {
            checkNum += headUseData?[i]
        }
        checkNum = Int(checkNum ?? 0) % 256
        var footData = [checkNum, 0x16]
        headData.append(&footData, length: ArraySize(footData))
        var mouData = Data(base64Encoded: headData)
        adaLog("mouData = %@", mouData)
        sendupdateData(mouData)

    
    }
 */
    /**
     *
     *发送某天天气   某天   < 6
     *
     */
    func sendOneDayWeatherTwo(_ weather: WeatherDay?) {
    }
    
    // MARK:
    // MARK: OAD operate
    func revDataAck(with dataFunctionNum: Int, andDat data: Data) {
        var checkNum: Int = 0x68 + dataFunctionNum
        let dataByte = [UInt8](data)
        for index in 0..<data.count {
            checkNum += Int(dataByte[index])
        }
        checkNum += data.count
        checkNum = checkNum % 256
        var transData = [0x68, dataFunctionNum, data.count, 0x00]
        let lData = NSMutableData(bytes: &transData, length: ArraySize(transData))
            
        lData.append(data)
            
        var endData = [checkNum, 0x16]
        lData.append(&endData, length: ArraySize(endData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }

    
    
    func utf8(toUnicode string: String?) -> Data? {
        
        guard let string = string else {
            return nil
        }
        
        let length: Int = string.count
        var s = String(repeating: "\0", count: 0)
        
        for i in 0..<length {
            let cString = String(format: "%.4x", string[string.index(string.startIndex, offsetBy: i)].string)
            var mutString = String(repeating: "\0", count: 4)
            mutString += (cString as NSString).substring(with: NSRange(location: 2, length: 2))
            mutString += (cString as NSString).substring(with: NSRange(location: 0, length: 2))
            s += mutString
        }
        let unicodeData = stringToHexData(with: s)
        return unicodeData
    }
    
    //    把内容为16进制的字符串转换为数组
    func stringToHexData(with string: String) -> Data {
        
        var hex = string
        var data = Data()
        
        let len = hex.count / 2
        
        for _ in 0..<len {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        
        return data
    }

    
    /**
     *
     使用unicode编码，最大44个字节长度，相当于可有22个ascii或中文；如果提醒类型是1~5，则不用传递提醒语
     
     *   把内容为16进制的字符串转换为数组
     **/
    class func utf8(toUnicode string: String?) -> Data? {
        
        guard let string = string else {
            return nil
        }
        
        let length: Int = string.count
        var s = String(repeating: "\0", count: 0)
        
        for i in 0..<length {
            let cString = String(format: "%.4x", string[string.index(string.startIndex, offsetBy: i)].string)
            var mutString = String(repeating: "\0", count: 4)
            mutString += (cString as NSString).substring(with: NSRange(location: 2, length: 2))
            mutString += (cString as NSString).substring(with: NSRange(location: 0, length: 2))
            s += mutString
        }
        let unicodeData = stringToHexData(with: s)
        return unicodeData
    }
    
    
    class func stringToHexData(with string: String) -> Data {
        
        var hex = string
        var data = Data()
        
        let len = hex.count / 2
        
        for _ in 0..<len {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        
        return data
    }
    
    /**
     *
     *
     *
     */
    func getActualData() {
        var transData = [0x68, BlueToothFunctionIndexEnum.getActualData.rawValue, 0x01, 0x00, 0x00, 0x6f, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *读取页面管理
     *
     */
    @objc func checkPageManager() {
        
        if checkPageManagerNum <= 0 {
            var transData = [0x68, BlueToothFunctionIndexEnum.pageManager_None.rawValue, 0x01, 0x00, 0x02]
            let lData = NSData(bytes: &transData, length: ArraySize(transData))
            appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
            //    [self blueToothWhriteTransData:lData isNeedResponse:NO];
            //        //adaLog(@"sendPageManager - -%@",lData);
            //        interfaceLog(@"page  读取设备页面的配置 ask %@",lData);
            checkPageManagerNum += 1
            perform(#selector(self.checkPageManagerNumber), with: nil, afterDelay: 1.0)
        }

    }
    
    @objc func checkPageManagerNumber() {
        checkPageManagerNum -= 1
    }
    
    @objc func queryCustomAlarmNumber() {
        queryCustomAlarmNum -= 1
    }

    @objc func delaySendWeather() {
        sendWeatherNum -= 1
    }

    
    /**
     *
     *页面管理 -- 支持那些页面
     *
     */
    @objc func supportPageManager() {
        var transData = [0x68, BlueToothFunctionIndexEnum.pageManager_None.rawValue, 0x01, 0x00, 0x03]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
        
        //    //adaLog(@"supportPageManager - -%@",lData);
        //   interfaceLog(@"page  APP读取设备支持的页面配置 ask %@",lData);
    }
    
    /**
     *
     *
     *
     */
    func openAntiLoss() {
        
        var transData = [0x68, BlueToothFunctionIndexEnum.openAntiLoss.rawValue, 0x01, 0x00, 0x01, 0x6f, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)

    }
    
    /**
     *
     *
     *
     */
    func closeAntiLoss() {
        
        var transData = [0x68, BlueToothFunctionIndexEnum.openAntiLoss.rawValue, 0x01, 0x00, 0x00, 0x6e, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)

    }
    
    
    
    // MARK: -- 回复数据
    /**
     *
     *回复数据
     *
     */
    func revDataAck(with dataFunctionNum: Int) {
        var checkNum: Int = 0x68 + dataFunctionNum
        checkNum = checkNum % 256
        var transData = [0x68, dataFunctionNum, 0x00, 0x00, checkNum, 0x16]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        blueToothWhriteTransData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *回复数据
     *
     */
    func revDataAck(with dataFunctionNum: Int, andDat data: Data?) {
    }
    
    /**
     *
     *回复数据  -- 仅测试使用
     *
     */
    //- (void)returnDataWithFlag:(int)flag andDat:(NSData *)data;
    
    // MARK: -- 固件升级重发

    /**
     *
     * 更新  固件 数据
     *
     */
    func updateHardWaer(withPack index: Int) {
        
        guard isConnected, romURL.isEmpty == false else {
            return
        }
        
        guard var data = NSData(contentsOfFile: romURL) else {
            #if DEBUG
            print("\(#function)")
            print("Can't get data.")
            #endif
            return
        }
        
        var totalPack: Int = data.length / 200 + 1
        var length: Int = 200
        if index == totalPack {
            length = data.length % 200
        }
        
        let startIndex = (index - 1) * 200
        var romData = data.subdata(with: NSRange(location: (index - 1) * 200, length: length))
        
        var transDate = [0x68, BlueToothFunctionIndexEnum.updateHardWare.rawValue, (length + 5) & 0xff, (length + 5) >> 8 & 0xff, 0x01, totalPack & 0xff, totalPack >> 8 & 0xff, index & 0xff, index >> 8 & 0xff]
        
        var lData = NSMutableData(bytes: &transDate, length: ArraySize(transDate))
        lData.append(romData)
        
        var beginTansDate = [UInt8](Data(referencing: lData))
        
        var checkNum: UInt32 = 0
        for i in 0..<lData.length {
            checkNum += UInt32(beginTansDate[i])
        }
        checkNum = checkNum % 256
        var tempData = [checkNum, 0x16]
        lData.append(&tempData, length: ArraySize(tempData))
        
        if lData.length > 20 {
            var subData = lData.subdata(with: NSRange(location: 0, length: 20))
            var lostData = lData.subdata(with: NSRange(location: 20, length: lData.length - 20))
            //adaLog(@"update = %@",subData);
            if let cbPeripheral = cbPeripheral, let rdCharactic1 = rdCharactic1 {
                cbPeripheral.writeValue(subData, for: rdCharactic1, type: .withoutResponse)
            }
            
            perform(#selector(self.sendupdateData(_:)), with: lostData, afterDelay: 0)
        } else {
            if let cbPeripheral = cbPeripheral, let rdCharactic1 = rdCharactic1 {
                cbPeripheral.writeValue(Data(referencing: lData), for: rdCharactic1, type: .withoutResponse)
            }
        }
    }
    
    /**
     *
     * 更新  固件 完成
     *
     */
    func updatehardwaerComplete() {
        var transData = [0x68, BlueToothFunctionIndexEnum.updateHardWare.rawValue, 0x01, 0x00, 0x02]
        let data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
    }
    
    /**
     *
     * 回复手环
     *
     */
    @objc func phoneAlarmNotify() {
        

        //不知道为什么  申请配对
        //adaLog(@"申请配对");
        if canPaired {
            if cbPeripheral != nil, let _pairCharactic = PairCharactic {
                cbPeripheral?.setNotifyValue(false, for: _pairCharactic)
            }
            canPaired = false
            perform(#selector(self.changeCanPaire), with: nil, afterDelay: 1)
            //adaLog(@"发送配对");
        }

    }
    
    @objc func changeCanPaire() {
        canPaired = true
    }

    
    /**
     *
     *运动目标 。睡眠目标  睡眠时间
     *
     */
    func returnCompletionDegree() {
        #warning("TimeCallManager has not been created.")
//        var timeSeconds: Int = TimeCallManager.getInstance().getSecondsOfCurDay()
//        var dic = SQLdataManger.getInstance().getTotalData(with: timeSeconds)
//        var sleepPlan: Int = 0
//        var stepPlan: Int = 0
//        sleepPlan = Int(dic[Sleep_PlanTo_HCH])
//        stepPlan = Int(dic[Steps_PlanTo_HCH])
//        var sleepArr = AllTool.number(toArray: sleepPlan)
//        var stepArr = AllTool.number(toArray: stepPlan)
//        var length: Int = SleepTool.sleepLengthSeek()
//        //    int time = [dict[@"time"] intValue];
//        //    int min = [dict[@"min"] intValue];
//        //    length =  600;
//        var shi: Int = length / 60
//        var min: Int = length % 60
//
//        var transData = [0x68, 0x2d, 0x0b, 0x00, 0x01, Int(stepArr[0]), Int(stepArr[1]), Int(stepArr[2]), Int(stepArr[3]), Int(sleepArr[0]), Int(sleepArr[1]), Int(sleepArr[2]), Int(sleepArr[3]), min, shi]
//        var data = Data(bytes: &transData, length: ArraySize(transData))
//        appendingCheckNumData(data, isNeedResponse: true)
        //     interfaceLog(@"CompletionDegree  222   == APP - answer %@",data);
        //    adaLog(@"target ==  APP - answer %@",data);
        
    }
    
    /**
     *
     *回复手环
     *
     */
    func answerTakePhoto() {
        var transData: [UInt8] = [0x68, 0x0e, 0x00, 0x00]
        var data = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
        
    }
    
    /**
     *
     *回复手环
     *
     */
    func responseExceptionData() {
        var transData = [0x68, BlueToothFunctionIndexEnum.exceptioncodeData.rawValue, 0x02, 0x00, 0x01, 0x00]
        let lData = NSData(bytes: &transData, length: ArraySize(transData))
        appendingCheckNumData(Data(referencing: lData), isNeedResponse: false)
    }
    
    /**
     *
     *
     *开启定时器，定时请求天气
     */
    @objc func weatherRefresh() {
        
        //    [HCHCommonManager getInstance].queryWeatherID = 0;
        //    static dispatch_once_t onceToken;
        //    dispatch_once(&onceToken, ^{
        
        //    [HCHCommonManager getInstance].queryWeatherID = 0;
        //    static dispatch_once_t onceToken;
        //    dispatch_once(&onceToken, ^{
        
        #warning("PZCityTool 尚未建立")
//        PZCityTool.sharedInstance().refresh()
        
        if weatherTimer == nil {
            weatherTimer = Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(self.weatherRe(_:)), userInfo: nil, repeats: true)
        }
        
        //    });
    }
    
    // 开启定时器，定时请求天气
    
    @objc func weatherRe(_ timer: Timer?) {
        #warning("PZCityTool 尚未建立")
//        PZCityTool.sharedInstance().refresh()
    }
    
    
    
    // MARK:   - - 连接蓝牙刷新 的方法
    func coreBlueRefresh() {
        
        if coreBlueRefreshNum > 0 {
            return
        }
        coreBlueRefreshNum += 1
        
        let ud = UserDefaults.standard
        
        //支持  页面管理的默认值 页面配置
        ud.set("4294967295", forKey: GlobalProperty.SUPPORTPAGEMANAGER)
        //显示  页面管理的默认值 页面配置
        ud.set("4294967295", forKey: GlobalProperty.SHOWPAGEMANAGER)
        //支持信息提醒的默认值
        ud.set("1", forKey: GlobalProperty.SUPPORTINFORMATION)
        
        ud.set("0", forKey: GlobalProperty.COMPLETIONDEGREESUPPORT)
        //是否支持天气 0不支持 1支持
        ud.set("0", forKey: GlobalProperty.WEATHERSUPPORT)
        
        ud.set("22", forKey: GlobalProperty.CUSTOMREMINDLENGTH)
        
        
        //[ (MAX(L(send),L(receive))/20) * P + 100 + random(0,100)] ms   (arc4random()%100)   40 改成 50 改成60
        var delayTime: CGFloat = 0
        perform(#selector(self.notigyCharactic), with: nil, afterDelay: 0.06)
        perform(#selector(self.phoneAlarmNotify), with: nil, afterDelay: 0.8) //配对
        perform(#selector(self.synsCurTime), with: nil, afterDelay: 0.2) //同步时间Max(10,6/20)*40+100+random(0,100)
        delayTime = 800 / 1000.0 //(600/1000.)
        perform(#selector(self.setLanguage), with: nil, afterDelay: TimeInterval(delayTime)) //语言刷新Max(8,8/20)*40+100+random(0,100)
        delayTime += 700 / 1000.0 //(520/1000.)
        perform(#selector(self.checkPower), with: nil, afterDelay: TimeInterval(delayTime)) //检查电量Max(6,7/20)*40+100+random(0,100)
        delayTime += CGFloat((460 + Int(arc4random()) % 100)) / 1000.0 //((340+arc4random()%100)/1000.)
        perform(#selector(self.supportPageManager), with: nil, afterDelay: TimeInterval(delayTime)) //APP查询设备能支持的参数  Max(7,11/20)*40+100+random(0,100)
        delayTime += CGFloat((520 + Int(arc4random()) % 100)) / 1000.0 //((380+arc4random()%100)/1000.)
        perform(#selector(self.checkPageManager), with: nil, afterDelay: TimeInterval(delayTime)) //先发送一次页面管理，没有回复就是不支持Max(7,8/20)*40+100+random(0,100)
        delayTime += CGFloat((520 + Int(arc4random()) % 100)) / 1000.0 //((380+arc4random()%100)/1000.)
        perform(#selector(self.checkInformation), with: nil, afterDelay: TimeInterval(delayTime)) //先发送一次信息提醒查询，没有回复就是不支持 Max(6,8/20)*40+100+random(0,100)
        delayTime += CGFloat((460 + Int(arc4random()) % 100)) / 1000.0 //((340+arc4random()%100)/1000.)
        
        perform(#selector(self.sendBraMMDDformat), with: nil, afterDelay: TimeInterval(delayTime)) //发送手环的显示日期的格式 日月
        delayTime += CGFloat((640 + Int(arc4random()) % 100)) / 1000.0
        perform(#selector(self.getCurDayTotalData), with: nil, afterDelay: TimeInterval(delayTime)) //当天总数据Max(10,38/20)*40+100+random(0,100)
        delayTime += CGFloat((700 + Int(arc4random()) % 100)) / 1000.0 //((500+arc4random()%100)/1000.)
        perform(#selector(self.setBindDateMa), with: nil, afterDelay: TimeInterval(delayTime)) //绑定数据 —— 设置计步参数 (四个内容)Max(8,10/20)*40+100+random(0,100)
        delayTime += 700 / 1000.0 //(520/1000.)
        perform(#selector(self.setBindDateStateWithState), with: nil, afterDelay: TimeInterval(delayTime)) //绑定数据
        delayTime += 700 / 1000.0 //(520/1000.)
        perform(#selector(self.sendUserInfoToBind), with: nil, afterDelay: TimeInterval(delayTime)) //设置计步参数，功能码：0x04 Max(10,6/20)*40+100+random(0,100)
        delayTime += 800 / 1000.0 //(600/1000.)
        
        perform(#selector(self.checkAction), with: nil, afterDelay: TimeInterval(delayTime)) //查询设备是否支持某功能Max(10,11/20)*40+100+random(0,100)
        delayTime += CGFloat((700 + Int(arc4random()) % 100)) / 1000.0 //((500+arc4random()%100)/1000.)
        perform(#selector(self.queryHeartAlarm), with: nil, afterDelay: TimeInterval(delayTime)) //查询心率预警区间Max(7,10/20)*40+100+random(0,100)
        delayTime += CGFloat((520 + Int(arc4random()) % 100)) / 1000.0 //((380+arc4random()%100)/1000.)
        perform(#selector(self.checkParameter), with: nil, afterDelay: TimeInterval(delayTime)) //APP查询设备能支持的参数 Max(9,11/20)*40+100+random(0,100)
        delayTime += CGFloat((640 + Int(arc4random()) % 100)) / 1000.0 //((460+arc4random()%100)/1000.)
        
        //以下是全天数据
        perform(#selector(self.getCurDayTotalDataWith(type:)), with: 1, afterDelay: TimeInterval(delayTime)) //查询每小时数据 Max(10,202/20)*40+100+random(0,100)
        delayTime += 706 / 1000.0 //(504/1000.)
        perform(#selector(self.getPilaoData), with: nil, afterDelay: TimeInterval(delayTime)) //疲劳 Max(10,202/20)*40+100+random(0,100)
        delayTime += 800 / 1000 //(600/1000)
        perform(#selector(self.queryPhoneNotice), with: nil, afterDelay: TimeInterval(delayTime)) //读取防丢提醒 Max(8,8/20)*40+100+random(0,100)
        delayTime += 700 / 1000 //(520/1000)
        perform(#selector(self.querySMSNotice), with: nil, afterDelay: TimeInterval(delayTime)) //
        delayTime += 700 / 1000
        
        let str = ud.string(forKey: GlobalProperty.kLastDeviceNAME)

        perform(#selector(self.getCurDayTotalDataWith(type:)), with: 2, afterDelay: TimeInterval(delayTime)) //查询睡眠数据 Max(10,46/20)*40+100+random(0,100)
        //adaLog(@"str = %@",str);//@"B7"
        delayTime += 800 / 1000
        
        
        if let _str = str, .orderedSame == str?.compare("B7", options: .caseInsensitive, range: Range(NSRange(location: 0, length: 2), in: _str), locale: .current) {
            perform(#selector(self.weatherRefresh), with: nil, afterDelay: TimeInterval(delayTime)) //天气刷新 Max(50,8/20)*40+100+random(0,100)
            delayTime += 1
            perform(#selector(self.setupCorrectNumber), with: nil, afterDelay: TimeInterval(delayTime)) //设置校正值
            delayTime += 800 / 1000
        }
        perform(#selector(self.getCurDayTotalHeartData), with: nil, afterDelay: TimeInterval(delayTime)) //当天心率总数。8个包Max(12,1452/20)*40+100+random(0,100)   == 8个包 24.832
        
        perform(#selector(self.openHeartRate), with: nil, afterDelay: 5)
        
        perform(#selector(self.coreBlueRefreshDelay), with: nil, afterDelay: 2) //保证两秒内不能进入这里

        
    }
    
    
    @objc func notigyCharactic() {
        if (notifyCharactic != nil) && (cbPeripheral != nil), let _notifyCharactic = notifyCharactic {
            cbPeripheral?.setNotifyValue(true, for: _notifyCharactic)
        }
    }

    
    
    @objc func connectOutTime() {
        isConnecting = false
    }

    
    @objc func setBindDateMa() {
//        let unitState = kState
        #warning("CositeaBlueTooth 還未建立")
//        CositeaBlueTooth.instance.setUnitStateWithState(unitState == 2)
        //    [self sendUserInfoToBind];
    }

    
    @objc func sendUserInfoToBind() {
        
//        guard let dic = UserDefaults.standard.dictionary(forKey: "loginCache") else { return }
        
        //    adaLog(@"身高体重 = %@",dic);
        
//        let height = dic["height"] as? Int ?? 0
//        let weight = dic["weight"] as? Int ?? 0
//        let male = dic["gender"] as? Int ?? 0
//        var age: Int = 25
//        let formates = DateFormatter()
//        formates.dateFormat = "yyyy-MM-dd"
//        let assignDate: Date? = formates.date(from: dic["birthdate"] as? String ?? "")
//        let time = Int(fabs(Float(assignDate?.timeIntervalSinceNow ?? 0.0)))
//        age = Int(trunc(Double(time / (60 * 60 * 24))) / 365)
        
        #warning("CositeaBlueTooth 還未建立")
//        CositeaBlueTooth.sharedInstance().sendUserInfoToBind(withHeight: height, weight: weight, male: male - 1, age: age)
    }

    
    @objc func queryPhoneNotice() {
        querySystemAlarm(with: 3)
    }
    
    @objc func querySMSNotice() {
        querySystemAlarm(with: 2)
    }
    
    func checkRcieveDataNextHead() {
        
        if reviceData?.length == 0 || reviceData == nil {
            return
        }
        var headTransDat: [UInt8] = [0x68]
        let headData = NSData(bytes: &headTransDat, length: ArraySize(headTransDat))
        
        if let length = reviceData?.length, let range = reviceData?.range(of: Data(referencing: headData), options: .backwards, in: NSRange(location: 0, length: length)) {
            
            
            
            if Int(range.location) != NSNotFound {
                reviceData?.replaceBytes(in: NSRange(location: 0, length: Int(range.location)), withBytes: nil, length: 0)
                recieveDataUpdate()
            } else {
                reviceData = nil
                reviceData = NSMutableData()
            }
        }
    }
    
    func recieveDataUpdate() {
        
        //adaLog(@"reviceData   ==  %@",reviceData);
        
        if reviceData != nil {
            
            while reviceData!.length >= 6 {
                
                let tempData = [UInt8](Data(referencing: reviceData!))
                
                if let item = tempData.first, item != 0x68 {
                    //adaLog(@"??????????  重新读取第二个头");
                    checkRcieveDataNextHead()
                    return
                }
                let len = Int(tempData[2]) | (Int(tempData[3]) << 8) //第二个数字
                if let _length = reviceData?.length, _length >= len + 6 {
                    
                    let end = Int(tempData[len + 5])
                    var checkNum: UInt8 = 0
                    for i in 0..<len + 4 {
                        checkNum += tempData[i]
                    }
                    checkNum = checkNum % UInt8(256)
                    if end == 0x16 && checkNum == tempData[len + 4] {
                        let toSendData = reviceData!.subdata(with: NSRange(location: 0, length: len + 6))
                        reviceData!.replaceBytes(in: NSRange(location: 0, length: len + 6), withBytes: nil, length: 0)
                        //adaLog(@"recieveData == %@",toSendData);
                        if delegate != nil {
                            if delegate!.responds(to: #selector(self.delegate?.blueToothManagerReceiveNotify(_:))) {
                                delegate?.blueToothManagerReceiveNotify?(toSendData)
                                
                                let recieveByte = [UInt8](toSendData)
                                let recieveCode = recieveByte[1] & 0x7f
                                
                                if sendingData != nil, sendingData?.count != 0 {
                                    let sendingByte = [UInt8](sendingData!)
                                    let sendCode = sendingByte[1]
                                    if sendCode == recieveCode || recieveCode == 73 {
                                        sendingData = nil
                                    }
                                }
                                blueToothWhriteTransData(nil, isNeedResponse: true)
                            }
                        }
                    } else {
                        reviceData?.replaceBytes(in: NSRange(location: 0, length: 1), withBytes: nil, length: 0)
                        checkRcieveDataNextHead()
                    }
                } else {
                    break
                }
            }
        }
    }



    @objc func coreBlueRefreshDelay() {
        coreBlueRefreshNum -= 1
    }
    
    func setLanguageByte(_ state: Int) {
        var transData = [0x68, 0x02, 0x03, 0x00, 0x01, 0x06, state]
        let data = NSData(bytes: &transData, length: ArraySize(transData))

        //    interfaceLog(@"Language 1111 == %@",data);
        appendingCheckNumData(Data(referencing: data), isNeedResponse: false)
    }

    func appendingCheckNumData(_ data: Data, isNeedResponse response: Bool) {
        let transData = [UInt8](data)
        var checkNum: UInt8 = 0
        for i in 0..<data.count {
            checkNum += transData[i]
        }
        checkNum = checkNum % UInt8(256)
        var tempData = [checkNum, 0x16]
        var lData: Data? = nil
        lData = Data(base64Encoded: data)
        lData?.append(&tempData, count: ArraySize(tempData))
        blueToothWhriteTransData(lData, isNeedResponse: response)
    }
    
    // MARK:    - -- - - - - -  蓝牙的重发机制
    func blueToothWhriteTransData(_ lData: Data?, isNeedResponse response: Bool) {
        if cbCenterManger == nil, cbPeripheral == nil, cbCenterManger?.state != .poweredOn {
            return
        }
        if rdCharactic1 != nil {
            
            if lData != nil && (lData?.count ?? 0) != 0 {
                //            adaLog(@"self.dataArray = %@",self.dataArray);
                if response {
                    if let data = lData {
                        dataArray.append(data)
                    }
                } else if dataArray.count != 0 {
                    if let data = lData {
                        dataArray.insert(data, at: 0)
                    }
                } else {
                    //                adaLog(@"shotSendData  - -- %@",lData);
                    if let data = lData, rdCharactic1 != nil {
                        cbPeripheral?.writeValue(data, for: rdCharactic1!, type: .withoutResponse)
                    }
                    return
                }
            }
            if dataArray.count != 0, sendingData == nil {
                let data = dataArray[0]
                //                adaLog(@"longSendData = %@",data);
                if rdCharactic1 != nil {
                    cbPeripheral?.writeValue(data, for: rdCharactic1!, type: .withoutResponse)
                }
                sendingData = data
                
                #warning("BLETool 尚未建立")
//                let outimeInterver = BleTool.countSendtimeOut(with: (data?.count ?? 0), andReceive: 10.0)
                
                //410 + arc4random()%75+24;
                
//                perform(#selector(self.resendSendingData(_:)), with: data, afterDelay: TimeInterval(outimeInterver))
                
                dataArray.remove(at: 0)
            }
        }
    }

    @objc func resendSending(_ data: Data?) {
        
        if cbCenterManger != nil, cbCenterManger?.state != .poweredOn {
            return
        }
        
        if resendCount >= 2 {
            resendCount = 0
            sendingData = nil
            blueToothWhriteTransData(nil, isNeedResponse: true)
        }
        if data == sendingData {
            if notifyCharactic != nil, cbPeripheral != nil {
                cbPeripheral?.setNotifyValue(true, for: notifyCharactic!)
            }
            if rdCharactic1 != nil {
                
                #if DEBUG
                print("resendData ===== \n\(String(describing: data))")
                #endif
                
                if let aData = data {
                    cbPeripheral?.writeValue(aData, for: rdCharactic1!, type: .withoutResponse)
                }
                resendCount += 1
                
                #warning("BLETool 尚未建立")
//                let outimeInterver = BleTool.countSendtimeOut(with: (data?.count ?? 0), andReceive: 10.0)
//                perform(#selector(self.resendSending(_:)), with: data, afterDelay: TimeInterval(outimeInterver))
            }
        }
    }


    

    func updateLog(_ s: CBManagerState) {
        //adaLog(@"s--蓝牙状态--%ld",s);
        if delegate != nil, delegate?.responds(to: #selector(self.delegate?.callbackCBCentralManagerState(_:))) ?? false {
            self.delegate?.callbackCBCentralManagerState?(s)
        }
    }
    
    func delayCallback() {
        
        if delegate != nil {
            if delegate!.responds(to: #selector(self.delegate?.callbackConnectTimeAlert(_:))) {
                delegate?.callbackConnectTimeAlert?(isSeek)
            }
        }
    }

    
    
    @objc func timeFired(_ timer: Timer?) {
        
        guard cbCenterManger?.state == .poweredOn else {
            return
        }
        
        if connectUUID?.isEmpty == true, let uuid = connectUUID, GlobalProperty.currentWorkMode == 0, isConnecting == false {
            connect(withUUID: uuid)
        }
        
        if UserDefaults.standard.object(forKey: GlobalProperty.kLastDeviceUUID) == nil {
            return
        }
        
        if HCHCommonManager.instance.conState {
            connectTime = 0
        } else {
            connectTime += 1
        }
        
        if connectTime > 200 {
            connectTime = 21
        }
        
        // 不可用
        UserDefaults.standard.set("1", forKey: GlobalProperty.CALLBACKFORTY)
        
        if connectTime > 20 {
            
             //可用
            UserDefaults.standard.set("2", forKey: GlobalProperty.CALLBACKFORTY)
            
            delayCallback()
            //创建一个消息对象
            let notice = Notification(name: NSNotification.Name("ConnectTimeout"), object: nil, userInfo: nil)
            //发送消息
            NotificationCenter.default.post(notice)
            
            //[self performSelector:@selector(delayCallback) withObject:nil afterDelay:1.f];
        }
        ////adaLog(@"定时连接");
    }
    
    func getHexString(withValue values: Int) -> String? {
        var newHexStr = String(format: "%x", values & 0xff)
        if newHexStr.count == 1 {
            newHexStr = "0\(newHexStr)"
        } else {
            newHexStr = "\(newHexStr)"
        }
        
        newHexStr = "0x\(newHexStr)"
        
        return newHexStr
    }

    
    func getIOS6UUID(_ string: String) -> String {
        
        var string = string
        let rangess: NSRange? = (string as NSString?)?.range(of: "<", options: NSString.CompareOptions(rawValue: 1))
        let tRangess: NSRange? = (string as NSString?)?.range(of: ">", options: NSString.CompareOptions(rawValue: 1))
        if Int(rangess?.location ?? 0) != NSNotFound {
            string = (string as NSString).substring(with: NSRange(location: Int(rangess?.location ?? 0) + 1, length: Int((tRangess?.location ?? 0) - (rangess?.location ?? 0)) - 1))
            string = string.uppercased()
        }
        
        return string
    }
    



    @objc func getcurdata() {
        getActualData()
        perform(#selector(self.getcurdata), with: nil, afterDelay: 5.0)
    }


    // MARK:   ---   定时请求全天的心率
    func timingHeartRate() {
        if hearRateTime != nil {
            hearRateTime?.invalidate()
            hearRateTime = nil
        }
        hearRateTime = Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(self.timingQuerycurdayHeartRate), userInfo: nil, repeats: true)
    }
    
    //定时请求全天的心率   、、一小时一次
    @objc func timingQuerycurdayHeartRate() {
        if HCHCommonManager.instance.queryHearRateSeconed != 0 {
            getNewestCurDayTotalHeartData()
        } else {
            getCurDayTotalHeartData()
        }
    }
    
    
    func setBindDateStateWithS() {
        
//        let formatStringForHours = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
//        let containsA: NSRange? = (formatStringForHours as NSString?)?.range(of: "a")
//        let hasAMPM: Bool = Int(containsA?.location ?? 0) != NSNotFound
        
        #warning("CositeaBlueTooth has not been created.")
//        CositeaBlueTooth.sharedInstance().setBindDateStateWithState(!hasAMPM) //app设置手环的时间是12小时制或24小时制
        
    }
    
    func sendWeatherFilter() -> Bool {
        var isCan = false
        
        let str = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceNAME)
        //adaLog(@"strB7 = %@",str);//@"B7"
        if .orderedSame == str?.compare("B7", options: .caseInsensitive, range: Range(NSRange(location: 0, length: 2), in: str ?? ""), locale: .current) {
            isCan = true
        }
        if UserDefaults.standard.integer(forKey: GlobalProperty.WEATHERSUPPORT) == 1 {
            isCan = true
        }
        return isCan
    }


    
    
    @objc func sendupdateData(_ lData: Data?) {
        
        guard let cbCenterManger = cbCenterManger,
            let cbPeripheral = cbPeripheral,
            cbCenterManger.state != .poweredOn,
            isConnected == false,
            let rdCharactic1 = rdCharactic1,
            let lData = lData else {
                return
        }
        
        if lData.count > 20 {
            let subData = lData.subdata(in: 0..<20)
            let lostData = lData.subdata(in: 20..<lData.count)
            
            #if DEBUG
            print("lData = \(lData)")
            print("subData = \(subData)")
            #endif
            
            cbPeripheral.writeValue(subData, for: rdCharactic1, type: .withoutResponse)
            
            perform(#selector(self.sendupdateData(_:)), with: lostData, afterDelay: 0)
            
        } else {
            //adaLog(@"update = %@",lData);
            cbPeripheral.writeValue(lData, for: rdCharactic1, type: .withoutResponse)
        }
    }

    
}


extension BlueToothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        HCHCommonManager.instance.blueToothState = central.state
        
        switch central.state {
            
        case .poweredOff:
            updateLog(.poweredOff)
            isConnected = false
            sendingData = nil
            dataArray.removeAll()
            isSeek = 0
            connectTime = 0
            UserDefaults.standard.set("0", forKey: GlobalProperty.SEARCHDEVICEISSEEK)
            deviceName = nil
            
            if delegate != nil {
                if delegate!.responds(to: #selector(self.delegate?.blueToothManagerIsConnected(_:connect:))) {
                    delegate?.blueToothManagerIsConnected?(false, connect: nil)
                }
            }
            
        case .poweredOn:
            updateLog(.poweredOn)
            if myTimer == nil, GlobalProperty.currentWorkMode == 0 {
                myTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timeFired(_:)), userInfo: nil, repeats: true)
            }
            connectTime = 0
            
        case .resetting:
            updateLog(.resetting)
        
        case .unauthorized:
            updateLog(.unauthorized)
        
        case .unknown:
            updateLog(.unknown)
        
        case .unsupported:
            updateLog(.unsupported)

        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let llString = peripheral.identifier.uuidString
        
        if connectUUID == nil {
            return
        } else if (connectUUID == llString) && !isConnecting {
            cbPeripheral = peripheral
            cbCenterManger?.connect(cbPeripheral!, options: nil)
            isConnecting = true
            isSeek = 2
            
            //找到了
            UserDefaults.standard.set("2", forKey: GlobalProperty.SEARCHDEVICEISSEEK)
            
            perform(#selector(self.connectOutTime), with: nil, afterDelay: 5.0)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.connectOutTime), object: nil)
        cbPeripheral = peripheral
        //停止扫描
        cbCenterManger?.stopScan()
        deviceName = peripheral.name
        
        let llString = peripheral.identifier.uuidString
        
        connectUUID = llString
        
        //发现services
        //设置peripheral的delegate未self非常重要，否则，didDiscoverServices无法回调
        cbPeripheral?.delegate = self
        cbPeripheral?.discoverServices(nil)
        
        // 不可用
        UserDefaults.standard.set(GlobalProperty.CALLBACKFORTY, forKey: "1")
        
        if let isValid = myTimer?.isValid, isValid {
            myTimer?.invalidate()
            myTimer = nil
        }
        
        isConnected = true
        HCHCommonManager.instance.conState = true
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        rdCharactic1 = nil
        heartRateNotifyCharactic = nil
        notifyCharactic = nil
        cbPeripheral = nil
        
        if isConnected {
            
            if delegate != nil {
                if delegate!.responds(to: #selector(self.delegate?.blueToothManagerIsConnected(_:connect:))) {
                    delegate?.blueToothManagerIsConnected?(false, connect: nil)
                }
            }
        }
        
        isConnected = false
        HCHCommonManager.instance.conState = false
        isSeek = 1
        // 没有找到
        UserDefaults.standard.set("1", forKey: GlobalProperty.SEARCHDEVICEISSEEK)
        dataArray.removeAll()
        sendingData = nil
        
        isPersonOper = false
        
        if let length = reviceData?.length {
            reviceData?.replaceBytes(in: NSRange(location: 0, length: length), withBytes: nil, length: 0)
        }
        
        if myTimer == nil, !isPersonOper {
            myTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timeFired(_:)), userInfo: nil, repeats: true)
        }
        //创建一个消息对象
        let notice = Notification(name: NSNotification.Name("didDisconnectDevice"), object: nil, userInfo: nil)
        //发送消息
        NotificationCenter.default.post(notice)
        
        connectTime = 0

    }
    
    
    func checkRevDataValidity(with recData: Data) -> Bool {
        
        var result = true
        var checkNum: Int = 0
        let datCount: Int = recData.count
        let dat = [UInt8](recData)
        for index in 0..<datCount - 2 {
            checkNum += Int(dat[index])
        }
        if checkNum % 256 != Int(dat[datCount - 2]) {
            result = false
        }
        
        return result
    }
    
    



}


extension BlueToothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let array = peripheral.services {
            for service: CBService in array {
                var string = "\(service.uuid)"
                string = getIOS6UUID(string)
                
                //        NSLog(@"%d",service.length);
                if (string == Service_UUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
                //远程升级uuid
                if (string == OAD_Service_UUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
                
                if (string == HeartRate_Service_UUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
        
        //adaLog(@"device connect");
        isConnected = true
        sendingData = nil

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            
            for char in characteristics {
                
                var string: String = "\(char.uuid)"
                
                string = getIOS6UUID(string)
                if (string == Notiify_Charatic) {
                    cbPeripheral?.setNotifyValue(true, for: char)
                    #if DEBUG
                    print("使能數據")
                    #endif
                    notifyCharactic = char
                } else if string == Charatic_UDID1 {
                    rdCharactic1 = char
                } else if string == HeartRate_Notify_Charatic {
                    heartRateNotifyCharactic = char
                } else if string == BodySensor_Charatic {
                    //  @"2A38"    消息提醒的特征。。不使能，就是使能
                    PairCharactic = char
                }
            }
        }
        
        var string = "\(service.uuid)"
        string = getIOS6UUID(string)
        if (string == Service_UUID) {
            
            if let _notifyCharactic = notifyCharactic {
                cbPeripheral?.setNotifyValue(true, for: _notifyCharactic)
            }
            
            if delegate != nil {
                if delegate!.responds(to: #selector(self.delegate?.blueToothManagerIsConnected(_:connect:))) {
                    delegate?.blueToothManagerIsConnected?(true, connect: peripheral)
                }
            }
        }
        
        coreBlueRefresh()
        
        #if DEBUG
        print("出現特徵")
        #endif
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        //adaLog(@"[characteristic value] == %@",[characteristic value]);
        
        var string = "\(characteristic.uuid)"
        string = getIOS6UUID(string)
        if (string == Notiify_Charatic) {
            let notifyData: Data? = characteristic.value
            if let data = notifyData {
                reviceData?.append(data)
            }
            recieveDataUpdate()
        } else if (string == HeartRate_Notify_Charatic) {
            let notifyData: Data? = characteristic.value
            if delegate != nil {
                if delegate!.responds(to: #selector(self.delegate!.blueToothManagerReceiveHeartRateNotify(_:))) {
                    delegate?.blueToothManagerReceiveHeartRateNotify?(notifyData)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        var string = "\(characteristic.uuid)"
        string = getIOS6UUID(string)
        
        #if DEBUG
        print("已经更新的数据\nperipheral = \(peripheral)\ncharacteristic = \(characteristic)\nerror = \(String(describing: error))")
        #endif
        
        if sendData != nil, let count = sendData?.count, string == Charatic_UDID1 {
            if count > 20 {

                if let range: Range<Data.Index> = Range(NSRange(location: 0, length: 20)), let data = sendData?.subdata(in: range), rdCharactic1 != nil {
                    cbPeripheral?.writeValue(data, for: rdCharactic1!, type: .withoutResponse)
                }
//                cbPeripheral?.writeValue(, for: rdCharactic1!, type: .withoutResponse)
                
                
                if let range: Range<Data.Index> = Range(NSRange(location: 20, length: count - 20)) {
                    sendData = sendData?.subdata(in: range)
                }
                
            } else if sendData!.count > 0, let range = Range<Data.Index>(NSRange(location: 0, length: count)), let rangeZero = Range<Data.Index>(NSRange(location: 0, length: 0)) {
                if let data = sendData?.subdata(in: range), rdCharactic1 != nil {
                    cbPeripheral?.writeValue(data, for: rdCharactic1!, type: .withoutResponse)
                }
                
                sendData = sendData?.subdata(in: rangeZero)
            } else {
                sendData = nil
            }
        }

    }
}
