//
//  SQLdataManager.swift
//  hncloud
//
//  Created by Hong Shih on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

/*
let UserInfoTable_SQL = "UserInfoTable"
let ShowInfoTable_SQL = "ShowInfoTable"
let StoreContentTypeKey = "StoreContentTypeKey"
let SQL_ContentKey = "content"


enum SQLTalbeNameEnum : Int {
    //SQLTalbeName_Start = 0 ,
    //Language_English_Table,//语言表
    //SleepData_Table,//睡眠数据
    //SleepHeartRate_Table,//睡眠心率数据
    //ActualHeartRateData_Table,//实时心率数据
    //ActualSpeedData_Table,//实时运动强度数据
    //SleepTimeData_Table,//睡眠数据起始时间开始时间表
    //ACtualTimeData_Table,//实时数据起始时间开始时间表

    case personInfo_Table = 1 //个人信息
    case dayTotalData_Table //天数据总览
    case bloodPressure_Table //血压数据表
    case peripheral_Table //外设的表  。。那些外设连接进来了。就保存数据库
    case weather_Table //天气表  存储天气的内容  ..自定义建表
}




let SQLfileName = "person.sqlite"
let InitTableAction = 1
let WriteTableAction = 2
let WriteTable_Dictionary = 3
let ReadTableAction = 5

class SQLdataManger: NSObject {
    
    private var sqlDataPath = ""
    private var contentArray: [Any] = []
    private var resourceDataPath = ""
    
    let Int_Type_SQL = "1"
    let Long_Type_SQL = "2"
    let DateTime_Type_SQL = "3"
    let Double_Type_SQL = "4"
    
//        #define Char_Type_SQL(x,y) [self getCharTypeSQLWithLength:x default:y]
//        #define Nvarchar_Type_SQL(x,y) [self getNvarcharTypeSQLWithLength:x default:y]
//        #define Varchar_Type_SQL(x,y) [self getVarcharTypeSQLWithLength:x default:y]


    class func getInstance() -> SQLdataManger? {
    }

    class func clearInstance() {
    }

    func createTable() {
    }

    func deleteTabel() {
    }

    func updateSqlite() {
    }

    //在指定表中插入批量数据
    func insertMoreData(toTable tableName: SQLTalbeNameEnum, withData transArray: [Any]?) -> Bool {
    }

    //在指定表中插入一条数据
    func insertSignalData(toTable tableName: SQLTalbeNameEnum, withData transDic: [AnyHashable : Any]?) -> Bool {
    }

    //删除指定表的内容
    func deleteTableInfo(withTableName talbeName: SQLTalbeNameEnum) {
    }

    //- (NSString *)queryEnglishLanguageWithChinese:(NSString *)chinese;

    //获取当前用户信息
    func getCurPersonInf() -> [AnyHashable : Any]? {
    }

    //根据日期获取天总数据
    func getTotalData(with date: Int) -> [AnyHashable : Any]? {
    }

    /*
     *根据系统的uuid的唯一标记符。取得macAddress
     *
     *
     */
    func getPeripheralWith(_ uuid: String?) -> [AnyHashable : Any]? {
    }

    /**
     
     上传数据查询 , ,获取天总数据
     日期 ，上传标记
     */
    func getTotalDataWith(toUp date: Int, isUp: String?) -> [AnyHashable : Any]? {
    }

    func queryDayTotalData(with year: Int, weekIndex week: Int) -> [Any]? {
    }

    //通过日期查询血压数据
    func queryBloodPressure(withDay time: String?) -> [Any]? {
    }

    /**
     *
     *上传数据查询
     *日期 ，上传标记
     *通过日期查询血压数据
     */
    func queryBloodPressureWithDay(toUp time: String?, isUp: String?) -> [Any]? {
    }

    // 查询血压数据 总数／／
    func queryBloodPressureALL() -> Int {
    }

    // 查询外设数据 总数／／
    func queryPeripheralALL() -> Int {
    }

    //在线运动 -- 总数据
    func queryHeartRateDataWithAll() -> Int {
        
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let sql = "select * from ONLINESPORT"
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        return mutArray.count
    }

    //在线运动  求最大的id
    func queryMaxSportID() -> [AnyHashable]? {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let sql = "select sportID from ONLINESPORT"
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                let sport = dic?["sportID"] as? String
                mutArray.append(sport ?? "")
            }
        })
        return mutArray
        
    }

    // 查询开始时间。是否有这个运动了
    func queryHeartRateData(withFromtime fromTime: String?) -> [Any]? {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let deviceType = String(format: "%03d", Int(ADASaveDefaluts[AllDEVICETYPE] ?? 0))
            let sql = "select * from ONLINESPORT where fromTime = '\(fromTime ?? "")'  and \(DEVICETYPE) = '\(deviceType)'"
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                let sport = SportModelMap.valueWithDictionary = dic
                mutArray.append(sport)
            }
        })
        return mutArray
    }

    /**
     
     查询表内所有数据
     */
    func queryALLData(withTable talbeName: SQLTalbeNameEnum) -> [Any]? {
    }

// MARK:   --- 建表
    //*创建表单
    func createTableTwo() {
    }

    //*建表
    func createTableName(_ name: String?, primaryKey key: String?, type: String?, otherColumn dict: [AnyHashable : Any]?) {
        //在线运动
        //建立数据库
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
            var sql = "CREATE TABLE IF NOT EXISTS \(name ?? "")(\(key ?? "") \(type ?? "") PRIMARY KEY"
            for columnName: String? in dict as? [String?] ?? [:] {
                sql = sql + (",\(columnName ?? "") \(dict?[columnName ?? ""])")
            }
            sql = sql + (");")
            let res = db?.executeUpdate(sql)
            if res ?? false {
                //dataLog(@"运动 表  success");
                //            ////adaLog(@"Two   error when creating db table");
            } else {
                //dataLog(@"运动 表  fail");
                //            ////adaLog(@"Two   succ to creating db table");
            }
        })
        
    }
    //在线运动
    //*插入数据
    func insertData(withColumns dic: [AnyHashable : Any]?, toTableName tableName: String?) {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let columnNames = dic?.keys.joined(separator: ",")
            var xArray: [AnyHashable] = []
            for i in 0..<dic?.keys.count() ?? 0 {
                xArray.append("?")
            }
            let valueStr = xArray.joined(separator: ",")
            let sql = "INSERT INTO \(tableName ?? "")(\(columnNames ?? "")) VALUES(\(valueStr));"
            ////adaLog(@"sql==%@",sql);
            let res = db?.executeUpdate(sql, withArgumentsInArray: dic?.allValues)
            if !(res ?? false) {
                ////adaLog(@"insert   error ");
            } else {
                ////adaLog(@"insert   succ ");
            }
        })
    }

    //*插入于覆盖记录
    func replaceData(withColumns dic: [AnyHashable : Any]?, toTableName tableName: String?) {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let columnNames = dic?.keys.joined(separator: ",")
            var xArray: [AnyHashable] = []
            for i in 0..<dic?.keys.count() ?? 0 {
                xArray.append("?")
            }
            let valueStr = xArray.joined(separator: ",")
            let sql = "REPLACE INTO \(tableName ?? "")(\(columnNames ?? "")) VALUES(\(valueStr));"
            
            ////adaLog(@"sql==%@",sql);
            let res = db?.executeUpdate(sql, withArgumentsInArray: dic?.allValues)
            if res ?? false {
                adaLog("REPLACE   succ ")
            } else {
                adaLog("REPLACE   error ")
            }
        })
    }

    //在线运动
    func queryHeartRateData(withDate Date: String?) -> [Any]? {
        
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let deviceType = String(format: "%03d", Int(ADASaveDefaluts[AllDEVICETYPE] ?? 0))
            let sql = "select * from ONLINESPORT where sportDate = '\(Date ?? "")' and \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(DEVICETYPE) = '\(deviceType)'"
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                let sport = SportModelMap.valueWithDictionary = dic
                mutArray.append(sport)
            }
        })
        return mutArray
        
    }

    func deleteData(withTableName tableName: String?) {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            
            let sql = "Delete from \(tableName ?? "") where 1 = 1"
            if db?.executeUpdate(sql) != nil {
                ////adaLog(@"Delete %@ s uccess" , tableName ) ;
            } else {
                ////adaLog(@"delete %@ failed" , tableName);
            }
        })
    }

    //在线运动 -- 总数据
    //- (BOOL)deleteHeartRateDataWithSportID:(NSString *)sportIDNumber;
    //*删除数据
    func deleteData(withColumns dic: [AnyHashable : Any]?, fromTableName tableName: String?) {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            var sql = "DELETE FROM \(tableName ?? "")"
            var isFirst = true
            for key: String? in dic as? [String?] ?? [:] {
                if isFirst {
                    sql = sql + (" WHERE ")
                    isFirst = false
                } else {
                    sql = sql + (" AND ")
                }
                sql = sql + ("\(key ?? "")=?")
            }
            sql = sql + (";")
            if db?.executeUpdate(sql, withArgumentsInArray: dic?.allValues) != nil {
                ////adaLog(@"Delete %@  success" , tableName ) ;
            } else {
                ////adaLog(@"delete %@ failed" , tableName);
            }
        })
    }

    /**
     
     上传数据查询
     日期 ，上传标记
     */
    func queryHeartRateDataWithDate(toUp Date: String?, isUp: String?) -> [Any]? {
        
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let deviceType = String(format: "%03d", Int(ADASaveDefaluts[AllDEVICETYPE] ?? 0))
            let sql = "select * from ONLINESPORT where sportDate = '\(Date ?? "")' and \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(ISUP) != '\(isUp ?? "")' and \(DEVICETYPE) = '\(deviceType)'"
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                let sport = SportModelMap.valueWithDictionary = dic
                mutArray.append(sport)
            }
        })
        return mutArray
        
    }

    /**
     插入一个运动数组
     */
    func insertMostSport(_ array: [Any]?) {
        for i in 0..<(array?.count ?? 0) {
            let dic = (array?[i] as? SportModelMap)?.modelToStorageDictionary()
            var dict = dic
            if dict["sportID"] == nil {
                let str = String(format: "%ld", SQLdataManger.getInstance().queryHeartRateDataWithAll())
                dict["sportID"] = str
                replaceData(withColumns: dict, toTableName: ONLINESPORT)
            } else {
                replaceData(withColumns: dict, toTableName: ONLINESPORT)
            }
        }
        
    }

    /**
     插入一个血压数组
     */
    func insertMostBlood(_ array: [Any]?) {
        for dict: [AnyHashable : Any]? in array as? [[AnyHashable : Any]?] ?? [] {
            let dic = BloodPressureModel.toStorageDict(dict)
            replaceData(withColumns: dic, toTableName: "BloodPressure_Table")
        }
    }

    func getAllTotalData() -> [Any]? {
    }

    //今天天气
    func queryWeather() -> [AnyHashable : Any]? {
        
        var dict: [AnyHashable : Any] = [:]
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let sql = "select * from Weather_Table where weatherId = 1"
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    dict = dic
                }
            }
        })
        return dict
    }

/**
 
 上传 成功   更新数据
 日期 ，上传标记
 */
//- (void)updataTotalDataTableWithDic:(NSDictionary *)dic;

//根据开始时间和结束时间获取心率数据
//- (NSArray *)querySleepHeartWithStartTime:(int)startTime andEndTime :(int)endTime;
//根据开始时间和结束时间获取实时数据心率数据
//- (NSArray *)queryHeartRateWithStartTime:(int)startTime andEndTime :(int)endTime;
//根据开始时间和结束时间获取实时运动强度数据
//- (NSArray *)querySpeedWithStartTime:(int)startTime andEndTime :(int)endTime;
//根据开始时间获取睡眠数据
//- (NSArray *)querySleepDataWithStartTime:(int)date;

//- (NSArray *)querySleepDataWithDayTime:(int)date;

//- (NSArray *)querySleepTimeList;

//- (NSArray *)queryActualTimeListWithType:(int)type;

//- (NSArray *)queryAllActualSpeedDataWithDay:(int) time;

//- (NSArray *)queryActualTimeListWithDay:(int) time;

//- (NSArray *)querySleepTimeListWithDay:(int)dayTime;

//- (NSArray *)queryAllSleepHeart;



    
    
    deinit {
        contentArray = nil
        sqlDataPath = nil
        resourceDataPath = nil
    }
    
    class func getInstance() -> SQLdataManger? {
        if instance == nil {
            let lockQueue = DispatchQueue(label: "self")
            lockQueue.sync {
                instance = SQLdataManger()
                if Int(ADASaveDefaluts[MISTEPDATABASEVERSION] ?? 0) == 5 {
                    instance.createTable()
                    instance.createTableTwo()
                    //                ////adaLog(@"-------------------------startInit");
                    //                //dataLog(@"-------------------------startInit");
                } else {
                    instance.checkUpdateDataBase(Int(ADASaveDefaluts[MISTEPDATABASEVERSION] ?? 0))
                }
            }
        }
        return instance
    }
    
    class func clearInstance() {
        if instance {
            instance = nil
        }
    }
    
    /**
     1 把要更改结构的那张表 A1 改名为 tempA1
     2 创建一张当前版本需要结构的表A1
     3 将tempA1 里面的有效数据 迁移到 A1中
     4 删除 tempA1
     
     */
    func checkUpdateDataBase(_ DBVersion: Int) {
        var DBVersion = DBVersion
        //interfaceLog(@"DBVersion = %ld",DBVersion);
        instance.createTable()
        instance.createTableTwo()
        if DBVersion <= 2 {
            //adaLog(@"开始数据库的操作");
            
            let fileManager = FileManager.default
            let fileFolder = HCHCommonManager.getInstance()?.getFileStoreFolder()
            let paths = "\(fileFolder ?? "")/\(SQLfileName)"
            ////adaLog(@"数据库的路径 paths == %@",paths);
            
            resourceDataPath = "\(paths)"
            sqlDataPath = paths
            if fileManager.fileExists(atPath: paths) {
                let queue = FMDatabaseQueue(path: sqlDataPath)
                //1.0  //将原始表名T1 修改为 tempT1
                //将原始表名PersonInfo_Table 修改为 tempPersonInfo_Table
                let renameString1 = "alter table PersonInfo_Table rename to tempPersonInfo_Table"
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(renameString1)
                    if ret == true {
                        //修改表名成功
                        //                    //dataLog(@"修改表名成功 - renameString1");
                    } else {
                        //修改表名失败
                        //dataLog(@"修改表名失败 - renameString1");
                    }
                })
                
                //将原始表名DayTotalData_Table 修改为 tempDayTotalData_Table
                let renameString2 = "alter table DayTotalData_Table rename to tempDayTotalData_Table"
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(renameString2)
                    if ret == true {
                        //修改表名成功
                        //dataLog(@"修改表名成功 - renameString2");
                    } else {
                        //修改表名失败
                        //dataLog(@"修改表名失败 - renameString2");
                    }
                })
                //将原始表名BloodPressure_Table 修改为 tempBloodPressure_Table
                let renameString3 = "alter table BloodPressure_Table rename to tempBloodPressure_Table"
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(renameString3)
                    if ret == true {
                        //修改表名成功
                        //dataLog(@"修改表名成功 - renameString3");
                    } else {
                        //修改表名失败
                        //dataLog(@"修改表名失败 - renameString3");
                    }
                })
                //将原始表名ONLINESPORT 修改为 tempONLINESPORT
                let renameString4 = "alter table ONLINESPORT rename to tempONLINESPORT"
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(renameString4)
                    if ret == true {
                        //修改表名成功
                        //dataLog(@"修改表名成功 - renameString4");
                    } else {
                        //修改表名失败
                        //dataLog(@"修改表名失败 - renameString4");
                    }
                })
                
                // 2.0 //创建新表T1（V2版本的新表创建）
                contentArray = [PersonInfo_Table, DayTotalData_Table, BloodPressure_Table]
                for i in 0..<contentArray.count {
                    //判断是否有表名
                    let tableName = Int(contentArray[i])
                    
                    queue.inDatabase({ db in
                        if db?.tableExists(self.getTableNameString(withName: tableName)) == nil {
                            //建立第一张表:用户信息表
                            let sql = self.packageSQLorder(InitTableAction, withTableName: tableName)
                            let res = db?.executeUpdate(sql)
                            if res ?? false {
                                //dataLog(@"DBVersion <= 2  建表成功");
                            } else {
                                //dataLog(@"DBVersion <= 2  建表失败");
                            }
                        }
                    })
                }
                
                
                queue.inDatabase({ db in
                    let sportSql = self.haveStringTableName(ONLINESPORT, primaryKey: SPORTID, type: "varchar(1000)", otherColumn: [CurrentUserName_HCH: "varchar(10000)", ISUP: "Char", DEVICETYPE: "varchar(10000)", DEVICEID: "varchar(10000)", SPORTTYPE: "varchar(10000)", SPORTDATE: "varchar(1000)", FROMTIME: "varchar(1000)", TOTIME: "varchar(1000)", STEPNUMBER: "varchar(1000)", KCALNUMBER: "varchar(1000)", HEARTRATE: "blob", SPORTNAME: "varchar(1000)"])
                    let res = db?.executeUpdate(sportSql)
                    if res ?? false {
                        //dataLog(@"DBVersion <= 2  建表成功");
                    } else {
                        //dataLog(@"DBVersion <= 2  建表失败");
                    }
                })
                
                // 3.0  //迁移数据
                let toString1 = "insert into PersonInfo_Table(Key,HeadImageURL,BornDateHCL,Male,High,Weight,PersonInfo_IsNeedTosend)  select Key,HeadImageURL,BornDateHCL,Male,High,Weight,PersonInfo_IsNeedTosend from tempPersonInfo_Table"
                let toString2 = "insert into DayTotalData_Table(CurrentUserName,DataDate,TotalSteps_DayData,TotalMeters_DayData,TotalCosts_DayData,stepsPlan,sleepPlan,TotalDeepSleep_DayData,TotalLittleSleep_DayData,TotalWarkeSleep_DayData,TotalSleepCount_DayData,TotalDayEventCount_DayData,TotalDataWeekIndex,TotalDataActivityTime_DayData,TotalDataCalm_DayData,activityCosts,calmCosts)  select CurrentUserName,DataDate,TotalSteps_DayData,TotalMeters_DayData,TotalCosts_DayData,stepsPlan,sleepPlan,TotalDeepSleep_DayData,TotalLittleSleep_DayData,TotalWarkeSleep_DayData,TotalSleepCount_DayData,TotalDayEventCount_DayData,TotalDataWeekIndex,TotalDataActivityTime_DayData,TotalDataCalm_DayData,activityCosts,calmCosts from tempDayTotalData_Table"
                let toString3 = "insert into BloodPressure_Table(BloodPressureID,CurrentUserName,BloodPressureDate,StartTime,systolicPressure,diastolicPressure,heartRateNumber,SPO2,HRV)  select BloodPressureID,CurrentUserName,BloodPressureDate,StartTime,systolicPressure,diastolicPressure,heartRateNumber,SPO2,HRV from tempBloodPressure_Table"
                let toString4 = "insert into ONLINESPORT(sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName) select sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName from tempONLINESPORT"
                
                queue.inDatabase({ db in
                    let res = db?.executeUpdate(toString1)
                    if res ?? false {
                        //dataLog(@"DBVersion <= 2  数据迁移成功 toString1");
                    } else {
                        //dataLog(@"DBVersion <= 2  数据迁移失败 toString1");
                    }
                })
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(toString2)
                    if ret ?? false {
                        //dataLog(@"DBVersion <= 2  数据迁移成功 toString2");
                    } else {
                        //dataLog(@"DBVersion <= 2  数据迁移失败 toString2");
                    }
                })
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(toString3)
                    if ret ?? false {
                        //dataLog(@"DBVersion <= 2  数据迁移成功 toString3");
                    } else {
                        //dataLog(@"DBVersion <= 2  数据迁移失败 toString3");
                    }
                })
                queue.inDatabase({ db in
                    let ret = db?.executeUpdate(toString4)
                    if ret ?? false {
                        //dataLog(@"DBVersion <= 2  数据迁移成功 toString4");
                    } else {
                        //dataLog(@"DBVersion <= 2  数据迁移失败 toString4");
                    }
                })
                // 4.0   //删除tempT1临时表
                queue.inDatabase({ db in
                    
                    let dropTableStr1 = "drop table tempPersonInfo_Table"
                    let booOne = db?.executeUpdate(dropTableStr1)
                    if booOne ?? false {
                        //adaLog(@"删除临时数据库 ---  -  cuccess");
                    } else {
                        ////adaLog(@"删除临时数据库-- - error");
                    }
                })
                queue.inDatabase({ db in
                    let dropTableStr2 = "drop table tempDayTotalData_Table"
                    let booTwo = db?.executeUpdate(dropTableStr2)
                    if booTwo ?? false {
                        //adaLog(@"删除临时数据库 ---  -  cuccess");
                    } else {
                        ////adaLog(@"删除临时数据库-- - error");
                    }
                })
                queue.inDatabase({ db in
                    let dropTableStr3 = "drop table tempBloodPressure_Table"
                    let booThree = db?.executeUpdate(dropTableStr3)
                    if booThree ?? false {
                        //adaLog(@"删除临时数据库 ---  -  cuccess");
                    } else {
                        ////adaLog(@"删除临时数据库-- - error");
                    }
                })
                queue.inDatabase({ db in
                    let dropTableStr4 = "drop table tempONLINESPORT"
                    let booFour = db?.executeUpdate(dropTableStr4)
                    if booFour ?? false {
                        //adaLog(@"删除临时数据库 ---  -  cuccess");
                    } else {
                        ////adaLog(@"删除临时数据库-- - error");
                    }
                })
                ADASaveDefaluts[MISTEPDATABASEVERSION] = "3"
                DBVersion = 3
            }
        }
        if DBVersion == 3 {
            let fileManager = FileManager.default
            let fileFolder = HCHCommonManager.getInstance()?.getFileStoreFolder()
            let paths = "\(fileFolder ?? "")/\(SQLfileName)"
            resourceDataPath = "\(paths)"
            sqlDataPath = paths
            if fileManager.fileExists(atPath: paths) {
                let queue = FMDatabaseQueue(path: sqlDataPath)
                
                //将原始表名ONLINESPORT 修改为 tempONLINESPORT
                queue.inDatabase({ db in
                    let renameString4 = "alter table ONLINESPORT rename to tempONLINESPORT"
                    let ret = db?.executeUpdate(renameString4)
                    if ret ?? false {
                        //dataLog(@"DBVersion == 3    renameString4");
                    } else {
                        //dataLog(@"DBVersion == 3    renameString4");
                    }
                })
                queue.inDatabase({ db in
                    let sportSql = self.haveStringTableName(ONLINESPORT, primaryKey: SPORTID, type: "varchar(1000)", otherColumn: [CurrentUserName_HCH: "varchar(10000)", ISUP: "Char", DEVICETYPE: "varchar(10000)", DEVICEID: "varchar(10000)", SPORTTYPE: "varchar(10000)", SPORTDATE: "varchar(1000)", FROMTIME: "varchar(1000)", TOTIME: "varchar(1000)", STEPNUMBER: "varchar(1000)", KCALNUMBER: "varchar(1000)", HEARTRATE: "blob", SPORTNAME: "varchar(1000)", HAVETRAIL: "Char", TRAILARRAY: "blob", MOVETARGET: "varchar(1000)", MILEAGEM: "varchar(1000)", MILEAGEM_MAP: "varchar(1000)", SPORTPACE: "varchar(1000)", WHENLONG: "varchar(1000)"])
                    let res = db?.executeUpdate(sportSql)
                    if res ?? false {
                        //adaLog(@"DBVersion == 3    运动表  建表 success");
                    } else {
                        //dataLog(@"DBVersion == 3    运动表  建表 fail");
                    }
                })
                queue.inDatabase({ db in
                    // 3.0  //迁移数据
                    let toString4 = "insert into ONLINESPORT(sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName,isUp,deviceType,deviceID) select sportID,CurrentUserName,sportType,sportDate,fromTime,toTime,stepNumber,kcalNumber,heartRate,sportName,isUp,deviceType,deviceID from tempONLINESPORT"
                    let del1 = db?.executeUpdate(toString4)
                    if del1 ?? false {
                        //dataLog(@"DBVersion == 3    运动表  迁移 success");
                    } else {
                        //dataLog(@"DBVersion == 3    运动表  迁移 fail");
                    }
                })
                queue.inDatabase({ db in
                    // 4.0   //删除tempT1临时表
                    let dropTableStr4 = "drop table tempONLINESPORT"
                    let dropRet = db?.executeUpdate(dropTableStr4)
                    if dropRet ?? false {
                        //adaLog(@"DBVersion == 3    运动表  删除 success");
                    } else {
                        //dataLog(@"DBVersion == 3    运动表  删除 fail");
                    }
                })
                ADASaveDefaluts[MISTEPDATABASEVERSION] = "4"
                DBVersion = 4
            }
        }
        
        let fileManager = FileManager.default
        let fileFolder = HCHCommonManager.getInstance()?.getFileStoreFolder()
        let paths = "\(fileFolder ?? "")/\(SQLfileName)"
        resourceDataPath = "\(paths)"
        sqlDataPath = paths
        let queue = FMDatabaseQueue(path: sqlDataPath)
        if DBVersion == 4 {
            //update  旧数据。设备类型1或2 新数据。设备类型001或002
            //血压
            queue.inDatabase({ db in
                let updateBlood = "update BloodPressure_Table set deviceType = '002' where deviceType  = '2'"
                let ret = db?.executeUpdate(updateBlood)
                if ret ?? false {
                    //adaLog(@"updateBlood  == 更新设备类型才 success");
                } else {
                }
            })
            //天总数据
            queue.inDatabase({ db in
                let updateOne = "update DayTotalData_Table set deviceType = '001' where deviceType  = '1'"
                let ret = db?.executeUpdate(updateOne)
                if ret ?? false {
                    //adaLog(@"updateOne  == 更新设备类型才 success");
                } else {
                }
            })
            //天总数据
            queue.inDatabase({ db in
                let updateOne = "update DayTotalData_Table set deviceType = '002' where deviceType  = '2'"
                let ret = db?.executeUpdate(updateOne)
                if ret ?? false {
                    //adaLog(@"updateOne  == 更新设备类型才 success");
                } else {
                }
            })
            //运动
            queue.inDatabase({ db in
                let updateSport = "update ONLINESPORT set deviceType = '001' where deviceType  = '1'"
                let ret = db?.executeUpdate(updateSport)
                if ret ?? false {
                    //adaLog(@"updateSport  == 更新设备类型才 success");
                } else {
                }
            })
            //运动
            queue.inDatabase({ db in
                let updateSport = "update ONLINESPORT set deviceType = '002' where deviceType  = '2'"
                let ret = db?.executeUpdate(updateSport)
                if ret ?? false {
                    //adaLog(@"updateSport  == 更新设备类型才 success");
                } else {
                }
            })
            //PersonInfo_Table
            queue.inDatabase({ db in
                let updatePerson = "update PersonInfo_Table set deviceType = '001' where deviceType  = '1'"
                let ret = db?.executeUpdate(updatePerson)
                if ret ?? false {
                    //adaLog(@"updatePerson  == 更新设备类型才 success");
                } else {
                }
            })
            //PersonInfo_Table
            queue.inDatabase({ db in
                let updatePerson = "update PersonInfo_Table set deviceType = '002' where deviceType  = '2'"
                let ret = db?.executeUpdate(updatePerson)
                if ret ?? false {
                    //adaLog(@"updatePerson  == 更新设备类型才 success");
                } else {
                }
            })
            
            //更新数据库的null值   设备类型为null 就是001  isup=null 就是@"0"
            //        DayTotalData_Table,//天数据总览
            //        BloodPressure_Table,//血压数据表
            //        ONLINESPORT
            queue.inDatabase({ db in
                let updateDay = "update DayTotalData_Table set deviceType = '001' where deviceType is null"
                let ret = db?.executeUpdate(updateDay)
                if ret ?? false {
                    //adaLog(@"updateDay1  ==  success");
                } else {
                }
            })
            queue.inDatabase({ db in
                let updateDay = "update BloodPressure_Table set deviceType = '002' where deviceType is null"
                let ret = db?.executeUpdate(updateDay)
                if ret ?? false {
                    //adaLog(@"updateDay2  ==  success");
                } else {
                }
            })
            queue.inDatabase({ db in
                let updateDay = "update ONLINESPORT set deviceType = '001' where deviceType is null"
                let ret = db?.executeUpdate(updateDay)
                if ret ?? false {
                    //adaLog(@"updateDay3  ==  success");
                } else {
                }
            })
            // isUp
            
            queue.inDatabase({ db in
                let isupDay = "update DayTotalData_Table set isUp = '0' where isUp is null"
                let ret = db?.executeUpdate(isupDay)
                if ret ?? false {
                    //adaLog(@"isupDay  ==  success");
                } else {
                }
            })
            queue.inDatabase({ db in
                let isupBlood = "update BloodPressure_Table set isUp = '0' where isUp is null"
                let ret = db?.executeUpdate(isupBlood)
                if ret ?? false {
                    //adaLog(@"isupBlood  ==  success");
                } else {
                }
            })
            queue.inDatabase({ db in
                let isupSport = "update ONLINESPORT set isUp = '0' where isUp is null"
                let ret = db?.executeUpdate(isupSport)
                if ret ?? false {
                    //adaLog(@"isupSport  ==  success");
                } else {
                }
            })
            let createWea = createTableWeather() //创建天气的表
            //        adaLog(@"createWea =%@",createWea);
            queue.inDatabase({ db in
                
                let ret = db?.executeUpdate(createWea)
                if ret ?? false {
                    adaLog("天气的表  ==  success")
                } else {
                }
            })
            
            ADASaveDefaluts[MISTEPDATABASEVERSION] = "5"
            DBVersion = 5
        }
    }
    
    func updateSqlite() {
        createTable()
        createTableTwo()
    }
    
    func deleteTabel() {
        let fileManager = FileManager.default
        let fileFolder = HCHCommonManager.getInstance()?.getFileStoreFolder()
        let paths = "\(fileFolder ?? "")/\(SQLfileName)"
        if fileManager.fileExists(atPath: paths) {
            let queue = FMDatabaseQueue(path: sqlDataPath)
            
            //将原始表名ONLINESPORT 修改为 tempONLINESPORT
            queue.inDatabase({ db in
                let sql = "drop table DayTotalData_Table"
                let res = db?.executeUpdate(sql)
                if !(res ?? false) {
                    ////adaLog(@"error when delete db table");
                } else {
                    ////adaLog(@"succ to delete db table");
                }
            })
            queue.inDatabase({ db in
                let sql = "drop table BloodPressure_Table"
                let res2 = db?.executeUpdate(sql)
                if !(res2 ?? false) {
                    ////adaLog(@"error when delete db table time");
                } else {
                    ////adaLog(@"succ to delete db table time");
                }
            })
            queue.inDatabase({ db in
                let sql = "drop table ONLINESPORT"
                let res3 = db?.executeUpdate(sql)
                if !(res3 ?? false) {
                    ////adaLog(@"error when delete db table time");
                } else {
                    ////adaLog(@"succ to delete db table time");
                }
                
            })
        }
    }
    
    
    func createTable() {
        let fileManager = FileManager.default
        let fileFolder = HCHCommonManager.getInstance().getFileStoreFolder()
        let paths = "\(fileFolder)/\(SQLfileName)"
        ////adaLog(@"数据库的路径 paths == %@",paths);
        
        resourceDataPath = "\(paths)"
        
        sqlDataPath = paths
        
        let queue = FMDatabaseQueue(path: sqlDataPath)
        //将原始表名ONLINESPORT 修改为 tempONLINESPORT
        queue.inDatabase({ db in
            
            contentArray = [PersonInfo_Table, DayTotalData_Table, BloodPressure_Table, Peripheral_Table]
            for i in 0..<contentArray.count {
                //判断是否有表名
                let tableName = Int(contentArray[i])
                
                if db?.tableExists(self.getTableNameString(withName: tableName)) == nil {
                    //建立第一张表:用户信息表
                    let sql = self.packageSQLorder(Int(InitTableAction), withTableName: tableName)
                    
                    //                adaLog(@"sql = %@",sql);
                    
                    let res = db?.executeUpdate(sql)
                    if res ?? false {
                        adaLog("直接建表 ---- success =%ld", tableName)
                    } else {
                        adaLog("直接建表 ---- fail")
                    }
                }
            }
        })
    }
    
    // MARK: Package SQL order
    func packageSQLorder(_ orderIndex: Int, withTableName tableName: Int) -> String? {
        var string = ""
        
        let array = getSQLTableKeyArray(with: tableName)
        let nums: Int = (array?.count ?? 0) / 2
        var tableString = "" //表名
        var keyString = "" //主键
        if nums >= 2 {
            tableString = array?[0] as? String ?? ""
            keyString = array?[2] as? String ?? ""
        } else {
            return string
        }
        
        switch orderIndex {
        case Int(InitTableAction):
            string = "CREATE TABLE '\(tableString)' "
            //主键
            let kNums = Int(array?[3] ?? 0)
            var pirmkey = ""
            let yueshu = getUnionKey(withTableName: tableName)
            if yueshu != nil {
            } else {
                pirmkey = "primary key"
            }
            
            switch kNums {
            case 0 /*字符 */:
                if let object = array?[3] {
                    string = "\(string) (\(keyString) \(object) \(pirmkey) "
                }
            case 1 /*int 型 */:
                string = "\(string) (\(keyString) int NOT NULL \(pirmkey) "
            case 2 /*long 型 */:
                string = "\(string) (\(keyString) long NOT NULL \(pirmkey) "
            case 3 /*dateTime */:
                string = "\(string) (\(keyString) DATETIME NOT NULL \(pirmkey) "
            case 4 /*double */:
                string = "\(string) (\(keyString) double NOT NULL \(pirmkey) "
            case 5 /*   int 型  auto */:
                string = "\(string) (\(keyString)  PRIMARY KEY autoincrement"
            default:
                break
            }
            
            var i = 2
            while i < nums {
                let fNums = Int(array?[2 * i + 1] ?? 0)
                let section = array?[2 * i] as? String
                let value = array?[2 * i + 1] as? String
                switch fNums {
                case 0:
                    string = "\(string) , '\(section ?? "")' \(value ?? "")"
                case 1 /*int 型 */:
                    string = "\(string) , '\(section ?? "")' int NOT NULL DEFAULT (0)"
                case 2 /*long 型 */:
                    string = "\(string) , '\(section ?? "")' long NOT NULL DEFAULT (0)"
                case 3 /*dateTime */:
                    string = "\(string) , '\(section ?? "")' DATETIME NOT NULL"
                case 4 /*double */:
                    string = "\(string) , '\(section ?? "")' double NOT NULL DEFAULT (0)"
                default:
                    break
                }
                i
            }
            i += 1
            
            if yueshu != nil {
                string = "\(string) , \(yueshu ?? "")"
            }
            
            string = "\(string))"
        case Int(WriteTableAction):
            string = "insert or replace into \(tableString) (\(keyString)"
            var i = 2
            while i < nums {
                if let object = array?[2 * i] {
                    string = "\(string),\(object)"
                }
                i
            }
            i += 1
            string = "\(string)) values(?"
            
            var i = 2
            while i < nums {
                string = "\(string),? "
                i
            }
            i += 1
            string = "\(string))"
        case WriteTable_Dictionary:
            //insert into namedparamcounttest values (:a, :b, :c, :d)
            string = "insert or replace into \(tableString) values (:\(keyString)"
            var i = 2
            while i < nums {
                if let object = array?[2 * i] {
                    string = "\(string),:\(object)"
                }
                i
            }
            i += 1
            string = "\(string))"
        default:
            break
        }
        
        return string
    }
    
    func getUnionKey(withTableName tableName: Int) -> String? {
        var string: String
        
        switch tableName {
        case DayTotalData_Table:
            string = "primary key ('\(CurrentUserName_HCH)','\(DataTime_HCH)','\(DEVICETYPE)')"
        default:
            break
        }
        
        return string
    }
    
    func checkNULLstring(_ oriString: String?) -> String? {
        var string = ""
        if oriString == nil {
            return string
        }
        if (oriString is NSNull) {
            return string
        }
        string = "\(oriString ?? "")"
        
        return string
    }
    
    // MARK: getTableDic
    //根据表名获取表所对应的表结构字段
    func getSQLTableKeyArray(with indexs: Int) -> [Any]? {
        var array: [Any]? = nil
        switch indexs {
        case PersonInfo_Table:
            array = ["PersonInfo_Table", Char_Type_SQL(0, nil), Key_PersonInfo_HCH, Int_Type_SQL, HeadImageURL_PersonInfo_HCH, Char_Type_SQL(0, nil), BornDate_PersonInfo_HCH, Char_Type_SQL(0, nil), Male_PersonInfo_HCH, Char_Type_SQL(0, nil), High_PersonInfo_HCH, Char_Type_SQL(0, nil), Weight_PersonInfo_HCH, Char_Type_SQL(0, nil), PersonInfo_IsNeedTosend_HCH, Int_Type_SQL, ISUP, Char_Type_SQL(0, nil), DEVICETYPE, Char_Type_SQL(0, nil), DEVICEID, Char_Type_SQL(0, nil)]
        case DayTotalData_Table:
            array = ["DayTotalData_Table", Char_Type_SQL(0, nil), CurrentUserName_HCH, Nvarchar_Type_SQL(20, ""), DataTime_HCH, Int_Type_SQL, TotalSteps_DayData_HCH, Int_Type_SQL, TotalMeters_DayData_HCH, Int_Type_SQL, TotalCosts_DayData_HCH, Int_Type_SQL, Steps_PlanTo_HCH, Int_Type_SQL, Sleep_PlanTo_HCH, Int_Type_SQL, TotalDeepSleep_DayData_HCH, Int_Type_SQL, TotalLittleSleep_DayData_HCH, Int_Type_SQL, TotalWarkeSleep_DayData_HCH, Int_Type_SQL, TotalSleepCount_DayData_HCH, Int_Type_SQL, TotalDayEventCount_DayData_HCH, Int_Type_SQL, TotalDataWeekIndex_DayData_HCH, Int_Type_SQL, TotalDataActivityTime_DayData_HCH, Int_Type_SQL, TotalDataCalmTime_DayData_HCH, Int_Type_SQL, kTotalDayActivityCost, Int_Type_SQL, kTotalDayCalmCost, Int_Type_SQL, ISUP, Char_Type_SQL(0, nil), DEVICETYPE, Char_Type_SQL(0, nil), DEVICEID, Char_Type_SQL(0, nil)]
        case BloodPressure_Table /*血压建表。字段 */:
            array = ["BloodPressure_Table", Char_Type_SQL(0, nil), BloodPressureID_def, Nvarchar_Type_SQL(1000, ""), CurrentUserName_HCH, Nvarchar_Type_SQL(1000, ""), BloodPressureDate_def, Nvarchar_Type_SQL(1000, ""), StartTime_def, Nvarchar_Type_SQL(1000, ""), systolicPressure_def, Nvarchar_Type_SQL(1000, ""), diastolicPressure_def, Nvarchar_Type_SQL(1000, ""), heartRateNumber_def, Nvarchar_Type_SQL(1000, ""), SPO2_def, Nvarchar_Type_SQL(1000, ""), HRV_def, Nvarchar_Type_SQL(1000, ""), ISUP, Char_Type_SQL(0, nil), DEVICETYPE, Char_Type_SQL(0, nil), DEVICEID, Char_Type_SQL(0, nil)]
        case Peripheral_Table /*外设表 */:
            array = ["Peripheral_Table", Char_Type_SQL(0, nil), deviceId_per, Int_Type_SQL, macAddress_per, Nvarchar_Type_SQL(1000, ""), UUIDString_per, Nvarchar_Type_SQL(1000, ""), RSSI_per, Nvarchar_Type_SQL(1000, ""), deviceName_per, Nvarchar_Type_SQL(1000, "")]
        default:
            break
        }
        
        return array
    }
    
    func getTableNameString(withName indexs: Int) -> String? {
        var string = ""
        let array = getSQLTableKeyArray(with: indexs)
        if (array?.count ?? 0) >= 4 {
            if let object = array?[0] {
                string = "\(object)"
            }
        }
        
        return string
    }
    
    // MARK: insertMoreDateToTable
    func insertMoreData(toTable tableName: SQLTalbeNameEnum, withData transArray: [Any]?) -> Bool {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        var res = false
        queue.inDatabase({ db in
            let nums: Int? = transArray?.count
            db?.beginTransaction()
            let isRollBack = false
            defer {
                if !isRollBack {
                    res = true
                    db?.commit()
                }
            }
            do {
                let sql = self.packageSQLorder(WriteTable_Dictionary, withTableName: Int(tableName))
                let keyArray = self.getSQLTableKeyArray(with: Int(tableName))
                let kNums: Int = (keyArray?.count ?? 0) / 2
                
                for i in 0..<(nums ?? 0) {
                    let dic = transArray?[i] as? [AnyHashable : Any]
                    var mutDic: [AnyHashable : Any] = [:]
                    for j in 1..<kNums {
                        let keyString = keyArray?[2 * j] as? String
                        let type = Int(keyArray?[2 * j + 1] ?? 0)
                        var value: Any?
                        switch type {
                        case 0:
                            value = dic?[keyString]
                            if value == nil {
                                value = ""
                            } else {
                                if let value = value {
                                    value = "\(value)"
                                }
                            }
                        case 1 /*int 型 */:
                            value = Int32(Int(dic?[keyString] ?? 0))
                        case 2 /*long 型 */:
                            value = Int64(dic?[keyString] ?? 0)
                        case 3 /*DateTime */:
                            let dString = self.checkNULLstring(dic?[keyString] as? String)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            value = formatter.date(from: dString ?? "")
                        case 4 /*double */:
                            value = Double(dic?[keyString] ?? 0.0)
                        case 5 /*bigint */:
                            value = Int64(dic?[keyString] ?? 0)
                        default:
                            break
                        }
                        
                        mutDic[keyString ?? ""] = value
                    }
                    
                    res = db?.executeUpdate(sql, withParameterDictionary: mutDic) ?? false
                }
            } catch let exception {
                db?.rollback()
            }
        })
        
        return res
    }


    // MARK: insetSignalDataToTable
    func insertSignalData(toTable tableName: SQLTalbeNameEnum, withData transDic: [AnyHashable : Any]?) -> Bool {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        var res = false
        
        queue.inDatabase({ db in
            let sql = self.packageSQLorder(WriteTable_Dictionary, withTableName: tableName)
            let array = self.getSQLTableKeyArray(withIndex: tableName)
            let nums: Int = array.count / 2
            var mutDic: [AnyHashable : Any] = [:]
            for i in 1..<nums {
                let keyString = array[2 * i] as? String
                let type = Int(array[2 * i + 1])
                
                var value: Any?
                switch type {
                case 0:
                    value = transDic?[keyString]
                    if value == nil {
                        value = ""
                    } else {
                        if let value = value {
                            value = "\(value)"
                        }
                    }
                case 1 /*int 型 */:
                    value = Int32(Int(transDic?[keyString] ?? 0))
                case 2 /*long 型 */, 5 /*longint */:
                    value = Int64(transDic?[keyString] ?? 0)
                case 3 /*DateTime */:
                    let dString = self.checkNULLstring(transDic?[keyString])
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    value = formatter.date(from: dString)
                case 4 /*double */:
                    value = Double(transDic?[keyString] ?? 0.0)
                default:
                    break
                }
                mutDic[keyString ?? ""] = value
            }
            
            res = db?.executeUpdate(sql, withParameterDictionary: mutDic) ?? false
        })
        
        return res
    }
    
    // MARK:
    // MARK: deleteTableInfoWithTableName
    func deleteTableInfo(withTableName talbeName: SQLTalbeNameEnum) {
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: talbeName)
            let sql = "delete from \(tableName) "
            if db?.executeUpdate(sql) != nil {
                ////adaLog(@"Delete %@ success" , tableName ) ;
            } else {
                ////adaLog(@"delete %@ failed" , tableName);
            }
        })
    }
    
    // MARK: dropTableWithName
    func dropTable(withName tableIndex: Int) -> Bool {
        
        var res = false
        let queue = FMDatabaseQueue(path: sqlDataPath)
        //将原始表名ONLINESPORT 修改为 tempONLINESPORT
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: tableIndex)
            let sql = "drop table \(tableName)"
            res = db?.executeUpdate(sql) ?? false
            if res {
                ////adaLog(@"drop table success" ) ;
            } else {
                ////adaLog(@"drop table failed");
            }
            
        })
        return res
    }
    
    
    //数据库封装
    
    func getCharTypeSQL(withLength length: Int, defaultValue: String?) -> String? {
        var string = "Char"
        
        if length > 0 {
            string = "\(string)(\(length))"
        }
        
        if !(defaultValue == "Not Null") && defaultValue {
            string = "\(string) NOT NULL DEFAULT '\(defaultValue ?? "")'"
        } else if defaultValue != nil {
            string = "\(string) NOT NULL "
        }
        
        return string
    }


    func getNvarcharTypeSQL(withLength length: Int, defaultValue: String?) -> String? {
        var string = "Nvarchar"
        
        if length > 0 {
            string = "\(string)(\(length))"
        }
        
        if !(defaultValue == "Not Null") && defaultValue != nil {
            string = "\(string) NOT NULL DEFAULT '\(defaultValue ?? "")'"
        } else if defaultValue != nil {
            string = "\(string) NOT NULL "
        }
        
        return string
    }
    
    func getVarcharTypeSQL(withLength length: Int, defaultValue: String?) -> String? {
        var string = "Varchar"
        
        if length > 0 {
            string = "\(string)(\(length))"
        }
        
        if !(defaultValue == "Not Null") && defaultValue != nil {
            string = "\(string) NOT NULL DEFAULT '\(defaultValue ?? "")'"
        } else if defaultValue != nil {
            string = "\(string) NOT NULL "
        }
        
        return string
    }
    
    func getCurPersonInf() -> [AnyHashable : Any]? {
        var infoDic: [AnyHashable : Any]
        
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: PersonInfo_Table)
            let sql = "select * from \(tableName) "
            
            let rs: FMResultSet? = db?.execute(sql)
            
            while rs?.next() {
                if let result = rs?.resultDictionary() {
                    infoDic = result
                }
            }
        })
        
        return infoDic
    }
    
    func getTotalData(with date: Int) -> [AnyHashable : Any]? {
        var infoDic: [AnyHashable : Any]
        
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: DayTotalData_Table)
            let deviceType = String(format: "%03d", Int(ADASaveDefaluts[AllDEVICETYPE] ?? 0))
            let sql = "select * from \(tableName) where \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(DataTime_HCH) = '\(date)' and \(DEVICETYPE) = '\(deviceType)' "
            //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
            
            let rs: FMResultSet? = db?.execute(sql)
            
            while rs?.next() {
                if let result = rs?.resultDictionary() {
                    infoDic = result
                }
            }
        })
        
        return infoDic
    }
    
    /*
     *根据系统的uuid的唯一标记符。取得macAddress
     *
     *
     */
    func getPeripheralWith(_ uuid: String?) -> [AnyHashable : Any]? {
        var infoDic: [AnyHashable : Any]
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: Peripheral_Table)
            let sql = "select * from \(tableName) where \(UUIDString_per) = '\(uuid ?? "")'"
            //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                if let result = rs?.resultDictionary() {
                    infoDic = result
                }
            }
        })
        return infoDic
    }
    
    /**
     
     上传数据查询 , ,获取天总数据
     日期 ，上传标记
     */
    func getTotalDataWith(toUp date: Int, isUp: String?) -> [AnyHashable : Any]? {
        var infoDic: [AnyHashable : Any]
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: DayTotalData_Table)
            let deviceType = String(format: "%03d", Int(ADASaveDefaluts[AllDEVICETYPE] ?? 0))
            let sql = "select * from \(tableName) where \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(DataTime_HCH) = '\(date)'  and \(ISUP) != '\(isUp ?? "")' and \(DEVICETYPE) = '\(deviceType)'"
            //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
            
            let rs: FMResultSet? = db?.execute(sql)
            
            while rs?.next() {
                if let result = rs?.resultDictionary() {
                    infoDic = result
                }
            }
        })
        
        return infoDic
    }
    
    /**
     
     上传 成功   更新数据
     日期 ，上传标记
     */
    //- (void)updataTotalDataTableWithDic:(NSDictionary *)dic
    //{
    //
    //    __block NSDictionary *infoDic ;
    //    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:sqlDataPath];
    //    [queue inDatabase:^(FMDatabase *db){
    //        NSString *tableName = [self getTableNameStringWithName:DayTotalData_Table];
    //        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%d'  and %@ != '%@' " , tableName,CurrentUserName_HCH,[[HCHCommonManager getInstance]UserAcount], DataTime_HCH, date,ISUP,isUp];
    //        //        NSString *sql = [NSString stringWithFormat:@"select * from %@ " , tableName];
    //
    //        FMResultSet * rs = [db executeQuery:sql];
    //
    //        while ([rs next]) {
    //            infoDic = [rs resultDictionary] ;
    //        }
    //    }];
    //}
    func getAllTotalData() -> [Any]? {
        var mutArray: [AnyHashable] = []
        
        let startTime = TimeCallManager.getInstance().getSecondsWithTimeString("2015/01/20", andFormat: "yyyy/MM/dd")
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: DayTotalData_Table)
            let sql = "select * from \(tableName) where \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(DataTime_HCH) > '\(startTime)' order by \(DataTime_HCH) "
            
            let rs: FMResultSet? = db?.execute(sql)
            
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        
        return mutArray
    }
    
    func queryDayTotalData(with year: Int, weekIndex week: Int) -> [Any]? {
        var mutArray: [AnyHashable] = []
        
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: DayTotalData_Table)
            let deviceType = String(format: "%03d", Int(ADASaveDefaluts[AllDEVICETYPE] ?? 0))
            let sql = String(format: "select * from %@ where %@ = '%@' and %@ = '%ld' and %@ = '%@'", tableName, CurrentUserName_HCH, HCHCommonManager.getInstance().userAcount(), TotalDataWeekIndex_DayData_HCH, week, DEVICETYPE, deviceType)
            
            let rs: FMResultSet? = db?.execute(sql)
            
            while rs?.next() {
                let dic = rs?.resultDictionary()
                let time = Int(dic?[DataTime_HCH] ?? 0)
                let year_temp: Int = TimeCallManager.getInstance().getYearWithSecond(time)
                if year == year_temp {
                    if let dic = dic {
                        mutArray.append(dic)
                    }
                }
            }
        })
        
        return mutArray
    }
    
    //通过日期查询血压数据
    func queryBloodPressure(withDay time: String?) -> [Any]? {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: BloodPressure_Table)
            let sql = "select * from \(tableName)  where \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(BloodPressureDate_def) = '\(time ?? "")'"
            
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        return mutArray
    }
    
    /**
     *
     *上传数据查询
     *日期 ，上传标记
     *通过日期查询血压数据
     */
    func queryBloodPressureWithDay(toUp time: String?, isUp: String?) -> [Any]? {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: BloodPressure_Table)
            let sql = "select * from \(tableName)  where \(CurrentUserName_HCH) = '\(HCHCommonManager.getInstance().userAcount())' and \(BloodPressureDate_def) = '\(time ?? "")' and \(ISUP) != '\(isUp ?? "")'"
            
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        return mutArray
        
    }
    
    // 查询血压数据 总数／／
    func queryBloodPressureALL() -> Int {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: BloodPressure_Table)
            let sql = "select * from \(tableName)"
            
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        return mutArray.count
    }
    
    // 查询外设数据 总数／／
    func queryPeripheralALL() -> Int {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: Peripheral_Table)
            let sql = "select * from \(tableName)"
            
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        return mutArray.count
    }

    
    /**
     
     查询表内所有数据
     */
    func queryALLData(withTable talbeName: SQLTalbeNameEnum) -> [Any]? {
        var mutArray: [AnyHashable] = []
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            let tableName = self.getTableNameString(withName: talbeName)
            let sql = "select * from \(tableName)"
            
            let rs: FMResultSet? = db?.execute(sql)
            while rs?.next() {
                let dic = rs?.resultDictionary()
                if let dic = dic {
                    mutArray.append(dic)
                }
            }
        })
        return mutArray
    }
    
    // MARK:   ---  建表    ---  建表   ---   建表
    
    
    //*创建表单
    func createTableTwo() {
        createTableName(ONLINESPORT, primaryKey: SPORTID, type: "varchar(1000)", otherColumn: [CurrentUserName_HCH: "varchar(10000)", ISUP: "Char", DEVICETYPE: "varchar(10000)", DEVICEID: "varchar(10000)", SPORTTYPE: "varchar(10000)", SPORTDATE: "varchar(1000)", FROMTIME: "varchar(1000)", TOTIME: "varchar(1000)", STEPNUMBER: "varchar(1000)", KCALNUMBER: "varchar(1000)", HEARTRATE: "blob", SPORTNAME: "varchar(1000)", HAVETRAIL: "Char", TRAILARRAY: "blob", MOVETARGET: "varchar(1000)", MILEAGEM: "varchar(1000)", MILEAGEM_MAP: "varchar(1000)", SPORTPACE: "varchar(1000)", WHENLONG: "varchar(1000)"])
    }
    
    func createTableWeather() -> String? {
        return autoStringTableName(WEATHERTABLE, primaryKey: WEATHERID, type: "integer", otherColumn: [WEATHERTIME: "varchar(10000)", WEATHERLOCATION: "varchar(10000)", WEATHERCONTENT: "blob", EXTONE: "varchar(10000)", EXTTWO: "varchar(10000)", EXTTHREE: "varchar(1000)"])
    }
    
    func haveStringTableName(_ name: String?, primaryKey key: String?, type: String?, otherColumn dict: [AnyHashable : Any]?) -> String? {
        //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
        var sql = "CREATE TABLE IF NOT EXISTS \(name ?? "")(\(key ?? "") \(type ?? "") PRIMARY KEY"
        for columnName: String? in dict as? [String?] ?? [:] {
            sql = sql + (",\(columnName ?? "") \(dict?[columnName ?? ""])")
        }
        sql = sql + (");")
        return sql
    }
    
    func autoStringTableName(_ name: String?, primaryKey key: String?, type: String?, otherColumn dict: [AnyHashable : Any]?) -> String? {
        //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
        var sql = "CREATE TABLE IF NOT EXISTS \(name ?? "")(\(key ?? "") \(type ?? "") PRIMARY KEY autoincrement"
        for columnName: String? in dict as? [String?] ?? [:] {
            sql = sql + (",\(columnName ?? "") \(dict?[columnName ?? ""])")
        }
        sql = sql + (");")
        return sql
    }
    
    //*建表
    //在线运动
    func createTableName(_ name: String?, primaryKey key: String?, type: String?, otherColumn dict: [AnyHashable : Any]?) {
        //在线运动
        //建立数据库
        let queue = FMDatabaseQueue(path: sqlDataPath)
        queue.inDatabase({ db in
            //字典中,key是列的名字,值是列的类型,如果没有附加参数,直接写到列中
            var sql = "CREATE TABLE IF NOT EXISTS \(name ?? "")(\(key ?? "") \(type ?? "") PRIMARY KEY"
            for columnName: String? in dict as? [String?] ?? [:] {
                sql = sql + (",\(columnName ?? "") \(dict?[columnName ?? ""])")
            }
            sql = sql + (");")
            let res = db?.executeUpdate(sql)
            if res ?? false {
                //dataLog(@"运动 表  success");
                //            ////adaLog(@"Two   error when creating db table");
            } else {
                //dataLog(@"运动 表  fail");
                //            ////adaLog(@"Two   succ to creating db table");
            }
        })
        
    }
    
}
 */*/*/*/*/*/*/*/
