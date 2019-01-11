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
        createTable(type: .personInfo)
        createTable(type: .dayTotalData)
        createTable(type: .bloodPressure)
        createTable(type: .peripheral)
        createTable(type: .onlineSport)
    }
    
    private func createTable(type: Table) {
        
        let fileManager: FileManager = FileManager.default
        
        // 判斷documents是否已存在該檔案
        if !fileManager.fileExists(atPath: self.filePath) {
            
            // 開啟連線
            if self.openConnection() {
                
                var createTableSQL: String {
                    switch type {
                    case .personInfo:
                        return TableCreateData.personInfo
                    case .dayTotalData:
                        return TableCreateData.dayTotalData
                    case .bloodPressure:
                        return TableCreateData.bloodPressure
                    case .peripheral:
                        return TableCreateData.peripheral
                    case .onlineSport:
                        return TableCreateData.onlineSport
                    }
                }
                self.database.executeStatements(createTableSQL)
                print("\(type.name) file copy to: \(self.filePath)")
            }
        } else {
            print("\(type.name) file allready exists at path:\(self.filePath)")
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
        
        // 檢查是否存在
        if self.querySameData(second: second) {
            print("update = \(UserInfo.share.count)")
            // 更新
           self.updateData(by: second, lightSleep: lightSleep)
        } else {
            
            // 新增
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
    
    func insertData(with table: Table, data: [String: Any]) {
        
        var insertSQL: String {
            switch table {
            case .dayTotalData:
                return InsertData.dayTotalData
            default:
                return ""
            }
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
