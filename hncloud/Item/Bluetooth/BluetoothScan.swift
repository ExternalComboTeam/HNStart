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
        
        
        if let array = centralManager?.retrieveConnectedPeripherals(withServices: [CBUUID(string: "180d"), CBUUID(string: "1814")]) {
            
            for item in array {
                if self.addDevList(peripheral: item, RSSI: 1, advertisementData: nil) {
                    for i in 0..<uuidArray!.count {
                        let item = uuidArray![i]
                        print("""
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
//        print("addDevList: - uuidArray = \(uuidArray)")
        var isUpdate = true
        
        for model in uuidArray {
            
            let peripheralInArray = model.peripheral
            
            if peripheral.identifier.uuidString == peripheralInArray.identifier.uuidString {
                isUpdate = false
                break
            }
        }
        
        if isUpdate {
            
            var type = 0
            
            let data = advertisementData?[CBAdvertisementDataManufacturerDataKey] as? NSData
            
            if let name = advertisementData?[CBAdvertisementDataLocalNameKey] as? String {
                
                let model = name.components(separatedBy: "_")[0]
                
                if model == "R5S" {
                    type = 4
                }
                
            } else {
                if  let name = peripheral.name,
                    let typeString = UserDefaults.standard.object(forKey: name) as? NSString {
                    
                    type = Int(typeString.intValue)
                    
                } else {
                    
                    type = 1000
                }
            }
            
            
            
            
            
            
            /*
             
            let data = advertisementData?[CBAdvertisementDataManufacturerDataKey] as? NSData
             
            if let _data = data, _data.length != 0 {
                
                let byte = _data.uint8Byte
            
                type = Int(byte[1])
            
            } else {
                
                if  let name = peripheral.name,
                    let typeString = UserDefaults.standard.object(forKey: name) as? NSString {
                    
                    type = Int(typeString.intValue)
                    
                } else {
                    
                    type = 1000
                }
            }
            */
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

        
        self.peripheral = peripheral
        
        if addDevList(peripheral: peripheral, RSSI: RSSI, advertisementData: advertisementData) {
            print("🍤 name = \(uuidArray![0].deviceName), deviceID = \(uuidArray![0].deviceID), peripheral = \(uuidArray![0].peripheral), macAddress = \(uuidArray![0].macAddress)")
            self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray: uuidArray)
            
//            if self.delegate?.responds(to: #selector(self.delegate?.bluetoothScanDiscoverPeripheral(deviceArray:))) ?? false {
//
//
//            }
        }
    }
}
