//
//  CositeaBlueTooth.swift
//  hncloud
//
//  Created by Hong Shih on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift

class CositeaBlueTooth: NSObject {
    
    
    private var _cositeaBlueToothManager: CositeaBlueToothManager?
    private var cositeaBlueToothManager: CositeaBlueToothManager? {
        if _cositeaBlueToothManager == nil {
            _cositeaBlueToothManager = CositeaBlueToothManager()
            setBlocks()
        }
        
        return _cositeaBlueToothManager
    }
    
    func setBlocks() {
        connectStateChanged(withBlock: { [weak self] isConnect, peripheral in
            
            if isConnect, let deviceName = peripheral?.name, let connectUUID = peripheral?.identifier.uuidString {
                self?.deviceName = deviceName
                self?.connectUUID = connectUUID
                UserDefaults.standard.set(GlobalProperty.kLastDeviceNAME, forKey: deviceName)
                UserDefaults.standard.set(GlobalProperty.kLastDeviceUUID, forKey: connectUUID)
            } else {
                self?.deviceName = nil
                self?.connectUUID = nil
            }
            self?.isConnected = isConnect
            self?.connectState?(isConnect.int)
        })
    }

    
    
    
    static let instance = CositeaBlueTooth()
    
    
    
    
// MARK: -- 属性
    /**
     *  蓝牙连接状态，YES为已连接，NO为未连接
     */
    var isConnected = false
    /**
     *  蓝牙连接状态，YES为已连接，NO为未连接   intBlock   block
     */
    var connectState: intBlock?
    /**
     *  状态为已连接时，值为已连接设备的UUID，此UUID可用于连接设备和断开设备
     状态为未连接时，值为nil
     */
    var connectUUID: String? = ""
    /**
     *  状态为已连接时，值为已连接设备的设备名称
     状态为未连接时，值为nil
     */
    var deviceName: String? = ""

// MARK:   --    蓝牙模块(发送蓝牙指令)
// MARK: -- 获取对象方法
    /**
     *  获取蓝牙管理对象
     *
     *  @return 蓝牙管理的对象
     */
//    class func sharedInstance() -> CositeaBlueTooth? {
//    }

// MARK: -- 扫描设备方法
    /**
     *  蓝牙扫描设备的方法，block返回的为扫描到的设备的数组，数组里的内容为PerModel,此block会多次执行，每次返回的数组都会更新
     *
     *  @param deviceArrayBlock 返回设备列表数组
     */
    func scanDevices(with deviceArrayBlock: @escaping arrayBlock) {
        cositeaBlueToothManager?.scanDevices(with: deviceArrayBlock)
    }

    /*
     *停止扫描设备
     **/
    func stopScanDevice() {
        cositeaBlueToothManager?.stopScanDevice()
    }

// MARK: -- 连接蓝牙方法

    /**
     *  根据UUID连接设备
     *
     *  @param UUID 要连接设备的UUID，NSString格式，此方法不提供连接是否成功的判断，请用下方监测蓝牙连接状态方法来监测连接成功或设备断开
     
     */
    func connect(withUUID UUID: String?) {
        cositeaBlueToothManager?.connect(withUUID: UUID)
    }

// MARK: -- 监测蓝牙状态变化方法
    //变化后通知上层
    /**
     *  实现此方法可以监测蓝牙连接状态变化
     *
     *  @param stateChanged block传递为一个int值，1为设备已连接，0为设备已断开
     */
    func connectedStateChanged(with stateChanged: @escaping intBlock) {
        connectState = stateChanged
    }
    
    // 下层变化监测
    func connectStateChanged(withBlock connectStateBlock: @escaping connectStateChanged) {
        cositeaBlueToothManager?.connectStateChanged(withBlock: connectStateBlock)
    }

// MARK: -- 断开蓝牙方法
    /**
     *  断开蓝牙方法
     *
     *  @param UUID 当前连接设备的UUID
     */
    func disConnected(withUUID UUID: String?) {
        cositeaBlueToothManager?.disConnected(withUUID: UUID)
    }
    
    //#pragma mark -- 蓝牙发送数据方法
// MARK:   --   设置模块(发送命令指令，例如同步时间)


    /**
     *
     * app与手环的时间同步
     *
     */
    func synsCurTime() {
        cositeaBlueToothManager?.synsCurTime()
    }

    /**
     *
     * 同步语言。支持中，英，泰。不是这三种语言。就是英文
     *
     */
    func setLanguage() {
        cositeaBlueToothManager?.setLanguage()
    }

    /**
     *
     * 发送手环的显示日期的格式 日月
     *
     */
    func sendBraMMDDformat() {
        cositeaBlueToothManager?.sendBraMMDDformat()
    }

    /**
     *
     * 读取信息提醒的支持
     *
     */
    func checkInformation() {
        cositeaBlueToothManager?.checkInformation()
    }

    /**
     *
     * app设置手环的公制/英制    NO:公制     YES:英制
     *
     */
    func setUnitStateWithState(_ state: Bool) {
        cositeaBlueToothManager?.setUnitStateWithState(state)
    }

    /**
     *
     * app设置手环的时间是12小时制或24小时制
     *  NO:12小时制    YES:24小时制
     */
    func setBindDateStateWithState(_ state: Bool) {
        cositeaBlueToothManager?.setBindDateStateWithState(state)
    }

    /**
     *  检查手环电量
     *
     *  @param PowerBlock block返回一个int参数，值为当前电量值 电池电量：0-100
     */
    func checkBandPower(withPowerBlock PowerBlock: @escaping intBlock) {
        cositeaBlueToothManager?.checkBandPower(withPowerBlock: PowerBlock)
    }

    /**
     *
     * 拍照功能  - 开关
     * YES - 打开拍照  NO - 关闭拍照
     */
    func changeTakePhotoState(_ state: Bool) {
        cositeaBlueToothManager?.changeTakePhotoState(state)
    }

    //接受到拍照指令
    func recieveTakePhotoMessage(_ takePhotoBlock: @escaping intBlock) {
        self.cositeaBlueToothManager?.recieveTakePhotoMessage(takePhotoBlock)
    }

    /**
     开启找手环功能
     
     @param openFindBindBlock 返回为int值，为1则为成功
     */
    func openFindBind(with openFindBindBlock: @escaping intBlock) {
        cositeaBlueToothManager?.openFindBind(with: openFindBindBlock)
    }

    /**
     关闭找手环功能
     
     @param closeFindBindBlock 返回为int值，为1则为成功
     */
    func closeFindBind(with closeFindBindBlock: @escaping intBlock) {
        cositeaBlueToothManager?.closeFindBind(with: closeFindBindBlock)
    }

    /**
     *
     *清除手环数据
     *
     */
    func resetBind(with resetBindBlock: intBlock?) {
        cositeaBlueToothManager?.resetBind(with: resetBindBlock)
    }

    /**
     *
     *检查手环版本
     *
     */
    func checkVerSion(with versionBlock: @escaping versionBlock) {
        cositeaBlueToothManager?.checkVerSion(with: versionBlock)
    }

    /**
     *  开启实时心率
     *
     *  @param heartRateBlock block传递一个int值为心率值，开启实时心率后，block会每秒执行一次，返回当前心率值
     */
    func openActualHeartRate(withBolock heartRateBlock: @escaping intBlock) {
        cositeaBlueToothManager?.openActualHeartRate(withBolock: heartRateBlock)
    }

    /**
     *  关闭实时心率
     */
    func closeActualHeartRate() {
        cositeaBlueToothManager?.closeActualHeartRate()
    }

    /**
     *
     *设置自定义闹铃
     *
     */
    func setAlarmWith(_ model: CustomAlarmModel?) {
        cositeaBlueToothManager?.setAlarmWith(model)
    }

    /**
     *
     *查询自定义闹铃
     *
     */
    func checkAlarm(with alarmModelBlock: @escaping alarmModelBlock) {
        cositeaBlueToothManager?.checkAlarm(with: alarmModelBlock)
        //[self.cositeaBlueToothManager chekAlarmWithBlock:alarmModelBlock];
    }

    /**
     *
     * 删除自定义闹铃
     * index = 固定编号，提醒个数最大为8
     */
    func deleteAlarm(withAlarmIndex index: Int) {
        cositeaBlueToothManager?.deleteAlarm(withAlarmIndex: index)
    }

    /**
     *
     * 心率监控间隔 - 心率自动监控开关 -查询
     *
     */
    func checkHeartTateMonitorwithBlock(_ heartRateMonitorBlock: @escaping doubleInt) {
        cositeaBlueToothManager?.checkHeartTateMonitorwithBlock(heartRateMonitorBlock)
    }

    /**
     *
     * 心率自动监控开关 -  设置
     NO：关闭    YES：开启
     *
     */
    func changeHeartRateMonitorState(withState state: Bool) {
        cositeaBlueToothManager?.changeHeartRateMonitorState(withState: state)
    }

    /**
     *
     * 心率监控间隔 -- 设置 -- 常常设置30分钟或60分钟
     *单位分钟：最小值5分钟，最大值60分钟； 若为0X01, 表示连续心率监测(注：目前大部分设备不支持连续心率监测）
     */
    func setHeartRateMonitorDurantionWithTime(_ Minutes: Int) {
        cositeaBlueToothManager?.setHeartRateMonitorDurantionWithTime(Minutes)
    }

    /**
     *
     *  心率预警 - 读取
     *
     */
    func checkHeartRateAlarm(with heartRateAlarmBlock: @escaping heartRateAlarmBlock) {
        cositeaBlueToothManager?.checkHeartRateAlarm(with: heartRateAlarmBlock)
    }

    /**
     *
     * 心率预警 - 设置
     * NO：启动 YES：关闭
     */
    func setHeartRateAlarmWithState(_ state: Bool, maxHeartRate max: Int, minHeartRate min: Int) {
        cositeaBlueToothManager?.setHeartRateAlarmWithState(state, maxHeartRate: max, minHeartRate: min)
    }


    /**
     *
     * 固件升级
     *
     */
    func updateBindROM(withRomUrl romURL: String?, progressBlock: @escaping floatBlock, successBlock success: @escaping intBlock, failureBlock failure: @escaping intBlock) {
        cositeaBlueToothManager?.updateBindROM(withRomUrl: romURL, progressBlock: progressBlock, successBlock: success, failureBlock: failure)
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
        cositeaBlueToothManager?.sendUserInfoToBind(withHeight: height, weight: weight, male: male, age: age)
    }

    /**
     *
     * 查询设备是否支持某功能
     *
     */
    func checkAction() {
        cositeaBlueToothManager?.checkAction()
    }

    /**
     *
     * APP查询设备能支持的参数
     *
     */
    func checkParameter() {
        cositeaBlueToothManager?.checkParameter()
    }

// MARK:   --   功能模块(发送数据指令）

    /**
     *
     *读取对应的提醒状态
     *
     */
    func checkSystemAlarm(withType type: SystemAlarmType, stateBlock systemAlarmBlock: @escaping doubleInt) {
        cositeaBlueToothManager?.checkSystemAlarm(withType: type, stateBlock: systemAlarmBlock)
    }

    /**
     *
     *  设置对应的提醒状态
     *  state =  NO：关 YES：开
     */
    func setSystemAlarmWithType(_ type: SystemAlarmType, state: Int) {
        cositeaBlueToothManager?.setSystemAlarmWithType(type, state: state)
    }

    /**
     *
     * 电话提醒延时功能 - 查询
     *
     */
    func checkPhoneDealay(with phoneDealayBlock: @escaping intBlock) {
        cositeaBlueToothManager?.checkPhoneDealay(with: phoneDealayBlock)
    }

    /**
     *
     * 电话提醒延时功能 - 设置
     * 延时时间：秒为单位 Seconds --- 常常设置为 立即，5秒，10秒
     */
    func setPhoneDelayWithDelaySeconds(_ Seconds: Int) {
        cositeaBlueToothManager?.setPhoneDelayWithDelaySeconds(Seconds)
    }

    /**
     发送运动目标和睡眠目标
     */
    func activeCompletionDegree() {
        cositeaBlueToothManager?.activeCompletionDegree()
    }

// MARK:   --   获取手环数据模块(例如步数)

    /**
     *  获取当天全天数据概览
     *
     *  @param dayTotalDataBlock block内返回当天数据的DayOverViewDataModel,详情请进入model查看。
     */
    func chekCurDayAllData(with dayTotalDataBlock: @escaping allDayModelBlock) {
        cositeaBlueToothManager?.chekCurDayAllData(with: dayTotalDataBlock)
    }

    /**
     *  查询每小时步数及卡路里消耗
     *
     *  @param dayHourDataBlock 返回步数数组，共24小时每小时步数 卡路里消耗数组，24小时每小时消耗，timeSeconds 当天时间秒数
     */
    func checkHourStepsAndCosts(with dayHourDataBlock: @escaping doubleArrayBlock) {
        cositeaBlueToothManager?.checkHourStepsAndCosts(with: dayHourDataBlock)
    }

    /**
     查看今天睡眠数据
     
     @param sleepStateArrayBlock 返回sleepModel,此接口只返回今天0点以后数据，需要截取前天历史睡眠数据进行拼接成完整睡眠数据
     */
    func checkTodaySleepState(with sleepStateArrayBlock: @escaping sleepModelBlock) {
        cositeaBlueToothManager?.checkTodaySleepState(with: sleepStateArrayBlock)
    }

    /**
     查看当天心率数据
     
     @param heartRateArrayBlock 心率数据返回三个值，1、今天的时间，已秒数格式返回，2、心率包序号（1-8），3、心率数组。心率数据每分钟一个值，没有值为0，全天心率1440分钟，分为8个包，每个包为3个小时数据，用包序号区分。查询当天心率会查询从0点到当前时间的心率值，此block最多会执行8次，每次返回的数组为180个值，用包序号来确定具体时间。
     */
    func checkTodayHeartRate(with heartRateArrayBlock: @escaping doubleIntArrayBlock) {
        cositeaBlueToothManager?.checkTodayHeartRate(with: heartRateArrayBlock)
    }

    /**
     查询HRV值
     
     @param HRVDataBlock 返回内容有两个，1、今天时间 2、HRV值数组，共24个值，为每小时HRV，没有值则为0 HRV取值范围为0-100，表示当前用户疲劳状态。值越低表示越疲劳，100则表示充满活力
     */
    func checkHRV(withHRVBlock HRVDataBlock: @escaping intArrayBlock) {
        cositeaBlueToothManager?.checkHRV(withHRVBlock: HRVDataBlock)
    }

    /**
     *
     * 久坐提醒功能 - 查询
     *
     */
    func checkSedentary(withSedentaryBlock sedentaryArrayBlock: @escaping arrayBlock) {
        cositeaBlueToothManager?.checkSedentary(withSedentaryBlock: sedentaryArrayBlock)
    }

    /**
     *
     * 久坐提醒功能 - 设置
     *
     */
    func setSedentaryWith(_ sedentaryModel: SedentaryModel?) {
        cositeaBlueToothManager?.setSedentaryWith(sedentaryModel)
    }

    /**
     *
     * 久坐提醒功能 - 删除
     *   index久坐提醒的编号
     */
    func deleteSedentaryAlarm(with index: Int) {
        cositeaBlueToothManager?.deleteSedentaryAlarm(with: index)
    }

// MARK: -- ada 写

    /**
     *打开心率的命令
     *
     */
    func openHeartRate(_ startSportBlock: @escaping startSportBlock) {
        cositeaBlueToothManager?.openHeartRate(startSportBlock)
    }

    /**
     *
     *定时获取心率以及运动数据
     *
     */
    func timerGetHeartRateData(_ timerGetHeartRate: @escaping timerGetHeartRate) {
        cositeaBlueToothManager?.timerGetHeartRateData(timerGetHeartRate)
    }

    /**
     *
     *close   心率的命令
     *
     */
    func closeHeartRate(_ closeSportBlock: @escaping intBlock) {
        cositeaBlueToothManager?.closeHeartRate(closeSportBlock)
    }

    /**
     *
     *    获取血压的数据
     *
     */
    func getBloodPressure(_ bloodPressure: @escaping bloodPressure) {
        cositeaBlueToothManager?.getBloodPressure(bloodPressure)
    }

    /**
     *
     * 检查是否提示了
     *
     */
    func checkConnectTimeAlert(_ TimeAlert: @escaping intBlock) {
        cositeaBlueToothManager?.checkConnectTimeAlert(TimeAlert)
    }

    /**
     *
     * 检查蓝牙开关
     *
     */
    func checkCBCentralManagerState(_ BlueToothState: @escaping bluetoothState) {
        cositeaBlueToothManager?.checkCBCentralManagerState(BlueToothState)
        
    }

    /**
     *
     * 读取页面管理
     *
     */
    func checkPageManager(_ pageManager: @escaping uintBlock) {
        cositeaBlueToothManager?.checkPageManager(pageManager)
    }

    /**
     *
     *页面管理 -- 支持那些页面
     *
     */
    func supportPageManager(_ page: @escaping uintBlock) {
        cositeaBlueToothManager?.supportPageManager(page)
    }

    /**
     *
     *   set  页面管理
     *
     */
    func setupPageManager(_ pageString: uint) {
        cositeaBlueToothManager?.setupPageManager(pageString)
    }
    
    /**
     *
     *发送天气
     *
     */
    func sendWeather(_ weather /*发送天气 */: PZWeatherModel?) {
        cositeaBlueToothManager?.sendWeather(weather)
    }

    /**
     *
     *发送未来几天天气
     *
     */
    func sendWeatherArray(_ weatherArr: [AnyHashable]?, day: Int, number /*发送未来几天天气 */: Int) {
        let weatherArr = weatherArr
        cositeaBlueToothManager?.sendWeatherArray(weatherArr, day: day, number: number)
    }

    /**
     *
     *发送某天天气   今天
     *
     */
    func sendOneDayWeather(_ weather /*发送某天天气   今天 */: PZWeatherModel?) {
        cositeaBlueToothManager?.sendOneDayWeather(weather)
    }
    
    /**
     *
     *发送某天天气   某天   < 6
     *
     */
    func sendOneDayWeatherTwo(_ weather /*发送某天天气   某天   < 6 */: WeatherDay?) {
        cositeaBlueToothManager?.sendOneDayWeatherTwo(weather)
    }

    /**
     *
     * 告诉设备，是否准备接收数据
     *
     */
    func readyReceive(_ number: Int) {
        cositeaBlueToothManager?.readyReceive(number)
    }

    /**
     *
     * 设置设备， 校正值   APP设置血压测量配置参数
     *
     */
    func setupCorrectNumber() {
        cositeaBlueToothManager?.setupCorrectNumber()
    }

// MARK: -- 手环端上传离线数据，历史数据

// MARK: -- 此处方法必须实现用来接收数据，手环端主动上传的数据如历史数据，离线运动数据等，只有实现下列方法才能接收，手环端只上传一次，所以需要在入口类或者全局存在的单例类实现下列方法，对手环上传的数据进行处理保存。
// MARK: -- 蓝牙接收数据方法
    /**
     *  接收离线数据
     *
     *  @param offLineDataBlock block传递参数为OffLineDataModel
     */
    func recieveOffLineData(withBlock offLineDataBlock: @escaping offLineDataModel) {
        cositeaBlueToothManager?.recieveOffLineData(withBlock: offLineDataBlock)
    }

    /**
     *  收到全天概览历史数据，可以接收后保存或上传服务器
     *
     *  @param historyAllDayDataBlock 返回DayOverViewDataModel
     */
    func recieveHistoryAllDayData(with historyAllDayDataBlock: @escaping allDayModelBlock) {
        cositeaBlueToothManager?.recieveHistoryAllDayData(with: historyAllDayDataBlock)
    }

    /**
     接收历史每小时计步和消耗
     
     @param historyHourDataBlock 同查询当天计步和消耗
     */
    func recieveHistoryHourData(with historyHourDataBlock: @escaping doubleArrayBlock) {
        cositeaBlueToothManager?.recieveHistoryHourData(with: historyHourDataBlock)
    }

    /**
     接收历史睡眠数据
     
     @param historySleepDataBlock 同查询当天睡眠数据
     */
    func recieveHistorySleepData(with historySleepDataBlock: @escaping sleepModelBlock) {
        cositeaBlueToothManager?.recieveHistorySleepData(with: historySleepDataBlock)
    }

    /**
     接收历史心率
     
     @param historyHeartRateBlock 格式同查询当天心率
     */
    func recieveHistoryHeartRate(with historyHeartRateBlock: @escaping doubleIntArrayBlock) {
        cositeaBlueToothManager?.recieveHistoryHeartRate(with: historyHeartRateBlock)
    }

    /**
     接收历史HRV数据
     
     @param historyHRVDataBlock 格式同查询当天历史数据
     */
    func recieveHistoryHRVData(with historyHRVDataBlock: @escaping intArrayBlock) {
        cositeaBlueToothManager?.recieveHistoryHRVData(with: historyHRVDataBlock)
    }

// MARK:   - - 连接蓝牙刷新 的方法
    func coreBlueRefresh() {
        cositeaBlueToothManager?.coreBlueRefresh()
    }
    
    

}
