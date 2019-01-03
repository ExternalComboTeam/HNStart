//
//  CositeaBluetoothManager.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import CoreBluetooth

enum SystemAlarmType : Int {
    case Antiloss = 1 //   防丢提醒
    case SMS = 2 //   短信提醒
    case Phone = 3 //   来电提醒
    case Taiwan = 6 //   抬腕唤醒
    case Fanwan = 7 //   翻腕切屏
    case WeChat = 9 //   微信消息提醒
    case QQ = 10 //   QQ消息提醒
    case Facebook = 11 //   Facebook提醒
    case Skype = 12 //   Skype提醒
    case Twitter = 13 //   Twitter提醒
    case WhatsAPP = 14 //   WhatsAPP提醒
    case Line = 16 //   Line提醒
}

//定义block 入参整数
typealias intBlock = (Int) -> Void
//定义block 入参double
typealias doubleBlock = (Double) -> Void
//定义block 入参uint
typealias uintBlock = (UInt32) -> Void
//定义block 入参NSArray
typealias arrayBlock = ([Any]?) -> Void
//定义block 入参BOOL ，CBPeripheral
typealias connectStateChanged = (Bool, CBPeripheral?) -> Void
//定义block 入参NSDictionary
typealias dicBlock = ([AnyHashable : Any]?) -> Void
//定义block 入参DayOverViewDataModel
typealias allDayModelBlock = (DayOverViewDataModel?) -> Void
//定义block 入参SportModelMap
typealias offLineDataModel = (SportModelMap?) -> Void
//定义block 入参NSArray，NSArray，int
typealias doubleArrayBlock = ([Any]?, [Any]?, Int) -> Void
//定义block 入参NSArray，NSArray，int
typealias doubleIntArrayBlock = (Int, Int, [Any]?) -> Void
//定义block 入参NSArray，NSArray，int
typealias sleepModelBlock = (SleepModel?) -> Void
//定义block 入参 int，NSArray
typealias intArrayBlock = (Int, [Int]?) -> Void
//定义block 入参 int，int，int，int
typealias versionBlock = (Int, Int, Int, Int) -> Void
//定义block 入参 CustomAlarmModel
typealias alarmModelBlock = (CustomAlarmModel?) -> Void
//定义block 入参 int，int
typealias doubleInt = (Int, Int) -> Void
//定义block 入参 int，int，int
typealias heartRateAlarmBlock = (Int, Int, Int) -> Void
//定义block 入参 float
typealias floatBlock = (Float) -> Void
//定义block 入参 CBCentralManagerState
typealias bluetoothState = (CBManagerState) -> Void
//定义block 入参 NSString
typealias pageManager = (String?) -> Void
//@protocol CositeaBlueToothManagerDelegate <NSObject>
//@end
// MARK: -- ada
//定义block 入参 BOOL
typealias startSportBlock = (Bool) -> Void
//定义block 入参 SportModelMap
typealias timerGetHeartRate = (SportModelMap?) -> Void
//定义block 入参 BloodPressureModel
typealias bloodPressure = (BloodPressureModel?) -> Void

class CositeaBlueToothManager: NSObject, BlueToothManagerDelegate, BluetoothScanDelegate {
    


    private var packNumber: Int = 0
    
    
// MARK: -- 全局变量
    /*扫描类 */
    var blueToothScan: BluetoothScan?
    /*管理类 */
    var blueToothManager: BlueToothManager?
    // MARK: -- blocks
    /*intBlock的传递 */
    var powerBlock: intBlock?
    /*arrayBlock的传递 */
    var deviceArrayBlock: arrayBlock?
    /*allDayModelBlock的传递 */
    var dayTotalDataBlock: allDayModelBlock?
    /*connectStateChanged的传递 */
    var connectStateBlock: connectStateChanged?
    /*intBlock的传递 */
    var heartRateBlock: intBlock?
    /*offLineDataModel的传递 */
    var offLineDataModelBlock: offLineDataModel?
    /*allDayModelBlock的传递 */
    var historyAlldayModelBlock: allDayModelBlock?
    /*doubleArrayBlock的传递 */
    var dayHourDataBlock: doubleArrayBlock?
    /*doubleArrayBlock的传递 */
    var historyHourDataBlock: doubleArrayBlock?
    /*doubleIntArrayBlock的传递 */
    var heartRateArrayBlock: doubleIntArrayBlock?
    /*doubleIntArrayBlock的传递 */
    var historyHeartRateArrayBlock: doubleIntArrayBlock?
    /*sleepModelBlock的传递 */
    var sleepStateArrayBlock: sleepModelBlock?
    /*sleepModelBlock的传递 */
    var historySleepStateArrayBlock: sleepModelBlock?
    /*intArrayBlock的传递 */
    var hrvDataBlock: intArrayBlock?
    /*intArrayBlock的传递 */
    var historyHRVDataBlock: intArrayBlock?
    /*intBlock的传递 */
    var openFindBindBlock: intBlock?
    /*intBlock的传递 */
    var closeFindBindBlock: intBlock?
    /*intBlock的传递 */
    var resetBindBlock: intBlock?
    /*versionBlock的传递 */
    var versionBlock: versionBlock?
    /*alarmModelBlock的传递 */
    var alarmModelBlock: alarmModelBlock?
    /*doubleInt的传递 */
    var systemAlarmBlock: doubleInt?
    /*intBlock的传递 */
    var phoneDelayBlock: intBlock?
    /*arrayBlock的传递 */
    var sedentaryArrayBlock: arrayBlock?
    /*doubleInt的传递 */
    var heartRateMonitorBlock: doubleInt?
    /*heartRateAlarmBlock的传递 */
    var heartRateAlarmBlock: heartRateAlarmBlock?
    /*floatBlock的传递 */
    var progressBlock: floatBlock?
    /*intBlock的传递 */
    var updateSuccessBlock: intBlock?
    /*intBlock的传递 */
    var updateFailureBlock: intBlock?
    /*intBlock的传递 */
    var takePhotoBlock: intBlock?
    /*startSportBlock的传递 */
    var startSportBlock: startSportBlock?
    /*timerGetHeartRate的传递 */
    var timerGetHeartRate: timerGetHeartRate?
    /*intBlock的传递 */
    var clockSportBlock: intBlock?
    /*bloodPressure的传递 */
    var bloodPressure: bloodPressure?
    /*intBlock的传递 */
    var timeAlert: intBlock?
    /*BlueToothState的传递 */
    var blueToothState: bluetoothState?
    /*uintBlock的传递 */
    var pageManager: uintBlock?
    //uintBlock的传递
    var supportPage: uintBlock?

// MARK: -- methods
    
    // MARK: - Init
    deinit {
        blueToothScan?.delegate = nil
        blueToothManager?.delegate = nil
    }
    
    override init() {
        super.init()
        
        blueToothScan = BluetoothScan()
        blueToothManager = BlueToothManager()
        
        blueToothManager?.delegate = self
        blueToothScan?.delegate = self
        
        
    }
    

// MARK:   --    蓝牙模块(发送蓝牙指令)
// MARK: -- 扫描设备方法
    /**
     *  蓝牙扫描设备的方法，block返回的为扫描到的设备的数组，数组里的内容为PerModel,此block会多次执行，每次返回的数组都会更新
     *
     *  @param deviceArrayBlock 返回设备列表数组<PerModel>
     */
    func scanDevices(with deviceArrayBlock: @escaping arrayBlock) {
        blueToothScan?.startScan()
        // [self.blueToothManager startScanDevice];
        //if deviceArrayBlock
        
        self.deviceArrayBlock = deviceArrayBlock
        
        perform(#selector(self.stopScanDevice), with: nil, afterDelay: 5.0)
    }

    /*
     *停止扫描设备
     **/
    @objc func stopScanDevice() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.stopScanDevice), object: nil)
        blueToothScan?.stopScan()
        //[self.blueToothManager stopScanDevice];
    }
    
// MARK: -- BlueToothScanDelegate
    
    func bluetoothScanDiscoverPeripheral(deviceArray: [Any]?) {
        print("🍟 deviceArray = \(deviceArray)")
        
        deviceArrayBlock?(deviceArray)
    }

// MARK: -- 连接蓝牙方法

    /**
     *  根据UUID连接设备
     *
     *  @param UUID 要连接设备的UUID，NSString格式，此方法不提供连接是否成功的判断，请用下方监测蓝牙连接状态方法来监测连接成功或设备断开
     
     */
    func connect(withUUID UUID: String?) {
        guard let uuid = UUID else { return }
        blueToothManager?.connect(withUUID: uuid)
    }

// MARK: -- 监测蓝牙状态变化方法
    /**
     *  实现此方法可以监测蓝牙连接状态变化
     *
     *  @param stateChanged block传递为一个int值，1为设备已连接，0为设备已断开
     */
    //- (void)connectedStateChangedWithBlock:(intBlock)stateChanged;

// MARK: -- 断开蓝牙方法
    /**
     *  断开蓝牙方法
     *
     *  @param UUID 当前连接设备的UUID
     */
    func disConnected(withUUID UUID: String?) {
        blueToothManager?.disConnectPeripheral(withUuid: UUID)
    }

    //#pragma mark -- 蓝牙发送数据方法
// MARK:   --   设置模块(发送命令指令，例如同步时间)


    /**
     *
     * app与手环的时间同步
     *
     */
    func synsCurTime() {
        blueToothManager?.synsCurTime()
    }

    /**
     *
     * 同步语言。支持中，英，泰。不是这三种语言。就是英文
     *
     */
    func setLanguage() {
        blueToothManager?.setLanguage()
    }

    /**
     *
     * 发送手环的显示日期的格式 日月
     *
     */
    func sendBraMMDDformat() {
        blueToothManager?.sendBraMMDDformat()
    }

    /**
     *
     * 读取信息提醒的支持
     *
     */
    func checkInformation() {
        blueToothManager?.checkInformation()
    }

    /**
     *
     * app设置手环的公制/英制
     * @param state NO:公制     YES:英制
     *
     */
    func setUnitStateWithState(_ state: Bool) {
        blueToothManager?.setUnitStateWithState(state)
    }

    /**
     *
     * app设置手环的时间是12小时制或24小时制
     * @param state NO:12小时制    YES:24小时制
     */
    func setBindDateStateWithState(_ state: Bool) {
        blueToothManager?.setBindDateStateWithState(state)
    }

    /**
     *  检查手环电量
     *
     *  @param PowerBlock block返回一个int参数，值为当前电量值
     */
    func checkBandPower(withPowerBlock powerBlock: @escaping intBlock) {
        blueToothManager?.checkPower()
        //if PowerBlock
        
        self.powerBlock = powerBlock
    }

    /**
     *
     * 拍照功能  - 开关
     * @param state YES - 打开拍照  NO - 关闭拍照
     */
    func changeTakePhotoState(_ state: Bool) {
        blueToothManager?.setPhotoWithState(state)
    }

    //接受到拍照指令
    func recieveTakePhotoMessage(_ takePhotoBlock: @escaping intBlock) {
        //if takePhotoBlock
        
        self.takePhotoBlock = takePhotoBlock
    }

    /**
     开启找手环功能
     
     @param openFindBindBlock 返回为int值，为1则为成功
     */
    func openFindBind(with openFindBindBlock: @escaping intBlock) {
        blueToothManager?.findBindState(Bool(truncating: 1))
        //if openFindBindBlock
        
        self.openFindBindBlock = openFindBindBlock
    }

    /**
     关闭找手环功能
     
     @param closeFindBindBlock 返回为int值，为1则为成功
     */
    func closeFindBind(with closeFindBindBlock: @escaping intBlock) {
        //if closeFindBindBlock
        
        self.closeFindBindBlock = closeFindBindBlock
        
        blueToothManager?.findBindState(Bool(truncating: 0))
    }

    /**
     *
     *  清除手环数据
     *  @param 返回的整数 1：成功 0：失败
     */
    func resetBind(with resetBindBlock: @escaping intBlock) {
        //if resetBindBlock
        
        self.resetBindBlock = resetBindBlock
        
        blueToothManager?.resetDevice()
    }

    /**
     *
     *检查手环版本
     *  @param  versionBlock 版本号
     */
    func checkVerSion(with versionBlock: @escaping versionBlock) {
        //if versionBlock
        
        self.versionBlock = versionBlock
        
        blueToothManager?.checkVersion()
    }

    /**
     *  开启实时心率
     *
     *  @param heartRateBlock block传递一个int值为心率值，开启实时心率后，block会每秒执行一次，返回当前心率值
     */
    func openActualHeartRate(withBolock heartRateBlock: @escaping intBlock) {
        blueToothManager?.heartRateNotifyEnable(true)
        //if heartRateBlock
        
        self.heartRateBlock = heartRateBlock
    }

    /**
     *  关闭实时心率
     */
    func closeActualHeartRate() {
        blueToothManager?.heartRateNotifyEnable(false)
    }

    /**
     *
     * 设置自定义闹铃
     * @param model
     */
    func setAlarmWith(_ model: CustomAlarmModel?) {
        guard let model = model else { return }
        var repeatValue = getRepeatStatus(withArray: model.repeatArray)
        blueToothManager?.setCustomAlarmWithStatus(1,
                                                   alarmIndex: model.index,
                                                   alarmType: model.type.rawValue,
                                                   alarmCount: model.timeArray.count,
                                                   alarmtimeArray: model.timeArray,
                                                   repeat: &repeatValue,
                                                   notice: model.noticeString)
    }

    /**
     *
     *  查询自定义闹铃
     *  @param alarmModelBlock 回调一个 CustomAlarmModel模型
     */
    //- (void)checkAlarmWithBlock:(alarmModelBlock)alarmModelBlock;
    func checkAlarm(with alarmModelBlock: @escaping alarmModelBlock) {
        //if alarmModelBlock
        
        self.alarmModelBlock = alarmModelBlock
        
        blueToothManager?.queryCustomAlarm()
    }

    /**
     *
     *  删除自定义闹铃
     *  @param index = 固定编号，提醒个数最大为8
     */
    func deleteAlarm(withAlarmIndex index: Int) {
        blueToothManager?.closeCustomAlarm(with: index)
    }

    /**
     *
     * 心率监控间隔 - 心率自动监控开关 -查询
     * @param heartRateMonitorBlock 回调 index：分钟数   state：状态
     */
    func checkHeartTateMonitorwithBlock(_ heartRateMonitorBlock: @escaping doubleInt) {
        //if heartRateMonitorBlock
        
        self.heartRateMonitorBlock = heartRateMonitorBlock
        
        blueToothManager?.queryHeartAndtired()
    }

    /**
     *
     * 心率自动监控开关
     * @param state  NO：关闭    YES：开启
     */
    func changeHeartRateMonitorState(withState state: Bool) {
        blueToothManager?.setHeartHZState(state.int)
    }

    /**
     *
     * 心率监控间隔 -- 设置 -- 常常设置30分钟或60分钟
     * @param Minutes单位分钟：最小值5分钟，最大值60分钟； 若为0X01, 表示连续心率监测(注：目前大部分设备不支持连续心率监测）
     */
    func setHeartRateMonitorDurantionWithTime(_ Minutes: Int) {
        blueToothManager?.setHeartDuration(Minutes)
    }

    /**
     *
     *  心率预警 - 读取
     *  @param  heartRateAlarmBlock
     */
    func checkHeartRateAlarm(with heartRateAlarmBlock: @escaping heartRateAlarmBlock) {
        //if heartRateAlarmBlock
        
        self.heartRateAlarmBlock = heartRateAlarmBlock
        
        blueToothManager?.queryHeartAlarm()
    }

    /**
     *
     * 心率预警 - 设置
     * @param state NO：启动 YES：关闭
     * @param max 最大值
     * @param min 最小值
     */
    func setHeartRateAlarmWithState(_ state: Bool, maxHeartRate max: Int, minHeartRate min: Int) {
        blueToothManager?.setHeartAlarmWithMin(min, andMax: max, andState: state.int)
    }

    /**
     *
     * 固件升级
     *
     */
    func updateBindROM(withRomUrl romURL: String?, progressBlock: @escaping floatBlock, successBlock success: @escaping intBlock, failureBlock failure: @escaping intBlock) {
        
        blueToothManager?.startUpdateHard(withURL: romURL)
        
        self.progressBlock = progressBlock
        self.updateSuccessBlock = success
        self.updateFailureBlock = failure
//        if progressBlock {
//
//        }
//        if success {
//
//        }
//        if failure {
//
//        }
    }

    /**
     *
     * 设置计步参数
     * @param height:身高 weight:体重 male:性别 age:年龄
     * 身高    1    单位厘米
     * 体重    1    单位千克
     * 性别    1    NO：男性，YES：女性
     * 年龄    1    单位周岁
     */
    func sendUserInfoToBind(withHeight height: Int, weight: Int, male: Bool, age: Int) {
        blueToothManager?.setStepPramWithHeight(height, andWeight: weight, andSexIndex: male.int, andAge: age)
    }

    /**
     *
     * 查询设备是否支持某功能
     *
     */
    func checkAction() {
        blueToothManager?.checkAction()
    }

    /**
     *
     * APP查询设备能支持的参数
     *
     */
    func checkParameter() {
        blueToothManager?.checkParameter()
    }

// MARK:   --   功能模块(发送数据指令）
    /**
     *
     * 读取对应的提醒状态
     * @param systemAlarmBlock 回调整数  0：关 1：开
     */
    func checkSystemAlarm(withType type: SystemAlarmType, stateBlock systemAlarmBlock: @escaping doubleInt) {
        //if systemAlarmBlock
        
        self.systemAlarmBlock = systemAlarmBlock
        
        blueToothManager?.querySystemAlarm(with: type.rawValue)
    }

    /**
     *
     * 设置对应的提醒状态
     * @param type 对应的提醒
     * @param state  0：关 1：开
     */
    func setSystemAlarmWithType(_ type: SystemAlarmType, state: Int) {
        blueToothManager?.setSystemAlarmWith(type.rawValue, status: state)
    }

    /**
     *
     * 电话提醒延时功能 - 查询
     * @param phoneDealayBlock  回调一个整数
     */
    func checkPhoneDealay(with phoneDealayBlock: @escaping intBlock) {
        //if phoneDealayBlock
        
        phoneDelayBlock = phoneDealayBlock
        
        blueToothManager?.queryPhoneDelay()
    }

    /**
     *
     * 电话提醒延时功能 - 设置
     * @param phoneDealayBlock  延时时间：秒为单位 Seconds --- 常常设置为 立即，5秒，10秒
     */
    func setPhoneDelayWithDelaySeconds(_ Seconds: Int) {
        blueToothManager?.setPhoneDelay(Seconds)
    }

    /**
     
     发送运动目标和睡眠目标
     
     */
    func activeCompletionDegree() {
        blueToothManager?.activeCompletionDegree()
    }

// MARK:   --   获取手环数据模块(例如步数)

    /**
     *  获取当天全天数据概览
     *
     *  @param dayTotalDataBlock block内返回当天数据的DayOverViewDataModel,详情请进入model查看。
     */
    func chekCurDayAllData(with dayTotalDataBlock: @escaping allDayModelBlock) {
        blueToothManager?.getCurDayTotalData()
        //if dayTotalDataBlock
        
        self.dayTotalDataBlock = dayTotalDataBlock
    }

    /**
     *  查询每小时步数及卡路里消耗
     *
     *  @param dayHourDataBlock 返回步数数组，共24小时每小时步数 卡路里消耗数组，24小时每小时消耗，timeSeconds 当天时间秒数
     */
    func checkHourStepsAndCosts(with dayHourDataBlock: @escaping doubleArrayBlock) {
        blueToothManager?.getCurDayTotalDataWith(type: 1)
        //if dayHourDataBlock
        
        self.dayHourDataBlock = dayHourDataBlock
    }

    /**
     查看今天睡眠数据
     
     @param sleepStateArrayBlock 返回sleepModel,此接口只返回今天0点以后数据，需要截取前天历史睡眠数据进行拼接成完整睡眠数据
     */
    func checkTodaySleepState(with sleepStateArrayBlock: @escaping sleepModelBlock) {
        
        blueToothManager?.getCurDayTotalDataWith(type: 2)
        //if sleepStateArrayBlock
        
        self.sleepStateArrayBlock = sleepStateArrayBlock
    }

    /**
     查看当天心率数据
     
     @param heartRateArrayBlock 心率数据返回三个值，1、今天的时间，已秒数格式返回，2、心率包序号（1-8），3、心率数组。心率数据每分钟一个值，没有值为0，全天心率1440分钟，分为8个包，每个包为3个小时数据，用包序号区分。查询当天心率会查询从0点到当前时间的心率值，此block最多会执行8次，每次返回的数组为180个值，用包序号来确定具体时间。
     */
    func checkTodayHeartRate(with heartRateArrayBlock: @escaping doubleIntArrayBlock) {
        if HCHCommonManager.instance.queryHearRateSeconed != 0 {
            blueToothManager?.getNewestCurDayTotalHeartData()
        } else {
            blueToothManager?.getCurDayTotalHeartData()
        }
        //if heartRateArrayBlock
        
        self.heartRateArrayBlock = heartRateArrayBlock
    }

    /**
     查询HRV值
     
     @param HRVDataBlock 返回内容有两个，1、今天时间 2、HRV值数组，共24个值，为每小时HRV，没有值则为0 HRV取值范围为0-100，表示当前用户疲劳状态。值越低表示越疲劳，100则表示充满活力
     */
    func checkHRV(withHRVBlock hrvDataBlock: @escaping intArrayBlock) {
        blueToothManager?.getPilaoData()
        //if HRVDataBlock
        
        self.hrvDataBlock = hrvDataBlock
    }

    /**
     *
     * 久坐提醒功能 - 查询
     * @param  sedentaryArrayBlock 回调一个数组
     */
    func checkSedentary(withSedentaryBlock sedentaryArrayBlock: @escaping arrayBlock) {
        //if sedentaryArrayBlock
        
        self.sedentaryArrayBlock = sedentaryArrayBlock
        
        blueToothManager?.queryJiuzuoAlarm()
    }

    /**
     *
     * 久坐提醒功能 - 设置
     * @param sedentaryModel 久坐模型
     */
    func setSedentaryWith(_ sedentaryModel: SedentaryModel?) {
        
        guard let sedentaryModel = sedentaryModel else { return }
        
        blueToothManager?.setJiuzuoAlarmWithTag(sedentaryModel.index, isOpen: Bool(truncating: 1), beginHour: sedentaryModel.beginHour, minite: sedentaryModel.beginMin, endHour: sedentaryModel.endHour, minite: sedentaryModel.endMin, duration: sedentaryModel.duration)
    }

    /**
     *
     * 久坐提醒功能 - 删除
     * @param index 久坐提醒的编号
     */
    func deleteSedentaryAlarm(with index: Int) {
        blueToothManager?.deleteJiuzuoAlarm(withTag: index)
    }

// MARK: -- ada 写
    /**
     
     * 打开心率的命令
     * @param startSportBlock 回调 1 为开启成功
     */
    func openHeartRate(_ startSportBlock: @escaping startSportBlock) {
        blueToothManager?.openHeartRate()
        //if startSportBlock
        
        self.startSportBlock = startSportBlock
    }

    /**
     *
     * 定时获取心率以及运动数据
     * @param timerGetHeartRate 回调 SportModelMap
     */
    func timerGetHeartRateData(_ timerGetHeartRate: @escaping timerGetHeartRate) {
        blueToothManager?.timerGetHeartRateData()
        //if timerGetHeartRate
        
        self.timerGetHeartRate = timerGetHeartRate
    }

    /**
     *
     * close   心率的命令
     * @param closeSportBlock 回调 2 关闭成功
     */
    func closeHeartRate(_ clockSportBlock: @escaping intBlock) {
        blueToothManager?.closeHeartRate()
        //if clockSportBlock
        
        self.clockSportBlock = clockSportBlock
    }

    /**
     *
     * 获取血压的数据
     * @param bloodPressure 回调 BloodPressureModel
     */
    func getBloodPressure(_ bloodPressure: @escaping bloodPressure) {
        self.bloodPressure = bloodPressure
    }

    /**
     *
     * 检查是否提示了
     *
     */
    func checkConnectTimeAlert(_ timeAlert: @escaping intBlock) {
        //if TimeAlert
        
        self.timeAlert = timeAlert
    }

    /**
     *
     * 检查蓝牙开关
     *
     */
    func checkCBCentralManagerState(_ blueToothState: @escaping bluetoothState) {
        self.blueToothState = blueToothState
    }

    /**
     *
     * 读取页面管理
     * @param pageManager 回调 一个整数
     */
    func checkPageManager(_ pageManager: @escaping uintBlock) {
        //if pageManager
        
        self.pageManager = pageManager
        
        blueToothManager?.checkPageManager()
    }

    /**
     *
     * 页面管理 -- 支持那些页面
     * @param page 回调 一个整数
     */
    func supportPageManager(_ page: @escaping uintBlock) {
        //if page
        
        supportPage = page
        
        blueToothManager?.supportPageManager()
    }

    /**
     *
     *   set  页面管理
     *   @param pageString 一个整数
     */
    func setupPageManager(_ pageString: uint) {
        blueToothManager?.setupPageManager(pageString)
    }

    /**
     *
     *   发送天气
     *
     */
    func sendWeather(_ weather /*发送天气 */: PZWeatherModel?) {
//        blueToothManager?.sendWeather(weather)
        
    }
    /**
     *
     *   发送未来几天天气
     *
     */
    func sendWeatherArray(_ weatherArr: [AnyHashable]?, day: Int, number /*发送未来几天天气 */: Int) {
//        var weatherArr = weatherArr
//        blueToothManager.sendWeatherArray(weatherArr, day: day, number: number)
    }
    /**
     *
     *   发送某天天气   今天
     *
     */
    func sendOneDayWeather(_ weather /*发送某天天气   今天 */: PZWeatherModel?) {
//        blueToothManager?.sendOneDayWeather(weather)
    }

    /**
     *
     *   发送某天天气   某天   < 6
     *
     */
    func sendOneDayWeatherTwo(_ weather /*发送某天天气   某天   < 6 */ : WeatherDay?) {
        blueToothManager?.sendOneDayWeatherTwo(weather)
    }

    /**
     *
     *   告诉设备，是否准备接收数据
     *
     */
    func readyReceive(_ number: Int) {
        blueToothManager?.readyReceive(number)
    }

    /**
     *
     * 设置设备， 校正值   APP设置血压测量配置参数
     *
     */
    func setupCorrectNumber() {
        blueToothManager?.setupCorrectNumber()
    }

// MARK: -- 手环端上传离线数据，历史数据

#warning("此处方法必须实现用来接收数据，手环端主动上传的数据如历史数据，离线运动数据等，只有实现下列方法才能接收，手环端只上传一次，所以需要在入口类或者全局存在的单例类实现下列方法，对手环上传的数据进行处理保存。")

    // MARK: -- 收到离线数据历史数据等
    /**
     *  接收离线数据
     *
     *  @param offLineDataBlock block传递参数为OffLineDataModel
     */
    func recieveOffLineData(withBlock offLineDataBlock: @escaping offLineDataModel) {
        //if offLineDataBlock
        
        self.offLineDataModelBlock = offLineDataBlock
        
    }

    /**
     *  收到全天概览历史数据，可以接收后保存或上传服务器
     *
     *  @param historyAllDayDataBlock 返回DayOverViewDataModel
     */
    func recieveHistoryAllDayData(with historyAllDayDataBlock: @escaping allDayModelBlock) {
        //if historyAllDayDataBlock
        
        self.historyAlldayModelBlock = historyAllDayDataBlock
    }

    /**
     接收历史每小时计步和消耗
     
     @param historyHourDataBlock 同查询当天计步和消耗
     */
    func recieveHistoryHourData(with historyHourDataBlock: @escaping doubleArrayBlock) {
        //if historyHourDataBlock
        
        self.historyHourDataBlock = historyHourDataBlock
    }

    /**
     接收历史睡眠数据
     
     @param historySleepDataBlock 同查询当天睡眠数据
     */
    func recieveHistorySleepData(with historySleepDataBlock: @escaping sleepModelBlock) {
        //if historySleepDataBlock
        
        self.historySleepStateArrayBlock = historySleepDataBlock
    }

    /**
     接收历史心率
     
     @param historyHeartRateBlock 格式同查询当天心率
     */
    func recieveHistoryHeartRate(with historyHeartRateBlock: @escaping doubleIntArrayBlock) {
        
        //if historyHeartRateBlock
        
        self.historyHeartRateArrayBlock = historyHeartRateBlock
    }

    /**
     接收历史HRV数据
     
     @param historyHRVDataBlock 格式同查询当天历史数据
     */
    func recieveHistoryHRVData(with historyHRVDataBlock: @escaping intArrayBlock) {
        //if historyHRVDataBlock
        
        self.historyHRVDataBlock = historyHRVDataBlock
    }

// MARK:   - - 连接蓝牙刷新 的方法
    func coreBlueRefresh() {
        blueToothManager?.coreBlueRefresh()
    }

    /*
     *   连接状态的改变
     *
     */
    func connectStateChanged(withBlock connectStateBlock: @escaping connectStateChanged) {
        //if connectStateBlock
        
        self.connectStateBlock = connectStateBlock
    }

// MARK: -- 处理数据工具方法
    func combineData(withAddr addr: [UInt8], andLength len: UInt32) -> UInt32 {
        var result: UInt32 = 0
        
        var byte = addr
        
        for index in 0..<Int(len) {
//            let index = UInt32(index)
            let i = UInt32(index)
            
            byte = ToolBox.byte(&byte, add: index)
            let data = Data(bytes: byte, count: addr.count)
            let value = UInt32(bigEndian: data.withUnsafeBytes({ $0.pointee }))
            
            result = result | (value << (8 * i))
//            result = Int(result ?? 0) | (ToolBox.byte(&addr, add: index) << (8 * index))
        }
        //    if (result < 0)
        //    {
        //        result = 0;
        //    }
        return result
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    // MARK: -- 接收蓝牙数据
    // MARK: -- BlueToothManagerDelegate
    func blueToothManagerIsConnected(_ isConnected: Bool, connect peripheral: CBPeripheral?) {
        if connectStateBlock != nil {
            connectStateBlock!(isConnected, peripheral)
        }
    }
    
    func blueToothManagerReceiveNotify(_ dat: Data?) {
        
        guard let dat = dat else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var transDat = dat.bytes
        var flag: Bool = check(dat)
        if !flag {
            return
        }
        
        //    //adaLog(@"recieveData = %@",Dat);
        //    //adaLog(@"transDat = %s",transDat);   a9  29   aa  2a
        
        switch Int(transDat[1] & 0x7f) {
            
        case BlueToothFunctionIndexEnum.unitSet.rawValue /*语言设置  以及各种基本设置 */:
            receiveHeartAndTired(dat)
            
        case BlueToothFunctionIndexEnum.checkPower.rawValue /*检测电量 */:
            receivePowerData(with: transDat)
            
        case BlueToothFunctionIndexEnum.updateTotalData.rawValue /*全天数据 */:
            receiveTotalData(with: dat)
            
        case BlueToothFunctionIndexEnum.setStepPram.rawValue:
            receiveSetStep(dat)
            
        case BlueToothFunctionIndexEnum.updateOffLine.rawValue:
            
            receiveOffLineData(with: dat)
            var len: Int = 0
            //Byte *transDat = (Byte *)[Dat bytes];
            let numberLength: uint = combineData(withAddr: ToolBox.byte(&transDat, add: 2), andLength: 2)
            if Int(numberLength) > 17 {
                if transDat[12] == 0x04 {
                    len = 9
                } else {
                    len = 11
                }
                blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateOffLine.rawValue, andDat: dat.subdata(in: 4..<(4 + len)))
            } else {
                if transDat[12] == 0x01 {
                    len = 9
                } else {
                    len = 11
                }
                blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateOffLine.rawValue, andDat: dat.subdata(in: 4..<(4 + len)))
            }
            
        case BlueToothFunctionIndexEnum.updateTiredData.rawValue:
            receivePilaoData(dat)
            
        case BlueToothFunctionIndexEnum.findBand.rawValue:
            receiveFindBandData(dat)
            
        case BlueToothFunctionIndexEnum.resetDevice.rawValue:
            receiveResetDeviceData(dat)
            
        case BlueToothFunctionIndexEnum.checkVersion.rawValue:
            receiveVersionData(with: transDat)
            
        case BlueToothFunctionIndexEnum.customAlarm.rawValue:
            recieveCustomAlarmData(with: dat)
            
        case BlueToothFunctionIndexEnum.openAntiLoss.rawValue:
            recieveAntiLossData(dat)
            
        case BlueToothFunctionIndexEnum.phoneDelay.rawValue:
            blueToothReceivePhoneDelay(dat)
            
        case BlueToothFunctionIndexEnum.jiuzuoAlarm.rawValue:
            recieveJiuzuoAlarmData(dat)
            
        case BlueToothFunctionIndexEnum.heartRateAlarm.rawValue:
            recieveHeartRateAlarm(with: dat)
            
        case BlueToothFunctionIndexEnum.updateHardWare.rawValue:   //升级固件
            receiveUpdateResponse(dat)
            
        case BlueToothFunctionIndexEnum.takePhoto.rawValue:
            receiveTakePhoto(dat)
            
            
        case BlueToothFunctionIndexEnum.getActualData.rawValue:  //打开心率测试   获取实时数据
            // //adaLog(@"transDat   ==  %s",transDat);
            receiveopenHeartRate(dat)
            
        case BlueToothFunctionIndexEnum.bloodPressure.rawValue:  //0x2a    血压   a9  29   aa  2a
            ////adaLog(@"transDat   ==  %s",transDat);
            receiveBloodPressure(dat)
            
        case BlueToothFunctionIndexEnum.pilaoData.rawValue:    //疲劳值不支持  0x65
            HCHCommonManager.instance.pilaoValue = false
            
        case BlueToothFunctionIndexEnum.pageManager_None.rawValue:    //界面管理页面
            ////adaLog(@"transDat   ==  %s",transDat);
            receivePageManager(dat)
            
        case BlueToothFunctionIndexEnum.sendWeatherSuc.rawValue:     //天气发送成功
            #if DEBUG
            print("\(#function)\n------ 天气发送成功")
            #endif
            
        case BlueToothFunctionIndexEnum.queryWeather.rawValue:     //天气请求数据
            //adaLog(@"天气请求数据");
            receiveQueryWeather(dat)
            
        case BlueToothFunctionIndexEnum.completionDegree.rawValue:     //完成度
            ////adaLog(@"完成度");
            receiveCompletionDegree(dat)
            
        case BlueToothFunctionIndexEnum.checkAction.rawValue:     //查询设备是否支持某功能
            //            //adaLog(@"是否支持某功能");
            receiveCheckAction(dat)
            
        case BlueToothFunctionIndexEnum.checkNewLength.rawValue:     //查询设备是否支持某功能 //查询设备支持 长度
            receiveCheckNewLength(dat)
            
        default:
            break
        }
    }
    
    //验证数据是合法的
    
    func check(_ data: Data) -> Bool {
        let transData = data.bytes
        var checkNum: UInt32 = 0
        for i in 0..<data.count - 2 {
            checkNum += UInt32(transData[i])
        }
        //自己算出的   校验码CS
        checkNum = checkNum % 256
        //读取校验码
        //    //adaLog(@"读取校验码   ==  %x  %x",transData[data.length - 2],checkNum);
        var flag = true
        if transData[data.count - 2] != checkNum {
            flag = false
        }
        return flag
    }
    
    func recieveAntiLossData(_ data: Data) {
        //adaLog(@"recieveAntiLossData  - %@",data);
        let transDat = data.bytes
        if (Int(transDat[1]) & 0x7f) == BlueToothFunctionIndexEnum.openAntiLoss.rawValue && transDat[4] == 1 {
            let tagIndex = Int(transDat[5])
            let state = Int(transDat[6])
            
            if systemAlarmBlock != nil {
                systemAlarmBlock!(tagIndex, state)
            }
            if state == 1 && transDat[5] != 1 {
                if let blueToothManager = blueToothManager {
                    blueToothManager.phoneAlarmNotify()
                }
            }
        } else if transDat[4] == 2 {
            if transDat[5] == 16 && transDat[6] == 137 {
                UserDefaults.standard.set(GlobalProperty.SUPPORTINFORMATION, forKey: "2") //支持Line信息提醒
            }
        }
    }
    
    func blueToothManagerReceiveHeartRateNotify(_ dat: Data?) {
        
        guard let dat = dat, dat.count >= 2 else {
            return
        }
        
        let transDat = dat.bytes
        let heartRate = Int(transDat[1])
        if heartRateBlock != nil {
            heartRateBlock!(heartRate)
        }
    }
    
    func callbackConnectTimeAlert(_ TimeAlert: Int) {
        
        if timeAlert != nil {
            timeAlert!(TimeAlert)
        }
        //    self.blueToothManager.connectTimeAlert = 2;
    }
    
    func callbackCBCentralManagerState(_ state: CBManagerState) {
        if blueToothState != nil {
            blueToothState!(state)
        }
    }
    
    // MARK: -- 接收到蓝牙数据后处理方法
    
    /**
     *  收到电量处理方法
     *
     *  @param data 收到的数据
     */
    func receivePowerData(with data: [UInt8]) {
        let power = Int(data[4])
        if powerBlock != nil {
            powerBlock!(power)
        }
    }
    
    func receiveSetStep(_ data: Data?) {
        //    adaLog(@"设置计步参数 bra answer \(data);
        #if DEBUG
        print("\(#file)\n\(#function)\n设置计步参数 bra answer \(String(describing: data))")
        #endif
    }
    
    /**
     *  收到全天数据，分概览，计步，睡眠，心率4个类型，还需要判断收到历史数据和当天数据
     *
     *
     *  @return
     */
    func receiveTotalData(with data: Data) {
        //    interfaceLog(@"全天总数据%@",data);
        let queue = DispatchQueue.global(qos: .default)
        queue.sync(execute: {
            var transDat = data.bytes
            
            if data.count < 8 {
                return
            }
            let curDate = TimeCallManager.instance.getSecondsOfCurDay()
            let dataDate = TimeCallManager.instance.getYYYYMMDDSeconds(with: data.subdata(in: 4..<7))
            
            
            if transDat[7] == 0x00 {
                let timeSeconds: UInt32 = UInt32(dataDate)
                
                #warning("不確定是否正確 - Not sure if it is correct.")
                
                var stepCount: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 8), andLength: 4)

                var meterCount: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 16), andLength: 4)

                var costCount: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 12), andLength: 4)
                
                var activity: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 20), andLength: 4)
                
                var activityCosts: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 24), andLength: 4)
                
                var calmtime: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 28), andLength: 4)
                
                var calmtimeCosts: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 32), andLength: 4)
//                var stepCount: uint = self.combineData(withAddr: transDat + 8, andLength: 4)
//                var meterCount: uint = self.combineData(withAddr: Int(transDat ?? 0) + 16, andLength: 4)
//                var costCount: uint = self.combineData(withAddr: Int(transDat ?? 0) + 12, andLength: 4)
//                var activity: uint = self.combineData(withAddr: Int(transDat ?? 0) + 20, andLength: 4)
//
//                var activityCosts: uint = self.combineData(withAddr: Int(transDat ?? 0) + 24, andLength: 4)
//                var calmtime: uint = self.combineData(withAddr: Int(transDat ?? 0) + 28, andLength: 4)
//                var calmtimeCosts: uint = self.combineData(withAddr: Int(transDat ?? 0) + 32, andLength: 4)
                
                if Int(stepCount) == -1 {
                    stepCount = 0
                }
                if Int(meterCount) == -1 {
                    meterCount = 0
                }
                if Int(costCount) == -1 {
                    costCount = 0
                }
                if Int(activity) == -1 {
                    activity = 0
                }
                
                if Int(activityCosts) == -1 {
                    activityCosts = 0
                }
                if Int(calmtime) == -1 {
                    calmtime = 0
                }
                if Int(calmtimeCosts) == -1 {
                    calmtimeCosts = 0
                }
                
                let daydataModel = DayOverViewDataModel(timeSeconds: Int(timeSeconds),
                                                        steps: Int(stepCount),
                                                        meters: Int(meterCount),
                                                        costs: Int(costCount),
                                                        activityTime: Int(activity),
                                                        calmTime: Int(calmtime),
                                                        activityCosts: Int(activityCosts),
                                                        calmCosts: Int(calmtimeCosts))
                
                if curDate != dataDate {
                    self.historyAlldayModelBlock?(daydataModel)
                    self.blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateTotalData.rawValue, andDat: data.subdata(in: 4..<8))
                } else {
                    self.dayTotalDataBlock?(daydataModel)
                }
            } else if transDat[7] == 0x01 {
                
                #warning("不確定是否正確 - Not sure if it is correct.")
                
                let timeSeconds: Int = Int(dataDate)
                var stepsArray: [UInt32] = []
                var costsArray: [UInt32] = []
                for i in 0..<24 {
                    
//                    transDat.append(UInt8(8 + 4 * i))
                    var stepsValue: UInt32 = self.combineData(withAddr: ToolBox.byte(&transDat, add: 8 + 4 * i), andLength: 4)
                    
//                    transDat.append(UInt8(104 + 4 * i))
                    var costsValue: UInt32 = self.combineData(withAddr:ToolBox.byte(&transDat, add: 104 + 4 * i), andLength: 4)
                    if Int(stepsValue) == -1 {
                        //                    NSAssert(stepsValue != -1,@"处理-1");
                        //                    NSAssert(stepsValue != 0xff,@"处理-1");
                        stepsValue = 0
                    }
                    if Int(costsValue) == -1 {
                        //                    NSAssert(costsValue != -1,@"处理-1");
                        //                    NSAssert(costsValue != 0xff,@"处理-1");
                        costsValue = 0
                    }
                    stepsArray.append(stepsValue)
                    costsArray.append(costsValue)
                }
                
                if curDate == dataDate {
                    self.dayHourDataBlock?(stepsArray, costsArray, timeSeconds)
                } else {
                    self.historyHourDataBlock?(stepsArray, costsArray, timeSeconds)
                    self.blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateTotalData.rawValue, andDat: data.subdata(in: 4..<8))
                }
            } else if transDat[7] == 0x02 {
                var deepSleep: Int = 0
                var lightSleep: Int = 0
                var awakeSleep: Int = 0
                var sleepStates: [Int] = []
                for i in 0..<36 {
                    let sleepState = transDat[8 + i]
                    for index in 0..<4 {
                        let state: Int = Int(sleepState) >> (2 * index) & 0x03
                        if state == 0 {
                            awakeSleep += 1
                        }
                        if state == 1 {
                            lightSleep += 1
                        }
                        if state == 2 {
                            deepSleep += 1
                        }
                        sleepStates.append(state)
                    }
                }
                let sleepModel = SleepModel(timeSeconds: Int(dataDate),
                                            lightSleepTime: lightSleep * 10,
                                            deepSleepTime: deepSleep * 10,
                                            awakeSleepTime: awakeSleep * 10,
                                            sleepArary: sleepStates)
                
                if curDate != dataDate {
                    self.historySleepStateArrayBlock?(sleepModel)
                    self.blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateTotalData.rawValue, andDat: data.subdata(in: 4..<8))
                } else {
                    self.sleepStateArrayBlock?(sleepModel)
                }
            } else if transDat[7] == 0x03 {
                var heartRateArray: [Int32] = []
                let packIndex = Int(transDat[9] )
                for i in 0..<180 {
                    var heartRate = Int(transDat[10 + i] )
                    if heartRate == 0xff {
                        heartRate = 0
                    }
                    heartRateArray.append(Int32(heartRate ))
                }
                
                
                DispatchQueue.main.async(execute: {
                    if dataDate == TimeCallManager.instance.getSecondsOfCurDay() {
                        HCHCommonManager.instance.queryHearRateSeconed = Int(TimeCallManager.instance.getNowSecond())
                        
                        self.heartRateArrayBlock?(Int(dataDate), packIndex, heartRateArray)
                        
                    } else {
                        self.historyHeartRateArrayBlock?(Int(dataDate), packIndex, heartRateArray)
                        self.blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateTotalData.rawValue, andDat: data.subdata(in: 4..<10))
                    }
                })
            }
            //            if (curDate != dataDate && transDat[7] != 0x03)
            //            {
            //                [self uploadDataWithTimeSeconds:dataDate];
            //            }
            //            else if (curDate != dataDate && transDat[7] == 0x03)
            //            {
            //                [self uploadDataWithTimeSeconds:dataDate];
            //            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func receivePilaoData(_ data: Data?) {
        
        guard let data = data else { return }
        
        let queue = DispatchQueue.global(qos: .default)
        queue.sync(execute: { [weak self] in
            let curDate = TimeCallManager.instance.getSecondsOfCurDay()
            let dataDate = TimeCallManager.instance.getYYYYMMDDSeconds(with: data.subdata(in: 4..<7))
            
            let transDat = data.bytes
            var pilaoArray: [Int32] = []
            for i in 0..<24 {
                var pilaoValue = Int(transDat[7 + i])
                if pilaoValue == -1 || pilaoValue == 0xff {
                    //                NSAssert(pilaoValue != -1,@"处理-1");
                    //                NSAssert(pilaoValue != 0xff,@"处理-1");
                    pilaoValue = 0xff
                }
                pilaoArray.append(Int32(pilaoValue ))
            }
            let array = pilaoArray.map{ Int($0) }
            if curDate == dataDate {
                DispatchQueue.main.async(execute: {
                    
                    self?.hrvDataBlock?(Int(dataDate), array)
                })
            } else {
                self?.historyHRVDataBlock?(Int(dataDate), array)
                blueToothManager?.revDataAck(with: BlueToothFunctionIndexEnum.updateTiredData.rawValue, andDat: data.subdata(in: 4..<7))
            }
        })
    }
    
    func receiveFindBandData(_ data: Data?) {
        guard let data = data else { return }
        
        let transData = data.bytes
        let state = transData.item(at: 4)
//        let state2 = transData.
        if state != nil {
            closeFindBindBlock?(1)
        } else {
            openFindBindBlock?(1)
        }
    }
    
    func receiveResetDeviceData(_ data: Data?) {

        let transData = data?.bytes
        let state = transData?.item(at: 5)

        resetBindBlock?((!(state != nil)).int)
    }
    
    func receiveVersionData(with data: [UInt8]) {
        
        #warning("不確定是否正確")
        
        var dat = data
        
        
        let length = combineData(withAddr: ToolBox.byte(&dat, add: 2), andLength: 2)
        if length == 3 {
            let hardVersion = dat[4]
            let softVersion = dat[6]
            let blueVersion = dat[5]
            versionBlock?(Int(hardVersion), 161616, Int(softVersion), Int(blueVersion))
        } else if length == 4 {
            let firstHardVersion = dat[4]
            let secondHardVersion = dat[5]
            let blueVersion = dat[6]
            let softVersion = dat[7]
            versionBlock?(Int(firstHardVersion), Int(secondHardVersion), Int(softVersion), Int(blueVersion))
        }
    }
    
    func recieveCustomAlarmData(with data: Data?) {
        
        guard let data = data else { return }
        
        var transDat = data.bytes
        #warning("不確定是否正確")
        
        let totalData = combineData(withAddr: ToolBox.byte(&transDat, add: 2), andLength: 2)
        if Int(totalData) == 0 {
            return
        } else {
            if Int(totalData) > 3 {
                var timeArray: [String] = []
                let timeCount = transDat.item(at: 7)
                var i = 0
                while i < (timeCount ?? 0) * 2 {
                    var tempStr: String? = nil
                    if let i = transDat.item(at: i + 8), let i1 = transDat.item(at: Int(i + 1 + 8)) {
                        tempStr = String(format: "%02d:%02d", i, i1)
                    }
                    timeArray.append(tempStr ?? "")
                    i += 2
                }
                
                var repeatArray: [Int] = []
                var subIndex: Int = Int((timeCount ?? 0) * 2 + 8)
                let intRepeat = Int(transDat.item(at: subIndex) ?? 0)
                for i in 0..<7 {
                    if ((intRepeat ) >> i) & 0x01 != 0 {
                        repeatArray.append(1)
                    } else {
                        repeatArray.append(0)
                    }
                }
                var noticeString: String? = nil
                if transDat.item(at: 6) == 6 {
                    subIndex += 1
                    let length = subIndex + data.count - subIndex - 2
                    let ldata: Data? = data.subdata(in: subIndex..<length)
                    var tempString = ldata?.description
                    tempString = (tempString as NSString?)?.substring(with: NSRange(location: 1, length: (tempString?.count ?? 0) - 2))
                    tempString = tempString?.replacingOccurrences(of: " ", with: "")
                    
                    noticeString = transToUnicodString(with: tempString)
                    noticeString = replaceUnicode(noticeString)
                }
                
                if let type = AlarmType(rawValue: Int(transDat[6])) {
                    let model = CustomAlarmModel(index: Int(transDat[5]),
                                                 type: type,
                                                 timeArray: timeArray,
                                                 repeatArray: repeatArray,
                                                 noticeString: noticeString)
                    alarmModelBlock?(model)
                }
                
            }
        }
    }
    
    func blueToothReceivePhoneDelay(_ dat: Data?) {
        guard let dat = dat else { return }
        let transDat = dat.bytes
        let type = transDat.item(at: 4) != nil ? transDat[4] : nil
        if type == 1 {
        } else {
            let delayTime = Int(transDat[5])
            phoneDelayBlock?(delayTime)
        }
    }
    
    func recieveJiuzuoAlarmData(_ data: Data?) {
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var transDat = data.bytes
        if transDat.item(at: 4) == 0 {
            let length: uint = combineData(withAddr: ToolBox.byte(&transDat, add: 2), andLength: 2)
            var mutaArray: [AnyHashable] = []
            for i in 0..<Int(length) / 7 {
                let index: Int = 5 + i * 7
                let tag = Int(transDat[index])
                let beginMin = Int(transDat[index + 2])
                let beginHour = Int(transDat[index + 3])
                let endMin = Int(transDat[index + 4])
                let endHour = Int(transDat[index + 5])
                let duration = Int(transDat[index + 6])
                let model = SedentaryModel(index: tag,
                                           beginMin: beginMin,
                                           beginHour: beginHour,
                                           endMin: endMin,
                                           endHour: endHour,
                                           duration: duration)
                mutaArray.append(model)
            }
            sedentaryArrayBlock?(mutaArray)
        }
    }
    
    func receiveHeartAndTired(_ data: Data?) {
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        let transData = data.bytes
        //    //adaLog(@"语言设置：%@",data);
        if transData[4] == 0 {
            //        interfaceLog(@"Language 1111 = read = %@",data);
            //        //adaLog(@"语言设置：%@",data);
            var heartDuration = Int(transData[6])
            if heartDuration == 60 {
                heartDuration = 30
            }
            let tiredState = Int(transData[8])
            heartRateMonitorBlock?(heartDuration, tiredState)
        } else if transData[4] == 1 {
            //        interfaceLog(@"Language 1111 = Answer = %@",data);
            //             interfaceLog(@"连续心率监测 bra answer %@",data);
        }
        
    }
    
    func recieveHeartRateAlarm(with data: Data?) {
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        let transDat = data.bytes
        if transDat[4] == 2 {
            let state = transDat.item(at: 5) != nil ? 0 : 1
            let max = Int(transDat[6])
            let min = Int(transDat[7])
            heartRateAlarmBlock?(state, max, min)
        }
    }
    
    func receiveUpdateResponse(_ data: Data?) {
        //adaLog(@"UpdateHard == %@",data);
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reSendUpdataData), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.upDateFaile), object: nil)
        var transDat = data.bytes
        if transDat[4] == 0x00 {
            perform(#selector(self.reSendUpdataData), with: nil, afterDelay: 2)
            perform(#selector(self.upDateFaile), with: nil, afterDelay: 6)
            blueToothManager?.updateHardWaer(withPack: 1)
            packNumber = 1
        } else if transDat[4] == 0x01 {
            let totalPack: uint = combineData(withAddr: ToolBox.byte(&transDat, add: 5), andLength: 2)
            let pack: uint = combineData(withAddr: ToolBox.byte(&transDat, add: 7), andLength: 2)
            
            var progress: Float = 0
            let fPack = Float(pack)
            progress = fPack / Float(totalPack)
            progressBlock?(progress)
            
            if pack < totalPack {
                blueToothManager?.updateHardWaer(withPack: Int(pack) + 1)
                packNumber = Int(pack) + 1
                perform(#selector(self.reSendUpdataData), with: nil, afterDelay: 2)
                perform(#selector(self.upDateFaile), with: nil, afterDelay: 6)
            } else {
                blueToothManager?.updatehardwaerComplete()
            }
        } else if transDat[4] == 0x02 {
            updateSuccessBlock?(1)
            return
        }
    }
    
    func receiveTakePhoto(_ data: Data?) {
        takePhotoBlock?(1)
        blueToothManager?.answerTakePhoto()
    }
    
    func receiveopenHeartRate(_ data: Data?) {
        //adaLog(@"receiveopenHeartRate  ==  %@",data);
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var byteout = data.bytes
        //心率开关
        if byteout[4] == 1 {
            startSportBlock?(Bool(truncating: NSNumber(value: byteout[4])))
            return
        } else if byteout[4] == 2 {
            clockSportBlock?(Int(byteout[4]))
            return
        } else {
            //心率数据
            //  心率   1   heartRate
            //当前步数  4  stepNumber
            //当前里程  4  mileageNumber
            //当前消耗热量    4  kcalNumber
            //当前步速  1   stepSpeed
            let heartRate: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 1)
            let stepNumber: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 6), andLength: 4)
            let mileageNumber: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 10), andLength: 4)
            let kcalNumber: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 14), andLength: 4)
            let stepSpeed: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 18), andLength: 1)
            //adaLog(@"heartRate率 =  %d -stepSpeed = %d ",heartRate,stepSpeed);
            let sport = SportModelMap()
            sport.heartRate = "\(heartRate)"
            sport.stepNumber = "\(stepNumber)"
            sport.mileageNumber = "\(mileageNumber)"
            sport.kcalNumber = "\(kcalNumber)"
            sport.stepSpeed = "\(stepSpeed)"
            timerGetHeartRate?(sport)
        }
        
        //很重要的转字符串的代码
        //    NSMutableString * string = [[NSMutableString alloc] init];
        //    for (int i = 0; i < data.length; i++) {
        //        NSString * tempString = [NSString stringWithFormat:@"%x",byteout[i]];
        //        if (tempString.length == 1) {
        //            tempString = [NSString stringWithFormat:@"0%@",tempString];
        //        }
        //        [string appendString:tempString];
        //    }
        //    NSLog(@"string  = = %@",string);
        
    }
    
    func receiveBloodPressure(_ data: Data?) {
        //adaLog(@"receiveBloodPressure  ==  %@",data);
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var byteout = data.bytes
        if byteout[4] == 0 {
            
            //4    时间（UTC）
            //1    收缩压
            //1    舒张压
            //1    心率
            //1    SPO2
            //1    HRV
            let dataNum: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 2), andLength: 2)
            let dataNumber = (Int(dataNum) - 1) / 9
            
            
            
            #warning("SQLdataManger 還未建立")
//            let bloodArr = SQLdataManger.getInstance().queryBloodPressure(withDay: Date().getCurrentDateStr())
            let bloodArr = [[AnyHashable : Any]]()
            
            
            
            if dataNumber > 1 {
                
                var systemTimeOffset: Int = 0
                var time: UInt32 = 0
                var testTime = ""
                for i in 0..<dataNumber {
                    systemTimeOffset = NSTimeZone.system.secondsFromGMT()
                    time = UInt32(Int(combineData(withAddr: ToolBox.byte(&byteout, add: 5 + 9 * i), andLength: 4)) - systemTimeOffset)
                    testTime = TimeCallManager.instance.getTimeString(withSeconds: Int(time), andFormat: "yyyy-MM-dd HH:mm:ss")
                    var isHave = false
                    if bloodArr != nil {
                        for dictionary: [AnyHashable : Any] in bloodArr as? [[AnyHashable : Any]] ?? [] {
                            if (dictionary["StartTime"] as? String == testTime) {
                                isHave = true
                            }
                        }
                    }
                    
                    if !isHave {
                        let shrink: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 9 + 9 * i), andLength: 1)
                        let Diastole: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 10 + 9 * i), andLength: 1)
                        let heartRate: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 11 + 9 * i), andLength: 1)
                        let spo2: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 12 + 9 * i), andLength: 1)
                        let hrv: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 13 + 9 * i), andLength: 1)
                        
                        //adaLog(@"time = %d,shrink = %d,Diastole = %d,heartRate = %d,spo2 = %d, hrv= %d,",time,shrink,Diastole,heartRate,spo2,hrv);
                        let bloodPre = BloodPressureModel()
                        
                        
                        #warning("SQLdataManger 還未建立")
//                        bloodPre.bloodPressureID = String(format: "%ld", SQLdataManger.getInstance().queryBloodPressureALL())
                        bloodPre.bloodPressureID = ""
                            
                            
                            
                        bloodPre.bloodPressureDate = TimeCallManager.instance.getTimeString(withSeconds: Int(time), andFormat: "yyyy-MM-dd")
                        bloodPre.startTime = testTime
                        bloodPre.systolicPressure = "\(shrink)"
                        bloodPre.diastolicPressure = "\(Diastole)"
                        bloodPre.heartRate = "\(heartRate)"
                        bloodPre.spo2 = "\(spo2)"
                        bloodPre.hrv = "\(hrv)"
                        if dataNumber == i + 1 {
                            bloodPressure?(bloodPre)
                        }
                    }
                }
            } else if dataNumber == 1 {
                var systemTimeOffset: Int = NSTimeZone.system.secondsFromGMT()
                var time: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 4) - UInt32(systemTimeOffset)
                var testTime = TimeCallManager.instance.getTimeString(withSeconds: Int(time), andFormat: "yyyy-MM-dd HH:mm:ss")
                var isHave = false
                for dictionary: [AnyHashable : Any] in bloodArr as? [[AnyHashable : Any]] ?? [] {
                    if (dictionary["StartTime"] as? String == testTime) {
                        isHave = true
                    }
                }
                if !isHave {
                    let shrink: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 9), andLength: 1)
                    let Diastole: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 10), andLength: 1)
                    let heartRate: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 11), andLength: 1)
                    let spo2: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 12), andLength: 1)
                    let hrv: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 13), andLength: 1)
                    
                    //adaLog(@"time = %d,shrink = %d,Diastole = %d,heartRate = %d,spo2 = %d, hrv= %d,",time,shrink,Diastole,heartRate,spo2,hrv);
                    let bloodPre = BloodPressureModel()
                    
                    
                    
                    #warning("SQLdataManger 還未建立")
//                    bloodPre.bloodPressureID = String(format: "%ld", SQLdataManger.getInstance().queryBloodPressureALL())
                    bloodPre.bloodPressureID = ""
                    
                    
                    
                    bloodPre.bloodPressureDate = TimeCallManager.instance.getTimeString(withSeconds: Int(time), andFormat: "yyyy-MM-dd")
                    bloodPre.startTime = testTime
                    bloodPre.systolicPressure = "\(shrink)"
                    bloodPre.diastolicPressure = "\(Diastole)"
                    bloodPre.heartRate = "\(heartRate)"
                    bloodPre.spo2 = "\(spo2)"
                    bloodPre.hrv = "\(hrv)"
                    
                    bloodPressure?(bloodPre)
                }
            }
            blueToothManager?.answerBloodPressure()
        } else if byteout[4] == 1 {
            #if DEBUG
            print("\(#function)\n准备接收血压数据的设备应答 -- \(byteout[4])")
            #endif
        } else if byteout[4] == 2 {
            //        interfaceLog(@"准备好接收血压原始数据  bra ask %@",data);
            //直接回复。没有准备好
            
            //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //        UIViewController *vc = window.rootViewController;
            //        if(vc)
            //        {
            //            //#warning   mm_drawerController   tabbar  index
            //            //            MMDrawerController * drawerController =(MMDrawerController *)vc;
            //            //            MainTabBarController *tabBar = (MainTabBarController *) drawerController.centerViewController;
            //            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //            MainTabBarController *tabBar =tempAppDelegate.mainTabBarController;
            //            if (tabBar.selectedIndex == 3)
            //            {
            //                [self.blueToothManager answerReadyReceive:1];
            //            }
            //            else
            //            {
            blueToothManager?.answerReadyReceive(0)
            #if DEBUG
            print("\(#function)\n应答设备是否在血压界面 -- \(byteout[4])")
            #endif
            //            }
            //        }
        } else if byteout[4] == 3 {
            //        int ppgLength = byteout[5];
            //        int ecgWeizhi = ppgLength+6;
            //        int ecgLength = byteout[ecgWeizhi];
            //
            //        [self.blueToothManager receiveData:[data subdataWithRange:NSMakeRange(ecgLength+ecgWeizhi, 2)]];
            #if DEBUG
            print("\(#function)\n--    ----接收原始数据")
            #endif
            
            if byteout[5] == 1 {
                
                #if DEBUG
                print("\(#function)\n--  成功  ----接收原始数据")
                #endif
                //              adaLog(@"--  成功  ----接收原始数据");
            } else {
                #if DEBUG
                print("\(#function)\n--  失败  ----接收原始数据")
                #endif
                //              adaLog(@"--  失败  ----接收原始数据");
            }
        } else if byteout[4] == 4 {
            #if DEBUG
            print("\(#function)\n获取血压测量配置参数")
            #endif
//            adaLog("----获取血压测量配置参数")
            blueToothManager?.answerCorrectNumber()
        } else if byteout[4] == 5 {
            if byteout[5] == 1 {
                #if DEBUG
                print("\(#function)\n--  失败  ----设置血压测量配置参数")
                #endif
//                adaLog("--  成功  --设置血压测量配置参数")
            } else {
                #if DEBUG
                print("\(#function)\n--  失败  ----设置血压测量配置参数")
                #endif
//                adaLog("--  失败  --设置血压测量配置参数")
            }
            
            //        [self.blueToothManager answerCorrectNumber];
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func receivePageManager(_ data: Data?) {
        //    //adaLog(@"receivePageManager  ==  %@",data);
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var byteout = data.bytes
        
        if byteout[4] == 2 {
            //           interfaceLog(@"page 读取设备页面的配置 bra answer %@",data);
            
            let numberTwo: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 4)
            UserDefaults.standard.set(GlobalProperty.SHOWPAGEMANAGER, forKey: "\(numberTwo)")
            
            pageManager?(numberTwo)
        } else if byteout[4] == 3 {
            //         interfaceLog(@"page  APP读取设备支持的页面配置 answer %@",data);
            let number: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 4)
            UserDefaults.standard.set(GlobalProperty.SHOWPAGEMANAGER, forKey: "\(number)")
            supportPage?(number)
        } else if byteout[4] == 1 {
            //        interfaceLog(@"page 333 bra answer %@",data);
            //        //adaLog(@"设备应答：");
            //int  number = [self combineDataWithAddr:byteout + 5 andLength:4];
            //self.supportPage(number);
        }
    }
    
    /**
     *
     *      查询天气
     *
     **/
    func receiveQueryWeather(_ data: Data?) {
        /*
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var byteout = data.bytes
        let weatherID = Int(byteout.item(at: 4) ?? 0)
        //    adaLog(@"请求未来的天气。。  == %@",data);
        if (byteout.item(at: 4) ?? 0) == 1 {
            let ri: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 6), andLength: 1)
            let dict = [
                GlobalProperty.QUERYWEATHERID : intToString(weatherID),
                GlobalProperty.QUERYWEATHERRI : intToString(ri)
            ]
            HCHCommonManager.instance.queryWeatherArray.append(dict)
        } else if (byteout.item(at: 4) ?? 0) == 2 {
            let systemTimeOffset: Int = NSTimeZone.system.secondsFromGMT()
            let nums = Int(combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 3)) - systemTimeOffset as? uint
            var dayNumber: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 8), andLength: 1)
            if Int(dayNumber) > 7 {
                dayNumber = 1
            }
            let timeSeconds = TimeCallManager.instance.getYYYYMMDDSecondsSince1970(with: nums)
            let dic = [
                GlobalProperty.QUERYWEATHERID : intToString(weatherID),
                GlobalProperty. : intToString(timeSeconds),
                GlobalProperty.QUERYWEATHERDAYNUMBER : intToString(dayNumber)
            ]
            HCHCommonManager.instance.queryWeatherArray.append(dic)
        }
        PZCityTool.sharedInstance().refresh()
 */
    }
    
    /**
     *
     *      查询完成度
     *
     **/
    func receiveCompletionDegree(_ data: Data?) {

        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var byteout = data.bytes
        let code: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 4), andLength: 1)
        if Int(code) == 1 {
            //        interfaceLog(@"CompletionDegree  222   == DEV - inquiry %@",data);
            
            //        adaLog(@"target == bra ask  %@",data);
            blueToothManager?.returnCompletionDegree()
            UserDefaults.standard.set(GlobalProperty.COMPLETIONDEGREESUPPORT, forKey: "1")
        } else if Int(code) == 2 {
            #if DEBUG
            print("\(#function)\ntarget == app set 目标发送成功 \(data)")
            #endif
//            adaLog("target == app set 目标发送成功 %@", data)
            //        interfaceLog(@"CompletionDegree  222   == DEV - ansSet %@",data);
        }
    }
    
    /**
     *
     *   1 查询设备是否支持某功能
     *   2 APP查询设备能支持的参数
     **/
    func receiveCheckAction(_ data: Data?) {
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var byteout = data.bytes
        let code: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 4), andLength: 1)
        if Int(code) == 1 {
            //        adaLog(@" APP查询功能支持码    answer%@",data);
            let heartContinuity: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 1)
            let supportCode: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 6), andLength: 1)
            supportQuery(Int(heartContinuity), support: Int(supportCode))
            
            let newAlarm: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 7), andLength: 1)
            let supportCodeAlarm: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 8), andLength: 1)
            supportQuery(Int(newAlarm), support: Int(supportCodeAlarm))
            
            let weatherID: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 9), andLength: 1)
            let weatherCode: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 10), andLength: 1)
            supportQuery(Int(weatherID), support: Int(weatherCode))
        } else if Int(code) == 2 {
            //         interfaceLog(@"  APP查询设备能支持的参数 answer%@",data);
            
            let remindLength: UInt32 = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 1)
            if Int(remindLength) == 1 {
                let remind: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 6), andLength: 1)
                UserDefaults.standard.set(GlobalProperty.REMINDLENGTH, forKey: "\(remind)")
//                ADASaveDefaluts[REMINDLENGTH] = "\(remind)"
            } else if Int(remindLength) == 2 {
                let remind: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 6), andLength: 1)
                UserDefaults.standard.set(GlobalProperty.CUSTOMREMINDLENGTH, forKey: "\(remind)")
//                ADASaveDefaluts[CUSTOMREMINDLENGTH] = "\(remind)"
            }
            
            let customRemindLength: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 7), andLength: 1)
            if Int(customRemindLength) == 1 {
                let customRemind: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 8), andLength: 1)
                UserDefaults.standard.set(GlobalProperty.REMINDLENGTH, forKey: "\(customRemind)")
//                ADASaveDefaluts[REMINDLENGTH] = "\(customRemind)"
            } else if Int(customRemindLength) == 2 {
                let customRemind: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 8), andLength: 1)
                UserDefaults.standard.set(GlobalProperty.CUSTOMREMINDLENGTH, forKey: "\(customRemind)")
//                ADASaveDefaluts[CUSTOMREMINDLENGTH] = "\(customRemind)"
            }
        }
        
    }
    
    func supportQuery(_ code: Int, support supportNum: Int) {
        if code == 4 {
            //        int supportCode = [self combineDataWithAddr:byteout + 6 andLength:1];
            UserDefaults.standard.set(GlobalProperty.HEARTCONTINUITY, forKey: "\(supportNum)")
//            ADASaveDefaluts[HEARTCONTINUITY] = "\(supportNum)"
        } else if code == 5 {
            //        int supportCode = [self combineDataWithAddr:byteout + 6 andLength:1];
            UserDefaults.standard.set(GlobalProperty.NEWALARM, forKey: "\(supportNum)")
//            ADASaveDefaluts[NEWALARM] = "\(supportNum)"
        } else if code == 3 {
            UserDefaults.standard.set(GlobalProperty.WEATHERSUPPORT, forKey: "\(supportNum)")
//            ADASaveDefaluts[WEATHERSUPPORT] = "\(supportNum)"
            blueToothManager?.weatherRefresh()
        }
        
    }
    
    /**
     *
     *   FLAG: 0X01 重设消息提醒内容(UTF-8编码）的最大长度（包括电话提醒和其他消息如QQ，微信等的提醒）；  安卓的。ios不用做
     
     0X02 重设自定义提醒的最大长度（unicode编码）
     
     底层要求回复 YES  不然总是询问
     *
     **/
    func receiveCheckNewLength(_ data: Data?) {
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        //     interfaceLog(@"手环设置APP参数 bra ask %@",data);
        var byteout = data.bytes
        let code: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 4), andLength: 1)
        let remind: uint = combineData(withAddr: ToolBox.byte(&byteout, add: 5), andLength: 1)
        if Int(code) == 1 {
            UserDefaults.standard.set(GlobalProperty.REMINDLENGTH, forKey: "\(remind)")
//            ADASaveDefaluts[REMINDLENGTH] = "\(remind)"
            //查询设备支持的消息提醒最大长度
            blueToothManager?.answerBraceletSetParam(Int(code))
        } else if Int(code) == 2 {
            UserDefaults.standard.set(GlobalProperty.CUSTOMREMINDLENGTH, forKey: "\(remind)")
//            ADASaveDefaluts[CUSTOMREMINDLENGTH] = "\(remind)"
            //查询设备支持的自定义提醒的最大长度
            blueToothManager?.answerBraceletSetParam(Int(code))
        }
    }
    
    
    /**
     *  收到离线数据
     *
     *  @param data data description
     */
    func receiveOffLineData(with data: Data?) {
        
        guard let data = data else {
            #if DEBUG
            print("\(#function)\ndata is nil.")
            #endif
            return
        }
        
        var transDat = data.bytes
        let systemTimeOffset: Int = NSTimeZone.system.secondsFromGMT()
        let numberLength: uint = combineData(withAddr: ToolBox.byte(&transDat, add: 2), andLength: 2)
        if Int(numberLength) > 17 {
            if transDat[12] == 0x04 {
                var nums = combineData(withAddr: ToolBox.byte(&transDat, add: 4), andLength: 4) - UInt32(systemTimeOffset) //秒数
                let timeSeconds = TimeCallManager.instance.getYYYYMMDDSecondsSince1970(with: TimeInterval(nums)) //日期
                let start_Seconds = Int(nums)
                let startTimeSeconds = Int(nums)
                
                nums = combineData(withAddr: ToolBox.byte(&transDat, add: 8), andLength: 4) - UInt32(systemTimeOffset)
                let stopSeconds = Int(nums)
                let stopTimeSeconds = Int(nums)
                
                let sportType: UInt32 = combineData(withAddr: ToolBox.byte(&transDat, add: 13), andLength: 1) //手表已经有运动类型
                let costs: UInt32 = combineData(withAddr: ToolBox.byte(&transDat, add: 14), andLength: 4)
                let steps: UInt32 = combineData(withAddr: ToolBox.byte(&transDat, add: 18), andLength: 4)
                
                
                let sport = SportModelMap()
                //            sport.sportID = [NSString stringWithFormat:@"%ld",[[SQLdataManger getInstance] queryHeartRateDataWithAll]];
                
                
                #warning("SQLdataManger 還未建立")
//                sport.sportID = ToolBox.getSportIDMax(SQLdataManger.getInstance().queryMaxSportID())
                sport.sportID = ""
                
                
                
                sport.timeSeconds = Int(timeSeconds)
                sport.startTimeSeconds = startTimeSeconds
                sport.stopTimeSeconds = stopTimeSeconds
                sport.sportType = "\(sportType)"
                sport.sportDate = TimeCallManager.instance.getTimeString(withSeconds: Int(timeSeconds), andFormat: "yyyy-MM-dd")
                sport.fromTime = TimeCallManager.instance.getTimeString(withSeconds: start_Seconds, andFormat: "yyyy-MM-dd HH:mm:ss")
                sport.toTime = TimeCallManager.instance.getTimeString(withSeconds: stopSeconds, andFormat: "yyyy-MM-dd HH:mm:ss")
                sport.stepNumber = "\(steps)"
                sport.kcalNumber = "\(costs)"
                
                let interval = TimeCallManager.instance.getIntervalOneMin(with: Int(TimeCallManager.instance.getNowSecond()), andEndTime: HCHCommonManager.instance.queryHearRateSeconed)
                if interval > 2 {
                    PZBlueToothManager.instance.checkTodayHeartRate(withBlock: { timeSeconds, index, heartArray in
                        if HCHCommonManager.instance.requestIndex != -1 && HCHCommonManager.instance.requestIndex == index {
                            self.offLineDataModelBlock?(sport)
                            //回调数据数据
                            HCHCommonManager.instance.requestIndex = -1
                        }
                        //adaLog(@"离线数据包 index -- %d",index);
                    })
                } else {
                    offLineDataModelBlock?(sport)
                }
            }
        } else {
            if transDat.item(at: 12) == 0x01 {
                //            int systemTimeOffset= (int)[[NSTimeZone systemTimeZone] secondsFromGMT];
                //            Byte *transDat = (Byte *)[data bytes];
                //        if (transDat[12] == 0x01)
                //        {
                //        OffLineDataModel *model = [[OffLineDataModel alloc] init];
                //        model.timeSeconds = timeSeconds;
                //        model.startSeconds = start_Seconds;
                //        model.stopSeconds = stopSeconds;
                //        model.steps = steps;
                //        model.costs = costs;
                var nums = combineData(withAddr: ToolBox.byte(&transDat, add: 4), andLength: 4) - UInt32(systemTimeOffset)
                let timeSeconds: UInt32 = UInt32(TimeCallManager.instance.getYYYYMMDDSecondsSince1970(with: TimeInterval(nums)))
                let start_Seconds = nums
                let startTimeSeconds = nums
                nums = combineData(withAddr: ToolBox.byte(&transDat, add: 8), andLength: 4) - UInt32(systemTimeOffset)
                let stopSeconds = nums
                let stopTimeSeconds = nums
                let steps = combineData(withAddr: ToolBox.byte(&transDat, add: 17), andLength: 4)
                let costs = combineData(withAddr: ToolBox.byte(&transDat, add: 13), andLength: 4)
                
                let sport = SportModelMap()
                
                
                #warning("SQLdataManger 還未建立")
//                sport.sportID = ToolBox.getSportIDMax(SQLdataManger.getInstance().queryMaxSportID())
                sport.sportID = ""
                
                
                
                sport.timeSeconds = Int(timeSeconds)
                sport.startTimeSeconds = Int(startTimeSeconds)
                sport.stopTimeSeconds = Int(stopTimeSeconds)
                sport.sportType = "1000"
                sport.timeSeconds = Int(timeSeconds)
                sport.sportDate = TimeCallManager.instance.getTimeString(withSeconds: Int(timeSeconds), andFormat: "yyyy-MM-dd")
                sport.fromTime = TimeCallManager.instance.getTimeString(withSeconds: Int(start_Seconds), andFormat: "yyyy-MM-dd HH:mm:ss")
                sport.toTime = TimeCallManager.instance.getTimeString(withSeconds: Int(stopSeconds), andFormat: "yyyy-MM-dd HH:mm:ss")
                sport.stepNumber = "\(steps)"
                sport.kcalNumber = "\(costs)"
                
                let interval = TimeCallManager.instance.getIntervalOneMin(with: Int(TimeCallManager.instance.getNowSecond()), andEndTime: HCHCommonManager.instance.queryHearRateSeconed)
                if interval > 2 {
                    PZBlueToothManager.instance.checkTodayHeartRate(withBlock: { timeSeconds, index, heartArray in
                        if HCHCommonManager.instance.requestIndex != -1 && HCHCommonManager.instance.requestIndex == index {
                            self.offLineDataModelBlock?(sport)
                            //回调数据数据
                            HCHCommonManager.instance.requestIndex = -1
                        }
                        //adaLog(@"离线数据包 index -- %d",index);
                    })
                } else {
                    offLineDataModelBlock?(sport)
                }
            }
        }
        
    }
    
    
    /**
     public static byte[] int2Byte_LH(int a) {
     byte[] b = new byte[4];
     b[3] = (byte) (a >> 24);
     b[2] = (byte) (a >> 16);
     b[1] = (byte) (a >> 8);
     b[0] = (byte) (a);
     return b;
     }
     
     public static int byte2Int(byte[] b, int offset) {
     return ((b[offset++] & 0xff)) | ((b[offset++] & 0xff) << 8)
     | ((b[offset++] & 0xff) << 16) | ((b[offset++] & 0xff) << 24);
     }
     
     **/
    func getRepeatStatus(withArray repeatArray: [Int]) -> Int {
        var status: Int = 0
        for i in 0..<7 {
            if repeatArray.item(at: i) != nil {
                status = status | (0x01 << (i))
            }
        }
        return status
    }
    
    func replaceUnicode(_ unicodeStr: String?) -> String? {
        let tempStr1 = unicodeStr?.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1?.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"" + (tempStr2 ?? "") + ("\"")
        let tempData: Data? = tempStr3.data(using: .utf8)
        var returnStr: String? = nil
        if let tempData = tempData {
            try? returnStr = PropertyListSerialization.propertyList(from: tempData, options: [], format: nil) as? String
        }
        return returnStr?.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    func transToUnicodString(with string: String?) -> String? {
        var resultStr = String(repeating: "\0", count: 0)
        for i in 0..<(string?.count ?? 0) / 4 {
            var mutString = String(repeating: "\0", count: 0)
            let range = NSRange(location: 4 * i, length: 4)
            let cString = (string as NSString?)?.substring(with: range)
            mutString += (cString as NSString?)?.substring(with: NSRange(location: 2, length: 2)) ?? ""
            mutString += (cString as NSString?)?.substring(with: NSRange(location: 0, length: 2)) ?? ""
            resultStr += "\\u"
            resultStr += mutString
        }
        return resultStr
    }
    
    // MARK: -- 内部调用方法
    @objc func reSendUpdataData() {
        blueToothManager?.updateHardWaer(withPack: packNumber)
        perform(#selector(self.reSendUpdataData), with: nil, afterDelay: 2)
    }
    
    @objc func upDateFaile() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reSendUpdataData), object: nil)
        
        updateFailureBlock?(1)
    }
    
    // MARK: -- 全局变量get方法
//    func bluetoothScan() -> BluetoothScan? {
//        if blueToothScan == nil {
//            self.blueToothScan = BluetoothScan()
//        }
//        return self.blueToothScan
//    }
    
//    func blueToothManager() -> BlueToothManager? {
//        if !blueToothManager {
//            blueToothManager = BlueToothManager() // [BlueToothManager getInstance];
//        }
//        return blueToothManager
//    }
}



