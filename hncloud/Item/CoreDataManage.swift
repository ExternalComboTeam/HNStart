//
//  CoreDataManage.swift
//  hncloud
//
//  Created by Hong Shih on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManage: NSObject {
    
    private(set) var managedObjectContext: NSManagedObjectContext?
    private(set) var managedObjectModel: NSManagedObjectModel?
    private(set) var persistentStoreCoordinator: NSPersistentStoreCoordinator?

    func saveContext() {
    }

    func applicationDocumentsDirectory() -> URL? {
        return nil
    }

    //DayDetail
    func creatDayDetailTabel(withDic dic: [AnyHashable : Any]?) {
    }

    func querDayDetail(withTimeSeconds seconds: Int) -> [AnyHashable : Any]? {
        return nil
    }

    func querDayDetailWithTimeSeconds(toUp seconds: Int, isUp: String?) -> [AnyHashable : Any]? {
        return nil
    }

    func updataDayDetailTable(withDic dic: [AnyHashable : Any]?) {
    }

    func updataDayDetailDAYALL(withDic dic: [AnyHashable : Any]?) {
    } //上传服务器后。更新当天的详情数据

    //HeartData
    func querHeartData(withTimeSeconds seconds: Int) -> [AnyHashable : Any]? {
        return nil
    }

    func querHeartDataWithTimeSeconds(toUp seconds: Int, isUp: String?) -> [AnyHashable : Any]? {
        return nil
    }

    func creatHeartRate(withDic dic: [AnyHashable : Any]?) {
    }

    func updataHeartRate(withDic dic: [AnyHashable : Any]?) {
    }

    func updataHeartRateALLDAY(withDic dic: [AnyHashable : Any]?) {
    } //上传服务器后，更新当天的心率

    class func shareInstance() -> Any? {
        return nil
    }

    func deleteData() {
    }
    // test

}
