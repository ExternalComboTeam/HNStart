//
//  PerModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/24.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit
import CoreBluetooth

class PerModel: NSObject {
    
    // MARK: - Property.
    
    var peripheral: CBPeripheral
    var rssi: Int
    var type: Int
    var macAddress: String?
    var deviceID: String?
    var uuid: String?
    var deviceName: String?
    
    init(peripheral: CBPeripheral, rssi: Int, type: Int, macAddress: String?) {
        
        self.peripheral = peripheral
        self.rssi = rssi
        self.type = type
        self.macAddress = macAddress
        
        super.init()
    }
    
    func description() -> String {
        return "macAddress-\(String(describing: macAddress)),per-\(String(describing: peripheral)),RSSI-\(String(describing: rssi)),deviceId-\(String(describing: deviceID)),UUIDString-\(String(describing: uuid)),deviceName-\(String(describing: deviceName))"
    }

}
