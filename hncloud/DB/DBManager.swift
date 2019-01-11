//
//  DBManager.swift
//  hncloud
//
//  Created by 辰 on 2019/1/10.
//  Copyright © 2019 HNCloud. All rights reserved.
//
import UIKit
import FMDB

//CurrentUserName_HCH
//DataTime_HCH
//TotalSteps_DayData_HCH
//TotalMeters_DayData_HCH
//TotalCosts_DayData_HCH
//Sleep_PlanTo_HCH
//Steps_PlanTo_HCH
//TotalDataActivityTime_DayData_HCH
//TotalDataCalmTime_DayData_HCH
//kTotalDayActivityCost
//kTotalDayCalmCost
//DEVICETYPE
//DEVICEID

enum Table: Int {
    case personInfo = 0
    case dayTotalData
    case bloodPressure
    case peripheral

    var name: String {
        switch self {
        case .personInfo:
            return "PersonInfo"
        case .dayTotalData:
            return "DayTotalData"
        case .bloodPressure:
            return "BloodPressure"
        case .peripheral:
            return "Peripheral"

        }
    }
}

enum DBPersonInfo {
    case token
    case headImageURL
    case bornDate
    case sex
    case high
    case weight
    
    var key: String {
        switch self {
        case .token:
            return "token"
        case .headImageURL:
            return "headImageURL"
        case .bornDate:
            return "bornDate"
        case .sex:
            return "sex"
        case .high:
            return "high"
        case .weight:
            return "weight"
        }
    }
}

enum DBDayTotalData {
    case userName
    case dateDate
    case steps
    case distance
    case costs
    case stepsPlan
    case sleepPlan
    case deepSleep
    case lightSleep
    case wakeSleep
    case sleepCount
    case dayEventCount
    case dataWeekIndex
    case dataActivityTime
    case dataCalmTime
    case dayActivityCost
    case dayCalmCost
    case deviceType
    var key: String {
        switch self {
        case .userName:
            return "userName"
        case .dateDate:
            return "dateDate"
        case .steps:
            return "steps"
        case .distance:
            return "distance"
        case .costs:
            return "costs"
        case .stepsPlan:
            return "stepsPlan"
        case .sleepPlan:
            return "sleepPlan"
        case .deepSleep:
            return "deepSleep"
        case .lightSleep:
            return "lightSleep"
        case .wakeSleep:
            return "wakeSleep"
        case .sleepCount:
            return "sleepCount"
        case .dayEventCount:
            return "dayEventCount"
        case .dataWeekIndex:
            return "dataWeekIndex"
        case .dataActivityTime:
            return "dataActivityTime"
        case .dataCalmTime:
            return "dataCalmTime"
        case .dayActivityCost:
            return "dayActivityCost"
        case .dayCalmCost:
            return "dayCalmCost"
        case .deviceType:
            return "deviceType"
        }
    }
}

enum DBBloodPressure {
    case bloodPressureID
    case currentUserName
    case bloodPressureDate
    case startTime
    case systolicPressure
    case diastolicPressure
    case heartRateNumber
    case spo2
    case hrv
    case deviceType
    var key: String {
        switch self {
        case .bloodPressureID:
            return "bloodPressureID"
        case .currentUserName:
            return "currentUserName"
        case .bloodPressureDate:
            return "bloodPressureDate"
        case .startTime:
            return "startTime"
        case .systolicPressure:
            return "systolicPressure"
        case .diastolicPressure:
            return "diastolicPressure"
        case .heartRateNumber:
            return "heartRateNumber"
        case .spo2:
            return "spo2"
        case .hrv:
            return "hrv"
        case .deviceType:
            return "deviceType"
        }
    }
}




class DBManager: NSObject {
    
    static let share: DBManager = DBManager()
    
    private let fileName: String = "HNCloud.sqlite" // sqlite name
    private var filePath: String = "" // sqlite path
    private var database: FMDatabase! // FMDBConnection
    
    
    // MARK:
    
    /// Table name.
    private let dayDetail: String = "BLDetail"
    
    private let userNumber: String = "UserName"
    
    /// 資料當天秒數
    private let second: String = "dataDate"
    private let awakeSleep: String = "awakeSleep"
    private let costsData: String = "costsData"
    private let deepSleep: String = "deepSleep"
    private let isUp: String = "isUp"
    private let lightSleep: String = "lightSleep"
    private let pilaoData: String = "pilaoData"
    private let sleepData: String = "sleepData"
    private let stepData: String = "stepData"
    private let heartData: String = "heartData"
    
    // MARK: 
    
    private override init() {
        super.init()
        // 取得sqlite在documents下的路徑(開啟連線用)
        self.filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/" + self.fileName
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    /// 生成 .sqlite 檔案並創建表格，只有在 .sqlite 不存在時才會建立
    func createTable() {
        let fileManager: FileManager = FileManager.default
        
        // 判斷documents是否已存在該檔案
        if !fileManager.fileExists(atPath: self.filePath) {
            
            // 開啟連線
            if self.openConnection() {
                let createTableSQL = """
                    CREATE TABLE \(self.dayDetail) (
                    \(self.userNumber) TEXT,
                    \(self.second) integer,
                    \(self.costsData) blob,
                    \(self.deepSleep) integer,
                    \(self.isUp) TEXT,
                    \(self.lightSleep) integer,
                    \(self.pilaoData) blob,
                    \(self.sleepData) blob,
                    \(self.stepData) blob,
                    \(self.heartData) blob)
                """
                self.database.executeStatements(createTableSQL)
                print("file copy to: \(self.filePath)")
            }
        } else {
            print("file allready exists at path:\(self.filePath)")
        }
    }
    
    /// 取得 .sqlite 連線
    ///
    /// - Returns: Bool
    func openConnection() -> Bool {
        var isOpen: Bool = false
        
        self.database = FMDatabase(path: self.filePath)
        
        if self.database != nil {
            if self.database.open() {
                isOpen = true
            } else {
                print("Could not get the connection.")
            }
        }
        
        return isOpen
    }
    /// 新增
    func insertData(second: Int, lightSleep: Int) {
        
        if self.querySameData(second: second) {
            print("update = \(UserInfo.share.count)")
           self.updateData(by: second, lightSleep: lightSleep)
        } else {
            print("insert = \(UserInfo.share.count)")
            guard self.openConnection() else { return }
            let insertSQL: String = "INSERT INTO \(self.dayDetail) (\(self.userNumber), \(self.second), \(self.lightSleep)) VALUES(?, ?, ?)"
            if !self.database.executeUpdate(insertSQL, withArgumentsIn: [UserInfo.share.count, second, lightSleep]) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            
            self.database.close()
        }
    }
    /// 更新
    func updateData(by second: Int, lightSleep: Int) {
        guard self.openConnection() else { return }
        let updateSQL: String = "UPDATE \(self.dayDetail) SET \(self.lightSleep) = ? WHERE \(self.second) = ? AND \(self.userNumber) = ?"
        do {
            try self.database.executeUpdate(updateSQL, values: [lightSleep, second, UserInfo.share.count])
            print("更新完成")
        } catch {
            print(error.localizedDescription)
        }
        
        self.database.close()
    }
    /// 判斷是否有同一筆資料
    func querySameData(second: Int) -> Bool {
        guard self.openConnection() else { return false }
        let select = "SELECT * FROM \(self.dayDetail) WHERE \(self.second) = \(second) AND \(self.userNumber) = '\(UserInfo.share.count)'"
        do {
            let dataLists: FMResultSet = try self.database.executeQuery(select, values: nil)
            let haveSame = dataLists.next()
            self.database.close()
            return haveSame
        } catch {
            print(error.localizedDescription)
            self.database.close()
            return false
        }
    }
    /// 查詢
    func query(second: Int) {
        guard self.openConnection() else { return }
        let select = "SELECT * FROM \(self.dayDetail) WHERE \(self.second) = \(second) AND \(self.userNumber) = '\(UserInfo.share.count)'"
        do {
            let dataLists: FMResultSet = try self.database.executeQuery(select, values: nil)
            
            while dataLists.next() {
                print("value = \(dataLists.int(forColumn: self.lightSleep))")
            }
            self.database.close()
        } catch {
            print(error.localizedDescription)
        }
    }
    /// 刪除資料
    func delete(by second: Int) {
        guard self.openConnection() else { return }
        let deleteSQL: String = "DELETE FROM \(self.dayDetail) WHERE \(self.second) = ?"
        
        do {
            try self.database.executeUpdate(deleteSQL, values: [second])
            print("success")
        } catch {
            print(error.localizedDescription)
        }
        
        self.database.close()
    }
}
