//
//  DBObject.swift
//  hncloud
//
//  Created by Hong Shih on 2019/1/11.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit


enum Table: Int {
    case personInfo = 0
    case dayTotalData
    case bloodPressure
    case peripheral
    case onlineSport
    
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
        case .onlineSport:
            return "onlineSport"
        }
    }
}

enum DBKPersonInfo: Int {
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

enum DBKDayTotalData: Int {
    case userName = 0
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

enum DBKBloodPressure: Int {
    case bloodPressureID = 0
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

enum DBKPeripheral: Int {
    case deviceId
    case macAddress
    case UUIDString
    case RSSI
    case deviceName
    var key: String {
        switch self {
        case .deviceId:
            return "deviceId"
        case .macAddress:
            return "macAddress"
        case .UUIDString:
            return "UUIDString"
        case .RSSI:
            return "RSSI"
        case .deviceName:
            return "deviceName"
        }
    }
}

enum DBKOnlineSport {
    case id
    case sportType
    case sportDate
    case toTime
    case step
    case kcal
    case heartRate
    case sportName
    case haveTrail
    case trailArray
    case moveTarget
    case mileagem
    case mileagemMap
    case whenlong
    case deviceType
    var key: String {
        switch self {
        case .id:
            return "id"
        case .sportType:
            return "sportType"
        case .sportDate:
            return "sportDate"
        case .toTime:
            return "toTime"
        case .step:
            return "step"
        case .kcal:
            return "kcal"
        case .heartRate:
            return "heartRate"
        case .sportName:
            return "sportName"
        case .haveTrail:
            return "haveTrail"
        case .trailArray:
            return "trailArray"
        case .moveTarget:
            return "moveTarget"
        case .mileagem:
            return "mileagem"
        case .mileagemMap:
            return "mileagemMap"
        case .whenlong:
            return "whenlong"
        case .deviceType:
            return "deviceType"
        }
    }
}
struct TableCreateData {
    static let personInfo = """
    CREATE TABLE \(Table.personInfo.name) (
    \(DBKPersonInfo.token) integer,
    \(DBKPersonInfo.headImageURL) char,
    \(DBKPersonInfo.bornDate) char,
    \(DBKPersonInfo.sex) char,
    \(DBKPersonInfo.high) char,
    \(DBKPersonInfo.weight) char,
    """
    
    static let dayTotalData = """
    CREATE TABLE \(Table.dayTotalData.name) (
    \(DBKDayTotalData.userName.key) Nvarchar(20),
    \(DBKDayTotalData.dateDate.key) integer,
    \(DBKDayTotalData.steps.key) integer,
    \(DBKDayTotalData.distance.key) integer,
    \(DBKDayTotalData.costs.key) integer,
    \(DBKDayTotalData.stepsPlan.key) integer,
    \(DBKDayTotalData.sleepPlan.key) integer,
    \(DBKDayTotalData.deepSleep.key) integer,
    \(DBKDayTotalData.lightSleep.key) integer,
    \(DBKDayTotalData.wakeSleep.key) integer,
    \(DBKDayTotalData.sleepCount.key) integer,
    \(DBKDayTotalData.dayEventCount.key) integer,
    \(DBKDayTotalData.dataWeekIndex.key) integer,
    \(DBKDayTotalData.dataActivityTime.key) integer,
    \(DBKDayTotalData.dataCalmTime.key) integer,
    \(DBKDayTotalData.dayActivityCost.key) integer,
    \(DBKDayTotalData.dayCalmCost.key) integer,
    \(DBKDayTotalData.deviceType.key) integer)
    """
    
    static let bloodPressure = """
    CREATE TABLE \(Table.bloodPressure.name) (
    \(DBKBloodPressure.bloodPressureID.key) Nvarchar(1000),
    \(DBKBloodPressure.currentUserName.key) Nvarchar(1000),
    \(DBKBloodPressure.bloodPressureDate.key) Nvarchar(1000),
    \(DBKBloodPressure.startTime.key) Nvarchar(1000),
    \(DBKBloodPressure.systolicPressure.key) Nvarchar(1000),
    \(DBKBloodPressure.diastolicPressure.key) Nvarchar(1000),
    \(DBKBloodPressure.heartRateNumber.key) Nvarchar(1000),
    \(DBKBloodPressure.spo2.key) Nvarchar(1000),
    \(DBKBloodPressure.hrv.key) Nvarchar(1000),
    \(DBKBloodPressure.deviceType.key) Nvarchar(1000))
    """
    
    static let peripheral = """
    CREATE TABLE \(Table.peripheral.name) (
    \(DBKPeripheral.deviceId.key) integer,
    \(DBKPeripheral.macAddress.key) Nvarchar(1000),
    \(DBKPeripheral.UUIDString.key) Nvarchar(1000),
    \(DBKPeripheral.RSSI.key) Nvarchar(1000),
    \(DBKPeripheral.deviceName.key) Nvarchar(1000))
    """
    static let onlineSport = """
    CREATE TABLE \(Table.onlineSport.name) (
    \(DBKOnlineSport.id) varchar(1000) PRIMARY KEY,
    \(DBKOnlineSport.sportType) varchar(10000),
    \(DBKOnlineSport.sportDate) varchar(10000),
    \(DBKOnlineSport.toTime) varchar(10000),
    \(DBKOnlineSport.step) varchar(10000),
    \(DBKOnlineSport.kcal) varchar(10000),
    \(DBKOnlineSport.heartRate) blob,
    \(DBKOnlineSport.sportName) varchar(10000),
    \(DBKOnlineSport.haveTrail) Char,
    \(DBKOnlineSport.trailArray) blob,
    \(DBKOnlineSport.moveTarget) varchar(1000),
    \(DBKOnlineSport.mileagem) varchar(1000),
    \(DBKOnlineSport.mileagemMap) varchar(1000),
    \(DBKOnlineSport.whenlong) varchar(1000),
    \(DBKOnlineSport.deviceType) varchar(1000))
    """
}

struct InsertData {
    static let dayTotalData = """
    INSERT INTO \(Table.dayTotalData.name) (\(DBKDayTotalData.userName.key), \(DBKDayTotalData.dateDate.key), \(DBKDayTotalData.steps.key), \(DBKDayTotalData.distance.key), \(DBKDayTotalData.costs.key), \(DBKDayTotalData.stepsPlan.key), \(DBKDayTotalData.sleepPlan.key), \(DBKDayTotalData.deepSleep.key), \(DBKDayTotalData.lightSleep.key), \(DBKDayTotalData.wakeSleep.key), \(DBKDayTotalData.sleepCount.key), \(DBKDayTotalData.dayEventCount.key), \(DBKDayTotalData.dataWeekIndex.key), \(DBKDayTotalData.dataActivityTime.key), \(DBKDayTotalData.dataCalmTime.key), \(DBKDayTotalData.dayActivityCost.key), \(DBKDayTotalData.dayCalmCost.key), \(DBKDayTotalData.deviceType.key)) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
}







