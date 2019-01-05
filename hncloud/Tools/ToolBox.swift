//
//  ToolBox.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class ToolBox {
    
    

    /// 校验mac地址的 正确性  -- 长度
    ///
    /// - Parameter macString: mac地址
    /// - Returns: 是否正確
    class func checkMacAddressLength(_ macString: String?) -> Bool {
        var correct = true
        if (macString?.count ?? 0) == 6 {
            correct = false
        }
        return correct
    }

    /// 校验mac地址的正确性
    ///
    /// - Parameter macString: mac地址
    /// - Returns: 是否正確
    class func checkMacAddressCorrect(_ macString: String?) -> Bool {
        
//        guard let macString = macString else { return false }
        
        var correct = true
        
//        let b7Range = macString.range(of: "B7")
//        let b6Range = macString.range(of: "B6")
        
        
        let b7Range: NSRange? = (macString as NSString?)?.range(of: "B7", options: .caseInsensitive)
        let b6Range: NSRange? = (macString as NSString?)?.range(of: "B6", options: .caseInsensitive)
        if Int(b7Range?.location ?? 0) == NSNotFound {
            correct = false
        }
        if Int(b6Range?.location ?? 0) == NSNotFound {
            correct = false
        }
        if ((macString?.count ?? 0) - Int(b7Range?.location ?? 0)) < 14 {
            correct = false
        }
        if ((macString?.count ?? 0) - Int(b6Range?.location ?? 0)) < 6 {
            correct = false
        }
        
 
 
        return correct
 
    }


    /// macToString    data  mac地址转化为字符串
    ///
    /// - Parameter macAddressData: <#macAddressData description#>
    /// - Returns: <#return value description#>
    class func macData(toString macAddressData: NSData?) -> String? {
        
        guard let data = macAddressData else {
            return nil
        }
        
        let byte = data.uint8Byte
        var string: String? = ""
//        var string: String? = String(format: "%X", byte[0])
        
        for i in 0..<data.length {
            let tempString = String(format: "%X", byte[i])
            if tempString.count == 1 {
                string = string?.appendingFormat("0%@", tempString)
            } else {
                string = string?.appending(tempString)
            }
        }
        
//        let count = data.length / MemoryLayout<UInt8>.size
//        var bytes = [UInt8](repeating: 0, count: count)
//        data.getBytes(&bytes, length: count)
//
//        var string: String? = ""
//
//        for byte in bytes {
//
//            let string1 = String(format: "%X", byte)
//
//            if string1.count == 1 {
//                string = string ?? "" + ("0\(string1)")
//            } else {
//                string = string ?? "" + string1
//            }
//        }
        
        let correct = self.checkMacAddressCorrect(string)
        if !correct {
            string = nil
        }
        if string != "" {
            string = string?.uppercased()
        }
        return string
    }
    
    /// arrayToString    11，22，33，44
    class func array(toString array: [String]) -> String? {
        if array.count == 0 {
            return ""
        }
        var string = ""
        for i in 0..<array.count {
            if array.count - 1 == i {
                
                string += "\(array[i])"
            } else {
                string += "\(array[i]),"
            }
            // //adaLog(@"i=%d",i);
        }
        
        return string
    }

    
    /*
    /// 把日期截取生成  时 日 月 年
    ///
    /// - Parameter date: <#date description#>
    /// - Returns: <#return value description#>
    class func weatherDate(toArray date: String) -> [String]? {
        var arr: [String] = []
        let arrayDay = date.components(separatedBy: "-")
        arr.append(arrayDay?[2]) //日
        arr.append(arrayDay?[1]) //月
        arr.append(arrayDay?[0]) //年
        return arr
    }
 */
    
    class func byte(_ byte: inout [UInt8], add: Int) -> [UInt8] {
        let nsData = NSData(bytes: byte, length: byte.count)
        var newByte = nsData.bytes
        newByte += add
        let data = Data(referencing: nsData)
        byte = data.bytes
        return byte
    }
    
    /**
     *   求最大值
     */
    class func getSportIDMax(_ array: [Int]?) -> String? {
        
        guard let array = array else {
            #if DEBUG
            print("\(#function)\narray is nil.")
            #endif
            return nil
        }
        
        var maxStr = "0"
        if array.count > 0 {
            var maxInt: Int = 0
            var tempInt: Int = 0
            for i in 0..<array.count {
                tempInt = array[i]
                //adaLog(@"tempInt = %d",tempInt);
                if tempInt > maxInt {
                    maxInt = tempInt
                }
            }
            maxInt += 1
            maxStr = "\(maxInt)"
        }
        return maxStr
    }

    /// 保存macAddress之前的获取
    ///
    /// - Returns: macAddress
    class func amendMacAddressGetAddress() -> String {
        
        var deviceId = ""
        
        let macStr = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceMACADDRESS)
        if macStr == nil {
            //从名字中截取mac地址。
            var deviceName = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceNAME)
            let array = self.getRangeStr(deviceName, findText: "_")
            if let array = array, array.count == 1 {
                deviceName = (deviceName as NSString?)?.substring(with: NSRange(location: Int(array[0]) + 1, length: (deviceName?.count ?? 0) - Int(array[0]) - 1))
                deviceId = self.deviceName(toGetMacAddress: deviceName)
                //            if(deviceName.length == 10)
                //            {
                //                deviceName = [NSString stringWithFormat:@"00%@",deviceName];
                //            }
                //            else if (deviceName.length == 8)
                //            {
                //                deviceName = [NSString stringWithFormat:@"0000%@",deviceName];
                //            }
                //            deviceId =  deviceName;
            } else {
                deviceId = GlobalProperty.DEFAULTDEVICEID
            }
        } else {
            deviceId = macStr ?? ""
        }
        
        return deviceId
    }
    
    
    
    /// 获取这个字符串中的所有xxx的所在的index
    ///
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - findText: <#findText description#>
    /// - Returns: <#return value description#>
    class func getRangeStr(_ text: String?, findText: String?) -> [Int]? {
        var arrayRanges = [Int](repeating: 0, count: 20)
        if findText == nil && (findText == "") {
            return nil
        }
        let rang: NSRange? = (text as NSString?)?.range(of: findText ?? "", options: .caseInsensitive) //获取第一次出现的range
        if Int(rang?.location ?? 0) != NSNotFound && Int(rang?.length ?? 0) != 0 {
            arrayRanges.append(Int(rang?.location ?? 0)) //将第一次的加入到数组中
            var rang1 = NSRange(location: 0, length: 0)
            var location: Int = 0
            var length: Int = 0
            var i = 0
            
            for _ in 0..<Int.max {
                
                if 0 == i {
                    //去掉这个xxx
                    location = Int((rang?.location ?? 0) + (rang?.length ?? 0))
                    length = (text?.count ?? 0) - Int(rang?.location ?? 0) - Int(rang?.length ?? 0)
                    rang1 = NSRange(location: location, length: length)
                } else {
                    location = Int((rang1.location) + (rang1.length))
                    length = (text?.count ?? 0) - Int(rang1.location) - Int(rang1.length)
                    rang1 = NSRange(location: location, length: length)
                }
                //在一个range范围内查找另一个字符串的range
                rang1 = (text as NSString?)?.range(of: findText ?? "", options: .caseInsensitive, range: rang1) ?? rang1
                
                if Int(rang1.location ) == NSNotFound && Int(rang1.length) == 0 {
                    break
                } else {
                    arrayRanges.append(Int(rang1.location))
                }
                i += 1
            }
            return arrayRanges
        }
        return nil
    }
    
    
    
    /*
     保存macAddress之前的获取
     
     * @return macAddress
     */
    class func deviceName(toGetMacAddress fifthMac: String?) -> String {
        var macAddress = ""
        //从名字中截取mac地址。
        
        let deviceName = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceNAME)
        let r2range: NSRange? = (deviceName as NSString?)?.range(of: "R2", options: .caseInsensitive)
        let k18srange: NSRange? = (deviceName as NSString?)?.range(of: "K18s", options: .caseInsensitive)
        let k64srange: NSRange? = (deviceName as NSString?)?.range(of: "K64s", options: .caseInsensitive)
        let b7srange: NSRange? = (deviceName as NSString?)?.range(of: "B7", options: .caseInsensitive)
        if Int(r2range?.location ?? 0) != NSNotFound || Int(k18srange?.location ?? 0) != NSNotFound || Int(k64srange?.location ?? 0) != NSNotFound {
            //r2,k18s,k64s
            macAddress = self.r2strAppendstr(fifthMac)
        } else if Int(b7srange?.location ?? 0) != NSNotFound {
            //b7
            macAddress = self.b7strAppendstr(fifthMac)
        } else {
            //r1 多种情况
            macAddress = self.r1strAppendstr(fifthMac)
        }
        return macAddress
    }
    
    //r2 k18s k64s 拼接的字符串
    class func r2strAppendstr(_ strR2: String?) -> String {
        return "00\(strR2 ?? "")"
    }
    
    //r2 k18s k64s 拼接的字符串
    class func b7strAppendstr(_ strB7: String?) -> String {
        return "ed\(strB7 ?? "")"
    }
    
    //r1 拼接的字符串
    class func r1strAppendstr(_ strR1: String?) -> String {
        return "e0\(strR1 ?? "")"
    }

    /**
     *   手表的过滤
     */
    class func checkWatch(_ deviceArray: [PerModel]) -> [PerModel] {
        var tempArray: [PerModel] = []
        
        for model in deviceArray {
            if model.type != 4 {
                tempArray.append(model)
            }
        }
        return tempArray
    }
    
    /**
     *   手环的过滤
     */
    class func checkBracelet(_ deviceArray: [PerModel]) -> [PerModel] {
        var tempArray: [PerModel] = []
        
        for model in deviceArray {
            if model.type == 4 {
                tempArray.append(model)
            }
        }
        return tempArray
    }

    
    /**
     *
     检查到设置中的外设。没有收到广播。就从数据库中取得macAddress  保存本地
     */
    class func setMacaddress(_ uuid: String?) -> Bool {
        // if (!uuid) {
        //    return NO;
        //}
        
        
        #warning("SQLdataManger 尚未建立")
        
//        let dictionary = SQLdataManger.getInstance().getPeripheralWith(uuid)
        let dictionary: [String]? = []
        
        
        
        if let dic = dictionary{
            
            // TODO: - 尚未儲存
//            UserDefaults.standard.set(dic[GlobalProperty.macAddress_per], forKey: GlobalProperty.kLastDeviceMACADDRESS)
            
            return true
        } else {
            return false
        }
        
        
        
        return true
    }

    
    /**
     *
     macToString    data  mac地址转化为字符串
     */
    class func savePeripheral(_ model: PerModel) -> Bool {
        if model.macAddress == nil {
            return false
        }
        
        
        
        #warning("SQLdataManger 尚未建立")
        
//        let peripheralArray = SQLdataManger.getInstance().queryALLData(withTable: Peripheral_Table)
        let peripheralArray = [[AnyHashable : Any]]()
        
        
        
        
        var isHave = false
        for dict: [AnyHashable : Any] in peripheralArray{
            if (dict[GlobalProperty.macAddress_per] as? String == model.macAddress) {
                isHave = true
            }
        }
        if isHave {
            return false
        }
        var dict: [AnyHashable : Any] = [:]
        var rssiStr = ""
        var deviceNameTemp = ""
        var deviceIdTemp = ""
        if abs(model.rssi) > 0 {
            rssiStr = "\(model.rssi)"
        } else {
            rssiStr = "0"
        }
        if model.deviceName != nil {
            deviceNameTemp = model.deviceName ?? ""
        } else {
            deviceNameTemp = "0"
        }
        
        
        #warning("SQLdataManger 尚未建立")
        
//        deviceIdTemp = String(format: "%ld", SQLdataManger.getInstance().queryPeripheralALL())
        deviceIdTemp = ""
        
        
        dict[GlobalProperty.deviceId_per] = deviceIdTemp
        dict[GlobalProperty.macAddress_per] = model.macAddress
        dict[GlobalProperty.UUIDString_per] = model.uuid
        dict[GlobalProperty.RSSI_per] = rssiStr
        dict[GlobalProperty.deviceName_per] = deviceNameTemp
        
        
        
        #warning("SQLdataManger 尚未建立")
        
//        let insert = SQLdataManger.getInstance().insertSignalData(toTable: Peripheral_Table, withData: dict)
        let insert = true
        
        
        
        return insert
    }

}
