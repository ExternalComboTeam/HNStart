//
//  DBManager.swift
//  hncloud
//
//  Created by 辰 on 2019/1/10.
//  Copyright © 2019 HNCloud. All rights reserved.
//
import UIKit
import FMDB

class DBManager: NSObject {
    
    static let share: DBManager = DBManager()
    
    private var fileName: String = "HNCloud.sqlite" // sqlite name
    private var filePath: String = "" // sqlite path
    private var database: FMDatabase! // FMDBConnection
    
    private var dayDetail: String = "BLDetail"
    private var userNumber: String = "UserName"
    private var second: String = "dataDate"
    private var awakeSleep: String = "awakeSleep"
    private var costsData: String = "costsData"
    private var deepSleep: String = "deepSleep"
    private var isUp: String = "isUp"
    private var lightSleep: String = "lightSleep"
    private var pilaoData: String = "pilaoData"
    private var sleepData: String = "sleepData"
    private var stepData: String = "stepData"
    private var heartData: String = "heartData"
    
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
