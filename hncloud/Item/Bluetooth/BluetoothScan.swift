//
//  BluetoothScan.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/25.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit
import CoreBluetooth
import AVFoundation

@objc protocol BluetoothScanDelegate: NSObjectProtocol {
    @objc func bluetoothScanDiscoverPeripheral(deviceArray: [Any]?)
}

class BluetoothScan: NSObject, CBPeripheralDelegate {

    // MARK: - Proprety.
    weak var delegate: BluetoothScanDelegate?
    
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral!
    
    var uuidArray: [PerModel]?
    
    deinit {
        
        centralManager?.stopScan()
        peripheral?.delegate = nil
        centralManager?.delegate = nil
        centralManager = nil
        
        uuidArray = nil
        
        if peripheral != nil {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    
    func startScan() {
        
        centralManager = nil
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        if uuidArray != nil {
            uuidArray?.removeAll()
        } else {
            uuidArray = []
        }
        
        if centralManager == nil {
            print("🍥🍥🍥🍥🍥🍥")
        }
        
//        if let array = centralManager?.ret {
//            print("🍥 \(array)")
//        } else {
//            print("什麼都沒有，你還是吃屎吧！")
//        }
        
        if let array = centralManager?.retrieveConnectedPeripherals(withServices: [CBUUID(string: "180d"), CBUUID(string: "1814")]) {
            print("🍥 \(array)")
            for item in array {
                if self.addDevList(peripheral: item, RSSI: 1, advertisementData: nil) {
                    for i in 0..<uuidArray!.count {
                        let item = uuidArray![i]
                        print("""
                            🍥🍥🍥🍥🍥
                            item\(i)
                            deviceID = \(item.deviceID)
                            deviceName = \(item.deviceName)
                            deviceName = \(item.macAddress)
                            deviceName = \(item.peripheral)
                            """)
                    }
                    
                    
                    self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray: uuidArray)
//                    self.delegate?.bluetoothScanDiscoverPeripheral?(deviceArray: uuidArray)
//                    if let delegate = self.delegate, delegate.responds(to: #selector(delegate.bluetoothScanDiscoverPeripheral(deviceArray:))) {
//                        print("🍥 responds")
//                    } else {
//                        print("🍥 no responds")
//                    }
//
//                    if self.delegate?.responds(to: #selector(self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray:))) ?? false {
//                        print("🍥 responds")
//                        self.delegate?.bluetoothScanDiscoverPeripheral?(deviceArray: uuidArray)
//
//                    }
                }
            }
        } else {
            
            print("🍣🍣🍣")
        }
    }
    
    func stopScan() {
        if centralManager != nil {
            centralManager?.stopScan()
            uuidArray?.removeAll()
        }
    }
    
    func clearDeviceList() {
        if uuidArray != nil {
            uuidArray?.removeAll()
            if self.delegate?.responds(to: #selector(self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray:))) ?? false {
                
                self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray: uuidArray)
            }
        }

    }
    
    func addDevList(peripheral: CBPeripheral, RSSI: NSNumber, advertisementData: [String: Any]?) -> Bool {
        
        if RSSI.intValue == 127 {
            return false
        }
        
        guard var uuidArray = uuidArray else {
            return false
        }
        print("addDevList: - uuidArray = \(uuidArray)")
        var isUpdate = true
        
        for model in uuidArray {
            
            let peripheralInArray = model.peripheral
            print("addDevList: - uuidArray.models.peripheral = \(peripheralInArray)")
            if peripheral.identifier.uuidString == peripheralInArray.identifier.uuidString {
                isUpdate = false
                break
            }
        }
        
        if isUpdate {
            
            let data = advertisementData?[CBAdvertisementDataManufacturerDataKey] as? NSData
            
            var type = 0
            
            if let _data = data, _data.length != 0 {
                
                let count = _data.length / MemoryLayout<UInt8>.size
                var array = [UInt8](repeating: 0, count: count)
                _data.getBytes(&array, length: count)
                #warning("取得 TYPE 方式疑似有問題")
                type = Int(array[1])
            
            } else {
                
                if  let name = peripheral.name,
                    let typeString = UserDefaults.standard.object(forKey: name) as? NSString {
                    
                    type = Int(typeString.intValue)
                    
                } else {
                    
                    type = 1000
                }
            }
            
            let model = PerModel(peripheral: peripheral, rssi: RSSI.intValue, type: type, macAddress: ToolBox.macData(toString: data))
            
            if model.macAddress == "B60421" {
                assert(!(model.macAddress == "B60421"), "-----错误的macaddress")
            }
            
            //校验macAddress
            let correct = ToolBox.checkMacAddressLength(model.macAddress)
            if !correct {
                return correct
            }
            model.deviceName = advertisementData?[CBAdvertisementDataLocalNameKey] as? String
            var uuidStr = ""
            
            uuidStr = peripheral.identifier.uuidString

            model.uuid = uuidStr
            for i in 0..<uuidArray.count {
                let arryModel: PerModel? = uuidArray[i]
                if Int(truncating: RSSI) > arryModel?.rssi ?? 0 {
                    uuidArray.insert(model, at: i)
                    return isUpdate
                }
            }
            uuidArray.append(model)
        }
        self.uuidArray = uuidArray
        return isUpdate
    }
}
    

extension BluetoothScan: CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        func printLog(_ string: String) {
            #if DEBUG
            NSLog("%@", string)
            #endif
        }
        
        switch central.state {
        case .unknown:
            printLog("CoreBluetooth BLE state is unknown")
        case .resetting:
            printLog("CoreBluetooth BLE hardware is resetting")
        case .unsupported:
            printLog("CoreBluetooth BLE hardware is unsupported on this platform")
        case .unauthorized:
            printLog("CoreBluetooth BLE state is unauthorized")
        case .poweredOff:
            printLog("CoreBluetooth BLE hardware is Powered off")
        case .poweredOn:
            printLog("CoreBluetooth BLE hardware is Powered on and ready")
            centralManager?.scanForPeripherals(withServices: [CBUUID(string: "180d"), CBUUID(string: "1814")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }


    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
//        if let name = peripheral.name {
//            print("🍤  \(name), rssi = \(RSSI.intValue)")
//        }
//
        
        self.peripheral = peripheral
        
        if addDevList(peripheral: peripheral, RSSI: RSSI, advertisementData: advertisementData) {
            print("🍤🍤 name = \(uuidArray![0].deviceName), deviceID = \(uuidArray![0].deviceID), peripheral = \(uuidArray![0].peripheral), macAddress = \(uuidArray![0].macAddress)")
            self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray: uuidArray)
            
//            if self.delegate?.responds(to: #selector(self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray:))) ?? false {
//
//
//            }
        }
    }
}