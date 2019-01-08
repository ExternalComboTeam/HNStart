////  Converted to Swift 4 by Swiftify v4.2.26067 - https://objectivec2swift.com/
////
////  AllTool.swift
////  Mistep
////
////  Created by 迈诺科技 on 2016/11/4.
////  Copyright © 2016年 huichenghe. All rights reserved.
////
//
//import Foundation
//
//class AllTool: NSObject {
//    /**
//     *
//     */
//    /**
//     *   求平均值
//     */
//    class func getMean(_ array: [Any]?) -> String? {
//        if array == nil {
//            return "0"
//        }
//        var str = "0"
//        if (array?.count ?? 0) > 0 {
//            ////adaLog(@"- -----ppp");
//            if array?.count == 1 {
//                if (array?[0] is String) {
//                    if (array?[0] == initNumber) {
//                        return "0"
//                    }
//                }
//            }
//            ////adaLog(@"- -----222");
//            var heartNum: Int = 0
//            let timer: Int = 0
//            var temp: Int = 0
//            for str: String? in array as? [String?] ?? [] {
//                temp = Int(truncating: str ?? "") ?? 0
//                if temp > 0 {
//                    heartNum += temp
//                    timer += 1
//                }
//            }
//            str = String(format: "%ld", heartNum / timer)
//        }
//        return str
//    }
//
//    /**
//     *   求最大值
//     */
//    class func getMax(_ array: [Any]?) -> String? {
//        var max = "0"
//        var maxN: Int = 0
//        if (array?.count ?? 0) > 0 {
//            ////adaLog(@"- -----ppp");
//            if array?.count == 1 {
//                if (array?[0] is String) {
//                    if (array?[0] == initNumber) {
//                        return "0"
//                    }
//                }
//            }
//
//            for i in 0..<(array?.count ?? 0) {
//                let heart = Int(array?[i])
//                if heart != 255 {
//                    if maxN < heart {
//                        maxN = heart
//                    }
//                }
//            }
//            max = "\(maxN)"
//        }
//        return max
//    }
//
//    /**
//     *   求最大值
//     */
//    class func getSportIDMax(_ array: [Any]?) -> String? {
//        var maxStr = "0"
//        if (array?.count ?? 0) > 0 {
//            var maxInt: Int = 0
//            var tempInt: Int = 0
//            for i in 0..<(array?.count ?? 0) {
//                tempInt = Int(array?[i])
//                //adaLog(@"tempInt = %d",tempInt);
//                if tempInt > maxInt {
//                    maxInt = tempInt
//                }
//            }
//            maxInt += 1
//            maxStr = "\(maxInt)"
//        }
//        return maxStr
//    }
//
//    /**
//     *   把心率带数组转化为分钟。用于以后的计算
//     */
//    class func seconedTominute(_ array: [Any]?) -> [AnyHashable]? {
//        var minuteArray: [AnyHashable] = []
//        var temp: Int = 0
//        var timer: Int = 0
//
//        var i = 0
//        while i < (array?.count ?? 0) {
//            temp = Int(array?[i])
//            if temp > 0 {
//                minuteArray.append(array?[i])
//                if timer > 0 {
//                    i = i + (60 - timer)
//                    timer = 0
//                } else {
//                    i += 60
//                }
//            } else {
//                if timer >= 60 {
//                    timer = 0
//                    minuteArray.append("0")
//                    i += 1
//                } else {
//                    i += 1
//                    timer += 1
//                }
//            }
//            
//        }
//        if minuteArray.count <= 0 {
//            minuteArray.append(initNumber)
//        }
//        return minuteArray
//    }
//
//    /**
//     *   手表的过滤
//     */
//    class func checkWatch(_ deviceArray: [Any]?) -> [AnyHashable]? {
//        var tempArray: [AnyHashable] = []
//
//        for model: PerModel? in deviceArray as? [PerModel?] ?? [] {
//            if model?.type == 8 {
//                if let aModel = model {
//                    tempArray.append(aModel)
//                }
//            }
//        }
//        return tempArray
//    }
//
//    /**
//     *   手环的过滤
//     */
//    class func checkBracelet(_ deviceArray: [Any]?) -> [AnyHashable]? {
//        var tempArray: [AnyHashable] = []
//
//        for model: PerModel? in deviceArray as? [PerModel?] ?? [] {
//            if model?.type != 8 {
//                if let aModel = model {
//                    tempArray.append(aModel)
//                }
//            }
//        }
//        return tempArray
//    }
//
//    /**
//     * 核实手环版本是否支持在线运动
//     */
//    class func checkVersion(withHard hardV: Int, hardTwo: Int, soft softV: Int, blue blueV: Int) -> Bool {
//        var isNotSupport = true
//
//        let soft = softV
//        let hard = hardV
//        //    int8_t hardTwoUse = hardTwo;
//        let blue = blueV
//        var ha = ""
//        //    NSString *haTwo = [NSString string];
//        var so = ""
//        var bl = ""
//        var haInt: Int
//        //    NSInteger haTwoInt;
//        var soInt: Int
//        var blInt: Int
//        if hardTwo == 161616 {
//
//            ha = String(format: "%02x", hard)
//            bl = String(format: "%02x", blue)
//            so = String(format: "%02x", soft)
//            haInt = self.hexStringTranslate(toDoInteger: ha)
//            blInt = self.hexStringTranslate(toDoInteger: bl)
//            soInt = self.hexStringTranslate(toDoInteger: so)
//            //adaLog( @" - - %ld  %ld  %ld  ",haInt,blInt,soInt);
//        } else {
//            ha = String(format: "%02x%02x", hardTwo, hard)
//            bl = String(format: "%02x", blue)
//            so = String(format: "%02x", soft)
//            haInt = self.hexStringTranslate(toDoInteger: ha)
//            blInt = self.hexStringTranslate(toDoInteger: bl)
//            soInt = self.hexStringTranslate(toDoInteger: so)
//            //adaLog( @" - - %ld  %ld  %ld  ",haInt,blInt,soInt);
//        }
//
//        if haInt == 15 && soInt <= 6 {
//            isNotSupport = false
//        }
//        if haInt == 17 && soInt <= 24 {
//            isNotSupport = false
//        }
//        if haInt == 18 && soInt <= 26 {
//            isNotSupport = false
//        }
//        if haInt == 19 && soInt <= 8 {
//            isNotSupport = false
//        }
//        if haInt == 21 && soInt <= 7 {
//            isNotSupport = false
//        }
//        if haInt == 23 && soInt < 1 && blInt != 1 {
//            isNotSupport = false
//        }
//
//        return isNotSupport
//    }
//
//    /**
//     *  十六进制字符串转换为十进制数
//     *
//     *  @param hexString 十六进制字符串
//     *
//     *  @return 十进制整数
//     */
//    class func hexStringTranslate(toDoInteger hexString: String?) -> Int {
//        assert((hexString is String), "是这个类型 = ")
//        var Do: Int = 0 //获取10进制数
//        let length: Int = hexString?.count ?? 0
//        let array = [Int](repeating: 0, count: length) //获取每个字节的10进制数
//
//        for i in 0..<length {
//            let hex_char1 = unichar(hexString?[hexString?.index(hexString?.startIndex, offsetBy: i)] ?? 0) //16进制数中的第i位
//
//            if hex_char1 >= "0" && hex_char1 <= "9" {
//                array[i] = (hex_char1 - 48) * pow(16, length - 1 - i)
//            } else if hex_char1 >= "A" && hex_char1 <= "F" {
//                array[i] = (Int(hex_char1 - 65) + 10) * pow(16, length - 1 - i)
//            } else {
//                array[i] = (Int(hex_char1 - 97) + 10) * pow(16, length - 1 - i)
//            }
//        }
//        for k in 0..<length {
//            Do += array[k]
//        }
//        return Do
//    }
//
//    /**
//     *  清理绑定设备的缓存
//     */
//    class func clearDeviceBangding() {
//        //    [ADASaveDefaluts remobeObjectForKey:AllDEVICETYPE];
//        ADASaveDefaluts.remobeObject(forKey: kLastDeviceUUID)
//        if CositeaBlueTooth.sharedInstance().connectUUID {
//            CositeaBlueTooth.sharedInstance().disConnected(withUUID: CositeaBlueTooth.sharedInstance().connectUUID)
//        }
//    }
//
//    /**
//     * 截取时间字符串的一部分
//     */
//    class func timecutting(_ timeString: String?) -> String? {
//        var string = ""
//        if (timeString?.count ?? 0) > 18 {
//            string = (timeString as NSString?)?.substring(with: NSRange(location: 11, length: 5)) ?? ""
//        }
//        return string
//    }
//
//    /**
//     *十六进制转二进制
//     */
//    class func getBinaryByhex(_ hex: String?) -> String? {
//        var hexDic: [AnyHashable : Any] = [:]
//        hexDic = [AnyHashable : Any](minimumCapacity: 16)
//        hexDic["0"] = "0000"
//        hexDic["1"] = "0001"
//        hexDic["2"] = "0010"
//        hexDic["3"] = "0011"
//        hexDic["4"] = "0100"
//        hexDic["5"] = "0101"
//        hexDic["6"] = "0110"
//        hexDic["7"] = "0111"
//        hexDic["8"] = "1000"
//        hexDic["9"] = "1001"
//        hexDic["A"] = "1010"
//        hexDic["B"] = "1011"
//        hexDic["C"] = "1100"
//        hexDic["D"] = "1101"
//        hexDic["E"] = "1110"
//        hexDic["F"] = "1111"
//        var binaryString = ""
//        for i in 0..<(hex?.count ?? 0) {
//            let rage: NSRange
//            rage.length = 1
//            rage.location = i
//            var key = (hex as NSString?)?.substring(with: rage)
//            key = key?.uppercased()
//
//            //        NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
//            //        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
//            binaryString += hexDic[key] as? String ?? ""
//        }
//        //adaLog(@"转化后的二进制为:%@",binaryString);
//        return binaryString
//    }
//
//    /**
//     *二进制转十六进制
//     */
//    class func getHexByBinary(_ Binary: String?) -> String? {
//        var binaryDic: [AnyHashable : Any] = [:]
//        binaryDic = [AnyHashable : Any](minimumCapacity: 16)
//        binaryDic["0000"] = "0"
//        binaryDic["0001"] = "1"
//        binaryDic["0010"] = "2"
//        binaryDic["0011"] = "3"
//        binaryDic["0100"] = "4"
//        binaryDic["0101"] = "5"
//        binaryDic["0110"] = "6"
//        binaryDic["0111"] = "7"
//        binaryDic["1000"] = "8"
//        binaryDic["1001"] = "9"
//        binaryDic["1010"] = "A"
//        binaryDic["1011"] = "B"
//        binaryDic["1100"] = "C"
//        binaryDic["1101"] = "D"
//        binaryDic["1110"] = "E"
//        binaryDic["1111"] = "F"
//        var hexString = ""
//
//        var i = 0
//        while i < (Binary?.count ?? 0) {
//            let rage: NSRange
//            rage.length = 4
//            rage.location = i
//            let key = (Binary as NSString?)?.substring(with: rage)
//            //  //adaLog(@"%@",[NSString stringWithFormat:@"%@",[binaryDic objectForKey:key]]);
//            //        hexString = [NSString stringWithFormat:@"%@%@",hexString,[NSString stringWithFormat:@"%@",[binaryDic objectForKey:key]]];
//            hexString += binaryDic[key] as? String ?? ""
//            i = i + 4
//        }
//        //adaLog(@"转化后的 16 进制为:%@",hexString);
//        return hexString
//    }
//
//    /**
//     * 把网络请求的数据转为可以发给手表的数据值
//     */
//    class func weather(toWatch weather /*把网络请求的数据转为可以发给手表的数据值 */: PZWeatherModel?) -> PZWeatherModel? {
//
//        let watchWeather = PZWeatherModel()
//        watchWeather.weatherDate = weather?.weatherDate
//        watchWeather.realtimeShi = weather?.realtimeShi
//        watchWeather.weather_city = weather?.weather_city
//        watchWeather.city_id = weather?.city_id
//        if kHCH.weatherLocation == 1 {
//            //adaLog(@"  国内的天气。不需要英文转中文");
//            if weather?.weatherContent != nil {
//                watchWeather.weatherType = self.rangeWeather(weather?.weatherContent)
//            } else {
//                watchWeather.weatherType = "0"
//            }
//        } else {
//            var weatherContent = ""
//            if kHCH.languageNum != 0 {
//                weatherContent = AllTool.aheadEnglish(toChinese: weather?.weatherCode) ?? ""
//                watchWeather.weatherType = self.rangeWeather(weatherContent)
//            } else {
//                watchWeather.weatherType = self.rangeWeather(weather?.weatherContent)
//            }
//        }
//        watchWeather.weatherContent = weather?.weatherContent
//
//        //    adaLog(@"watchWeather.weatherContent  == %@",watchWeather.weatherContent);
//
//        var TArray: [AnyHashable] = []
//        if let aMin = weather?.weatherMin {
//            TArray.append(aMin)
//        }
//        if let aMax = weather?.weatherMax {
//            TArray.append(aMax)
//        }
//        if weather?.weather_currentTemp != nil {
//            if let aTemp = weather?.weather_currentTemp {
//                TArray.append(aTemp)
//            }
//        } else {
//            if let aMax = weather?.weatherMax {
//                TArray.append(aMax)
//            }
//        }
//        watchWeather.tempArray = TArray
//        //紫外线
//        if weather?.weather_uv != nil {
//            watchWeather.weather_uv = self.rangeUV(weather?.weather_uv)
//        } else {
//            watchWeather.weather_uv = nil
//        }
//        watchWeather.weather_fl = self.findNum(fromStr: weather?.weather_fl)
//        watchWeather.weather_fx = self.findWeather_fx(weather?.weather_fx)
//        watchWeather.weather_aqi = weather?.weather_aqi
//        watchWeather.weatherCode = weather?.weatherCode
//        watchWeather.weatherMax = weather?.weatherMax
//        watchWeather.weatherMin = weather?.weatherMin
//        watchWeather.weather_currentTemp = weather?.weather_currentTemp
//        return watchWeather
//    }
//
//    /**
//     *  天气内容判断
//     */
//    class func rangeWeather(_ weather: String?) -> String? {
//        //     if(kHCH.LanguageNum == 1)  //英文
//        //    {
//        //        weather = [self englishToChinese:weather];//英文转中文
//        //    }
//        var str = "0"
//        if weather != nil {
//            let range: NSRange? = (weather as NSString?)?.range(of: "转", options: .caseInsensitive)
//            if Int(range?.location ?? 0) != NSNotFound {
//                //weather = [weather substringWithRange:NSMakeRange(0, range.location)];
//                //有   转字。返回严重的天气
//                var weather1 = (weather as NSString?)?.substring(with: NSRange(location: 0, length: Int(range?.location ?? 0)))
//                var weather2 = (weather as NSString?)?.substring(with: NSRange(location: Int(range?.location ?? 0) + 1, length: (weather?.count ?? 0) - (Int(range?.location ?? 0) + 1)))
//                weather1 = self.rangeWeather(weather1)
//                weather2 = self.rangeWeather(weather2)
//
//                if Int(truncating: weather1 ?? "") ?? 0 > Int(truncating: weather2 ?? "") ?? 0 {
//                    return weather1
//                } else {
//                    return weather2
//                }
//            }
//
//            if (weather == "多云") {
//                str = "1"
//            } else if (weather == "阴") {
//                str = "2"
//            } else if (weather == "阵雨") {
//                str = "3"
//            } else if (weather == "小雨") {
//                str = "4"
//            } else if (weather == "小到中雨") {
//                str = "5"
//            } else if (weather == "中雨") {
//                str = "6"
//            } else if (weather == "中到大雨") {
//                str = "7"
//            } else if (weather == "大雨") {
//                str = "8"
//            } else if (weather == "暴雨") {
//                str = "9"
//            } else if (weather == "大暴雨") {
//                str = "10"
//            } else if (weather == "特大暴雨") {
//                str = "11"
//            } else if (weather == "冻雨") {
//                str = "12"
//            } else if (weather == "雷阵雨") {
//                str = "13"
//            } else if (weather == "雷阵雨伴有冰雹") {
//                str = "14"
//            } else if (weather == "雷雨") {
//                str = "15"
//            } else if (weather == "冰雹") {
//                str = "16"
//            } else if (weather == "雨带雪") {
//                str = "17"
//            } else if (weather == "阵雪") {
//                str = "18"
//            } else if (weather == "小雪") {
//                str = "19"
//            } else if (weather == "小到中雪") {
//                str = "20"
//            } else if (weather == "中雪") {
//                str = "21"
//            } else if (weather == "中到大雪") {
//                str = "22"
//            } else if (weather == "大雪") {
//                str = "23"
//            } else if (weather == "冻雨") {
//                str = "24"
//            } else if (weather == "浮尘") {
//                str = "25"
//            } else if (weather == "沙尘暴") {
//                str = "26"
//            } else if (weather == "扬沙") {
//                str = "27"
//            } else if (weather == "霾") {
//                str = "28"
//            } else if (weather == "雾") {
//                str = "29"
//            } else if (weather == "霰") {
//                str = "30"
//            } else if (weather == "飑线") {
//                str = "31"
//            } else if (weather == "少云") {
//                str = "1"
//            } else if (weather == "晴间多云") {
//                str = "2"
//            } else if (weather == "毛毛雨/细雨") {
//                str = "4"
//            } else if (weather == "强阵雨") || (weather == "雷阵雨") || (weather == "强雷阵雨") || (weather == "雷阵雨伴有冰雹") || (weather == "极端降雨") {
//                str = "8"
//            } else if (weather == "雨雪天气") || (weather == "阵雨夹雪") || (weather == "雨夹雪") {
//                str = "17"
//            } else if (weather == "暴雪") {
//                str = "23"
//            } else if (weather == "薄雾") {
//                str = "25"
//            } else if (weather == "强沙尘暴") {
//                str = "26"
//            } else if (weather == "扬沙") {
//                str = "27"
//            } else if (weather == "飑线") {
//                str = "31"
//            }
//        }
//        return str
//    }
//
//    /**
//     
//     不是中文 ，提前把天气转成中文
//     
//     **/
//    class func aheadEnglish(toChinese english: String?) -> String? {
//        var chinese = ""
//        if (english == "100") {
//            chinese = "晴"
//        } else if (english == "101") {
//            chinese = "多云"
//        } else if (english == "102") {
//            chinese = "少云"
//        } else if (english == "103") {
//            chinese = "晴间多云"
//        } else if (english == "104") {
//            chinese = "阴"
//        } else if (english == "200") {
//            chinese = "有风"
//        } else if (english == "201") {
//            chinese = "平静"
//        } else if (english == "202") {
//            chinese = "微风"
//        } else if (english == "203") {
//            chinese = "和风"
//        } else if (english == "204") {
//            chinese = "清风"
//        } else if (english == "205") {
//            chinese = "强风/劲风"
//        } else if (english == "206") {
//            chinese = "疾风"
//        } else if (english == "207") {
//            chinese = "大风"
//        } else if (english == "208") {
//            chinese = "烈风"
//        } else if (english == "209") {
//            chinese = "风暴"
//        } else if (english == "210") {
//            chinese = "狂爆风"
//        } else if (english == "211") {
//            chinese = "飓风"
//        } else if (english == "212") {
//            chinese = "龙卷风"
//        } else if (english == "213") {
//            chinese = "热带风暴"
//        } else if (english == "300") {
//            chinese = "阵雨"
//        } else if (english == "301") {
//            chinese = "强阵雨"
//        } else if (english == "302") {
//            chinese = "雷阵雨"
//        } else if (english == "303") {
//            chinese = "强雷阵雨"
//        } else if (english == "304") {
//            chinese = "雷阵雨伴有冰雹"
//        } else if (english == "305") {
//            chinese = "小雨"
//        } else if (english == "306") {
//            chinese = "中雨"
//        } else if (english == "307") {
//            chinese = "大雨"
//        } else if (english == "308") {
//            chinese = "极端降雨\t"
//        } else if (english == "309") {
//            chinese = "毛毛雨/细雨"
//        } else if (english == "310") {
//            chinese = "暴雨"
//        } else if (english == "311") {
//            chinese = "大暴雨"
//        } else if (english == "312") {
//            chinese = "特大暴雨"
//        } else if (english == "313") {
//            chinese = "冻雨"
//        } else if (english == "400") {
//            chinese = "小雪"
//        } else if (english == "401") {
//            chinese = "中雪"
//        } else if (english == "402") {
//            chinese = "大雪"
//        } else if (english == "403") {
//            chinese = "暴雪"
//        } else if (english == "404") {
//            chinese = "雨夹雪"
//        } else if (english == "405") {
//            chinese = "雨雪天气"
//        } else if (english == "406") {
//            chinese = "阵雨夹雪"
//        } else if (english == "407") {
//            chinese = "阵雪"
//        } else if (english == "500") {
//            chinese = "薄雾"
//        } else if (english == "501") {
//            chinese = "雾"
//        } else if (english == "502") {
//            chinese = "霾"
//        } else if (english == "503") {
//            chinese = "扬沙"
//        } else if (english == "504") {
//            chinese = "浮尘"
//        } else if (english == "507") {
//            chinese = "沙尘暴"
//        } else if (english == "508") {
//            chinese = "强沙尘暴"
//        } else if (english == "900") {
//            chinese = "热"
//        } else if (english == "901") {
//            chinese = "冷"
//        } else {
//            chinese = "未知"
//        }
//
//        return chinese
//    }
//
//    /**
//     *把日期截取生成  时 日 月 年
//     */
//    class func weatherDate(toArray date: String?) -> [AnyHashable]? {
//        var arr: [AnyHashable] = []
//        if date != nil {
//            let arrayDay = date?.components(separatedBy: "-")
//            arr.append(arrayDay?[2]) //日
//            arr.append(arrayDay?[1]) //月
//            arr.append(arrayDay?[0]) //年
//        }
//        return arr
//    }
//
//    /**
//     *       天气范围   拆分字符串成数组
//     *
//     **/
//    class func temp(toArray date: String?) -> [AnyHashable]? {
//        var arr: [AnyHashable] = []
//        if date != nil {
//            //温度
//            let array = date?.components(separatedBy: "~") //从字符~中分隔成2个元素的数组
//            let hight = array?[0].replacingOccurrences(of: "℃", with: "")
//            let di = array?[1].replacingOccurrences(of: "℃", with: "")
//            //adaLog(@"hight =%@,di =%@",hight,di);
//            arr.append(hight)
//            arr.append(di)
//        }
//
//        return arr
//    }
//
//    /**
//     *
//     *取出其中的数字
//     **/
//    class func findNum(fromStr weather_fl: String?) -> String? {
//
//        //NSString *originalString = @"小于3级";
//        //    NSMutableString *numberString = [[NSMutableString alloc] init];
//        //    if (weather_fl)
//        //    {
//        //        // Intermediate
//        //        NSString *tempStr;
//        //        NSScanner *scanner = [NSScanner scannerWithString:weather_fl];
//        //        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//        //
//        //        while (![scanner isAtEnd]) {
//        //            // Throw away characters before the first number.
//        //            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
//        //
//        //            // Collect numbers.
//        //            [scanner scanCharactersFromSet:numbers intoString:&tempStr];
//        //            [numberString appendString:tempStr];
//        //            tempStr = @"";
//        //        }
//        //    }
//        var numberString = ""
//        if kHCH.weatherLocation == 1 {
//            numberString = String(format: "%ld", Int(truncating: weather_fl ?? "") ?? 0)
//        } else {
//            if (weather_fl == "平静") {
//                numberString = "0"
//            } else if (weather_fl == "有风") {
//                numberString = "1"
//            } else if (weather_fl == "微风") {
//                numberString = "3"
//            } else if (weather_fl == "和风") {
//                numberString = "4"
//            } else if (weather_fl == "强风") || (weather_fl == "劲风") {
//                numberString = "6"
//            } else if (weather_fl == "疾风") {
//                numberString = "7"
//            } else if (weather_fl == "大风") {
//                numberString = "8"
//            } else if (weather_fl == "清风") || (weather_fl == "烈风") {
//                numberString = "9"
//            } else if (weather_fl == "风暴") || (weather_fl == "狂爆风") {
//                numberString = "10"
//            } else if (weather_fl == "飓风") {
//                numberString = "12"
//            } else if (weather_fl == "龙卷风") {
//                numberString = "13"
//            } else if (weather_fl == "热带风暴") {
//                numberString = "14"
//            } else {
//                numberString = "3"
//            }
//        }
//        return numberString
//
//    }
//
//    /**
//     *      判断其中的 风向
//     *
//     **/
//    class func findWeather_fx(_ fx: String?) -> String? {
//
//        //    NSAssert([fx isKindOfClass:[NSString class]],@"是这个类型 = ");
//        let noHave: Bool = self.isChinese(fx)
//        if !noHave {
//            fx = self.englishWind(fx) //把英文的风向的简称改成中文 用于匹配
//        }
//        if fx != nil {
//            let fxLength: Int = fx?.count ?? 0
//            if fxLength > 2 {
//                fx = (fx as NSString?)?.substring(with: NSRange(location: 0, length: 2))
//            }
//            let rang: NSRange? = (fx as NSString?)?.range(of: "风", options: .caseInsensitive)
//            if Int(rang?.location ?? 0) != NSNotFound {
//                fx = (fx as NSString?)?.substring(with: NSRange(location: 0, length: 1))
//            }
//        }
//
//
//        var weather_fx = "0"
//        if (fx == "东") {
//            weather_fx = "1"
//        } else if (fx == "南") {
//            weather_fx = "2"
//        } else if (fx == "西") {
//            weather_fx = "3"
//        } else if (fx == "北") {
//            weather_fx = "4"
//        } else if (fx == "东南") {
//            weather_fx = "5"
//        } else if (fx == "东北") {
//            weather_fx = "6"
//        } else if (fx == "西南") {
//            weather_fx = "7"
//        } else if (fx == "西北") {
//            weather_fx = "8"
//        }
//
//        return weather_fx
//
//    }
//
//    /**
//     *      十进制转二进制
//     *
//     **/
//    class func toBinarySystem(withDecimalSystem decimal: String?) -> String? {
//        var num = Int(truncating: decimal ?? "") ?? 0
//        var remainder: Int = 0 //余数
//        var divisor: Int = 0 //除数
//
//        var prepare = ""
//
//        while true {
//            remainder = num % 2
//            divisor = num / 2
//            num = divisor
//            prepare = prepare + ("\(remainder)")
//
//            if divisor == 0 {
//                break
//            }
//        }
//
//        var result = ""
//        var i = prepare.count - 1
//        while i >= 0 {
//            result = result + ("\((prepare as NSString).substring(with: NSRange(location: i, length: 1)))")
//            i -= 1
//        }
//
//        return result
//    }
//
//    /**
//     *      二进制转十进制
//     *
//     **/
//    class func toDecimalSystem(withBinarySystem binary: String?) -> String? {
//        var ll: Int = 0
//        var temp: Int = 0
//        for i in 0..<(binary?.count ?? 0) {
//            temp = Int(truncating: ((binary as NSString?)?.substring(with: NSRange(location: i, length: 1)) ?? "")) ?? 0
//            temp = temp * powf(2, (binary?.count ?? 0) - i - 1)
//            ll += temp
//        }
//
//        let result = "\(ll)"
//
//        return result
//    }
//
//    /**
//     *      十六进制字符串转化为数组  。用于发给蓝牙
//     *
//     **/
//    class func hex(toArray hex: String?) -> [AnyHashable]? {
//        var Arr: [AnyHashable] = []
//        var hexString = hex ?? ""
//
//        hexString = self.eightEight(hexString) ?? ""
//
//        var a: Int = 0
//        var b: Int = 0
//        var c: Int = 0
//        var d: Int = 0
//        a = self.hexStringTranslate(toDoInteger: (hexString as NSString).substring(with: NSRange(location: 0, length: 2)))
//        b = self.hexStringTranslate(toDoInteger: (hexString as NSString).substring(with: NSRange(location: 2, length: 2)))
//        c = self.hexStringTranslate(toDoInteger: (hexString as NSString).substring(with: NSRange(location: 4, length: 2)))
//        d = self.hexStringTranslate(toDoInteger: (hexString as NSString).substring(with: NSRange(location: 6, length: 2)))
//        if b != 0 {
//            Arr.append(contentsOf: [String(format: "%ld", b), String(format: "%ld", c), String(format: "%ld", d), String(format: "%ld", a)])
//        } else if c != 0 {
//            Arr.append(contentsOf: [String(format: "%ld", c), String(format: "%ld", d), String(format: "%ld", a), String(format: "%ld", b)])
//        } else if d != 0 {
//            Arr.append(contentsOf: [String(format: "%ld", d), String(format: "%ld", a), String(format: "%ld", b), String(format: "%ld", c)])
//        } else {
//            Arr.append(contentsOf: [String(format: "%ld", a), String(format: "%ld", b), String(format: "%ld", c), String(format: "%ld", d)])
//        }
//        return Arr
//    }
//
//    /**
//     *      十进制字符串转化为数组  。用于发给蓝牙
//     *
//     **/
//    class func number(toArray number: Int) -> [AnyHashable]? {
//        //    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",number]];
//
//        //    Arr = [self hexToArray:hexString];
//        var Arr: [AnyHashable] = []
//
//        for i in 0..<4 {
//            //  int  byte = (Byte)(number>>(24-i*8));
//            let byte = Int((number >> i * 8) as? Byte ?? 0) & 0xff
//            //   NSLog(@"byte - %d",byte);
//            Arr.append("\(byte)")
//        }
//        return Arr
//    }
//
//    /**
//     *  开始上传数据
//     */
//    class func startUpData() {
//        if Int(ADASaveDefaluts[LOGINTYPE] ?? 0) != 3 {
//            TimingUploadData.sharedInstance()
//        }
//    }
//
//    /**
//     *
//     清除设备类型
//     */
//    class func clearDeviceType() {
//        ADASaveDefaluts.remobeObject(forKey: AllDEVICETYPE)
//        ADASaveDefaluts.remobeObject(forKey: kLastDeviceUUID)
//        if CositeaBlueTooth.sharedInstance().connectUUID {
//            CositeaBlueTooth.sharedInstance().disConnected(withUUID: CositeaBlueTooth.sharedInstance().connectUUID)
//        }
//    }
//
//    /**
//     *
//     arrayToString    11，22，33，44,
//     */
//    class func array(toString2 array: [Any]?) -> String? {
//        if array?.count == 0 {
//            return ""
//        }
//        var string = ""
//        for i in 0..<(array?.count ?? 0) {
//            string += "\(array?[i]),"
//        }
//
//        return string
//    }
//
//    /**
//     *
//     arrayToString    11，22，33，44
//     */
//    class func array(toString array: [Any]?) -> String? {
//        if array?.count == 0 {
//            return ""
//        }
//        var string = ""
//        for i in 0..<(array?.count ?? 0) {
//            if (array?.count ?? 0) - 1 == i {
//
//                string += "\(array?[i])"
//            } else {
//                string += "\(array?[i]),"
//            }
//            // //adaLog(@"i=%d",i);
//        }
//
//        return string
//    }
//
//    /**
//     *
//     macToString    mac地址转化为字符串
//     */
//    class func mac(toMacString string: String?) -> String? {
//        if string == nil {
//            //从名字中截取mac地址。
//            var deviceName = ADASaveDefaluts[kLastDeviceNAME] as? String
//            let array = self.getRangeStr(deviceName, findText: "_")
//            if array?.count == 1 {
//                let loc = Int(array?.first ?? 0)
//                deviceName = (deviceName as NSString?)?.substring(with: NSRange(location: loc + 1, length: (deviceName?.count ?? 0) - loc - 1))
//                string = self.deviceName(toGetMacAddress: deviceName)
//            } else {
//                string = DEFAULTDEVICEID
//            }
//        } else {
//            if (string?.count ?? 0) > 12 {
//                let range: NSRange? = (string as NSString?)?.range(of: "B7", options: .caseInsensitive)
//                assert(Int(range?.length ?? 0) > 0, "mac 出现奇怪的问题了。\(string ?? "")")
//                //            if (range.length>0)
//                //            {
//                //                //一般情况。就是走这个位置
//                //                string = [string substringWithRange:NSMakeRange(range.location+range.length,12)];
//                //            }
//                //            else
//                //            {
//                string = (string as NSString?)?.substring(with: NSRange(location: (string?.count ?? 0) - 12, length: 12))
//                //            }
//            } else {
//                string = DEFAULTDEVICEID
//            }
//        }
//        string = string?.uppercased() //全部变大写
//        return string
//    }
//
//    /**
//     *
//     macToString    data  mac地址转化为字符串
//     */
//    class func macData(toString macAddressData: Data?) -> String? {
//        if macAddressData == nil {
//            return nil
//        }
//        let byte = macAddressData?.bytes as? Byte
//        var string = ""
//        if macAddressData != nil {
//            for i in 0..<(macAddressData?.count ?? 0) {
//                var string1: String? = nil
//                if let anI = byte?[i] {
//                    string1 = String(format: "%X", anI)
//                }
//                if (string1?.count ?? 0) == 1 {
//                    string = string + ("0\(string1 ?? "")")
//                } else {
//                    string = string + (string1 ?? "")
//                }
//            }
//        }
//        //    //adaLog(@"macAddress - %@",string);
//        let correct: Bool = self.checkMacAddressCorrect(string)
//        if !correct {
//            string = nil
//        }
//        if string != "" {
//            string = string.uppercased()
//        }
//        return string
//    }
//
//    /**
//     *
//     macToString    data  mac地址转化为字符串
//     */
//    class func savePeripheral(_ model: PerModel?) -> Bool {
//        if model?.macAddress == nil {
//            return false
//        }
//        let peripheralArray = SQLdataManger.getInstance().queryALLData(withTable: Peripheral_Table)
//        var isHave = false
//        for dict: [AnyHashable : Any] in peripheralArray as? [[AnyHashable : Any]] ?? [] {
//            if (dict[macAddress_per] == model?.macAddress) {
//                isHave = true
//            }
//        }
//        if isHave {
//            return false
//        }
//        var dict: [AnyHashable : Any] = [:]
//        var rssiStr = ""
//        var deviceNameTemp = ""
//        var deviceIdTemp = ""
//        if abs(model?.rssi) > 0 {
//            if let aRSSI = model?.rssi {
//                rssiStr = "\(aRSSI)"
//            }
//        } else {
//            rssiStr = "0"
//        }
//        if model?.deviceName != nil {
//            deviceNameTemp = model?.deviceName ?? ""
//        } else {
//            deviceNameTemp = "0"
//        }
//        deviceIdTemp = String(format: "%ld", SQLdataManger.getInstance().queryPeripheralALL())
//        dict[deviceId_per] = deviceIdTemp
//        dict[macAddress_per] = model?.macAddress
//        dict[UUIDString_per] = model?.uuidString
//        dict[RSSI_per] = rssiStr
//        dict[deviceName_per] = deviceNameTemp
//        let insert = SQLdataManger.getInstance().insertSignalData(toTable: Peripheral_Table, withData: dict)
//        return insert
//    }
//
//    /**
//     *
//     检查到设置中的外设。没有收到广播。就从数据库中取得macAddress  保存本地
//     */
//    class func setMacaddress(_ uuid: String?) -> Bool {
//        // if (!uuid) {
//        //    return NO;
//        //}
//        let dictionary = SQLdataManger.getInstance().getPeripheralWith(uuid)
//        #if false
//        if !dictionary {
//            return false
//        }
//        #endif
//        ADASaveDefaluts[kLastDeviceMACADDRESS] = dictionary[macAddress_per]
//        return true
//    }
//
//    /**
//     *
//     字典转json格式字符串：
//     **/
//    class func dictionary(toJson dic: [AnyHashable : Any]?) -> String? {
//        var parseError: Error? = nil
//
//        var jsonData: Data? = nil
//        if let aDic = dic {
//            jsonData = try? JSONSerialization.data(withJSONObject: aDic, options: .prettyPrinted)
//        }
//
//        if let aData = jsonData {
//            return String(data: aData, encoding: .utf8)
//        }
//        return nil
//
//    }
//
//    /*!
//     
//     * @brief 把格式化的JSON格式的字符串转换成字典
//     
//     * @param jsonString JSON格式的字符串
//     
//     * @return 返回字典
//     
//     */
//    class func dictionary(withJsonString jsonString: String?) -> [AnyHashable : Any]? {
//        if jsonString == nil {
//            return nil
//        }
//        let jsonData: Data? = jsonString?.data(using: .utf8)
//        var err: Error?
//        var dic: [AnyHashable : Any]? = nil
//        if let aData = jsonData {
//            dic = try? JSONSerialization.jsonObject(with: aData, options: .mutableContainers) as? [AnyHashable : Any]
//        }
//        if err != nil {
//            //adaLog(@"json解析失败：%@",err);
//            return nil
//        }
//        return dic
//    }
//
//    /*!
//     
//     * @brief 制造180分钟的0值。
//     
//     * @param
//     
//     * @return NSMutableArray
//     
//     */
//    class func makeArrayEight() -> [AnyHashable]? {
//
//        var arr: [AnyHashable] = []
//        for i in 0..<180 {
//            arr.append("0")
//        }
//        return arr
//    }
//
//    /*!
//     * @brief 制造144分钟的0值。
//     0-清醒 1-浅睡 2-深睡
//     * @return NSMutableArray
//     */
//    class func makeSleepArray() -> [AnyHashable]? {
//
//        var arr: [AnyHashable] = []
//        for i in 0..<144 {
//            arr.append("3")
//        }
//        return arr
//    }
//
//    // 判断字符串中是否有中文
//    class func isChinese(_ str: String?) -> Bool {
//        for i in 0..<(str?.count ?? 0) {
//            let a = Int(str?[str?.index(str?.startIndex, offsetBy: i)] ?? 0)
//            if a >= 0x4e00 && a < 0x9fff {
//                return true
//            }
//        }
//        return false
//    }
//
//    /*
//     校验mac地址的 正确性  -- 长度
//     * @param mac地址
//     
//     * @return BOOL
//     */
//    class func checkMacAddressLength(_ macString: String?) -> Bool {
//        var correct = true
//        if (macString?.count ?? 0) == 6 {
//            correct = false
//        }
//        return correct
//    }
//
//    /*
//     校验mac地址的正确性
//     * @param mac地址
//     
//     * @return BOOL
//     */
//    class func checkMacAddressCorrect(_ macString: String?) -> Bool {
//        var correct = true
//        let b7Range: NSRange? = (macString as NSString?)?.range(of: "B7", options: .caseInsensitive)
//        let b6Range: NSRange? = (macString as NSString?)?.range(of: "B6", options: .caseInsensitive)
//        if Int(b7Range?.location ?? 0) == NSNotFound {
//            correct = false
//        }
//        if Int(b6Range?.location ?? 0) == NSNotFound {
//            correct = false
//        }
//        if ((macString?.count ?? 0) - Int(b7Range?.location ?? 0)) < 14 {
//            correct = false
//        }
//        if ((macString?.count ?? 0) - Int(b6Range?.location ?? 0)) < 6 {
//            correct = false
//        }
//        return correct
//    }
//
//    /*
//     核实MacAddress是否需要修正
//     * @param mac地址
//     
//     * @return BOOL
//     */
//    class func isNeedAmendMacAddress(_ macString: String?) -> Bool {
//        var isNeed = false
//        if macString == nil {
//            isNeed = true
//        }
//        if (macString == DEFAULTDEVICEID) {
//            isNeed = true
//        }
//        return isNeed
//    }
//
//    /*
//     保存macAddress之前的获取
//     
//     * @return macAddress
//     */
//    class func amendMacAddressGetAddress() -> String? {
//
//        var deviceId = ""
//
//        let macStr = ADASaveDefaluts[kLastDeviceMACADDRESS] as? String
//        if macStr == nil {
//            //从名字中截取mac地址。
//            var deviceName = ADASaveDefaluts[kLastDeviceNAME] as? String
//            let array = self.getRangeStr(deviceName, findText: "_")
//            if array?.count == 1 {
//                deviceName = (deviceName as NSString?)?.substring(with: NSRange(location: Int(array?[0]) + 1, length: (deviceName?.count ?? 0) - Int(array?[0]) - 1))
//                deviceId = self.deviceName(toGetMacAddress: deviceName) ?? ""
//                //            if(deviceName.length == 10)
//                //            {
//                //                deviceName = [NSString stringWithFormat:@"00%@",deviceName];
//                //            }
//                //            else if (deviceName.length == 8)
//                //            {
//                //                deviceName = [NSString stringWithFormat:@"0000%@",deviceName];
//                //            }
//                //            deviceId =  deviceName;
//            } else {
//                deviceId = DEFAULTDEVICEID
//            }
//        } else {
//            deviceId = macStr ?? ""
//        }
//
//        return deviceId
//    }
//
//    /*
//     pm25   用于计算空气质量
//     
//     * @return pm25
//     */
//    class func pm25(toString number: Int) -> String? {
//        var quality = ""
//        if number <= 50 {
//            quality = "优"
//        } else if number > 50 && number <= 100 {
//            quality = "良"
//        } else {
//            quality = "差"
//        }
//        //    else if (number>100 && number<=150)
//        //    {
//        //        quality = @"轻微污染";
//        //    }
//        //    else if (number>150 && number<=200)
//        //    {
//        //        quality = @"轻度污染";
//        //    }
//        //    else if (number>200 && number<=250)
//        //    {
//        //        quality = @"中度污染";
//        //    }
//        //    else if (number>250 && number<=300)
//        //    {
//        //        quality = @"中度重污染";
//        //    }
//        //    else
//        //    {
//        //        quality = @"重度污染";
//        //    }
//        return quality
//    }
//
//    //经纬度分出
//    class func getLatLonDegree(_ LLString: String?) -> [Any]? {
//        let locationStr = LLString
//        let temp = locationStr?.components(separatedBy: ",")
//        //    NSString *latitudeStr = temp[0];
//        //    NSString *longitudeStr = temp[1];
//        return temp
//    }
//
//    /*
//     获取运动目标时间
//     
//     * @return target
//     */
//    class func getSportTargetTime(_ targetTime: String?) -> String? {
//        var target = ""
//        //    NSString *str = [ADASaveDefaluts objectForKey:MAPSPORTTARGET];
//        //adaLog(@"targetTime - %@",targetTime);
//        if targetTime == nil {
//            return "00:30:00"
//        }
//        let range1: NSRange? = (targetTime as NSString?)?.range(of: "H", options: .caseInsensitive)
//        let str1 = (targetTime as? NSString)?.substring(to: range1?.location)
//        let range2: NSRange? = (targetTime as NSString?)?.range(of: "min", options: .caseInsensitive)
//        let str2 = (targetTime as NSString?)?.substring(with: NSRange(location: Int(range2?.location ?? 0) - 2, length: 2))
//        target = "\(str1 ?? ""):\(str2 ?? ""):00"
//
//        //adaLog(@"target - %@",target);
//
//        return target
//        //  [ADASaveDefaluts setObject:[NSString stringWithFormat:@"%@H%@min",self.pickerViewHour,self.pickerViewMinute] forKey:MAPSPORTTARGET];//保存地图运动目标
//    }
//
//    /**
//     
//     *  是直接使用
//     
//     */
//    class func isDirectUse() -> Bool {
//        var isDown = false
//        if Int(ADASaveDefaluts[LOGINTYPE] ?? 0) == 3 {
//            isDown = true
//        } else {
//            isDown = false
//        }
//        return isDown
//    }
//
//    /**
//     
//     *  计算配速
//     
//     */
//    class func pacewithTime(_ time: Double, andRice rice: Double) -> String? {
//        var str = ""
//        if rice <= 0 {
//            str = "0'0\""
//        } else {
//            time = time / 60 //转为分钟
//            rice = rice / 1000 //转为公里
//            let fen = String(format: "%.2f", time / rice)
//            let array = fen.components(separatedBy: ".")
//            let miaos = Int((Double(Int(truncating: array[1]) ?? 0) * 0.6))
//            //adaLog(@"miaos-%ld",miaos);
//            str = String(format: "%@'%ld\"", array[0], miaos)
//            //adaLog(@"str-%@",str);
//            //adaLog(@"str-%@",str);
//        }
//
//        return str
//    }
//
//    /**
//     
//     *  过滤 255 和 0
//     
//     */
//    class func checkArray(_ array: [Any]?) -> [AnyHashable]? {
//        var arr: [AnyHashable] = []
//
//        for str: String? in array as? [String?] ?? [] {
//            let temp = Int(truncating: str ?? "") ?? 0
//            if !(temp == 0 || temp == 255) {
//                arr.append("\(temp)")
//            }
//        }
//
//        return arr
//    }
//
//// MARK: - 更换主页面
//    class func setRootViewController(_ viewController: UIViewController?, animationType: String?) {
//        let window = UIApplication.shared.windows[0] as? UIWindow
//        let animation = CATransition.animation()
//        animation.subtype = .fromRight
//        animation.duration = 0.25
//        animation.type = .push
//        window?.layer.add(animation, forKey: nil)
//        window?.rootViewController = viewController
//    }
//
//    //显示提示框
//    class func addActityIndicator(in view: UIView?, labelText labelString: String?, detailLabel detailString: String?) {
//
//        var hud: MBProgressHUD? = nil
//        if let aView = view {
//            hud = MBProgressHUD(view: aView)
//        }
//        //    hud.dimBackground = YES ;
//
//        if labelString != nil {
//            //        hud.labelText =  labelString ;
//            hud?.label.text = labelString
//        }
//        if detailString != nil {
//            //        hud.detailsLabelText = detailString ;
//            hud?.detailsLabel.text = detailString
//        }
//        hud?.square = true
//
//        if let aHud = hud {
//            view?.addSubview(aHud)
//        }
//        //    [hud show:YES];
//        hud?.show(animated: true)
//    }
//
//    //移除view
//    class func removeActityIndicator(from view: UIView?) {
//        for viewInView: UIView? in view?.subviews ?? [] {
//            if (viewInView is MBProgressHUD) {
//                viewInView?.removeFromSuperview()
//                break
//            }
//        }
//    }
//
//// MARK: - 弹出HUD
//    class func addActityText(in view: UIView?, text textString: String?, deleyTime times: Float) {
//        let hud = MBProgressHUD.showAdded(to: view, animated: true)
//        // Configure for text only and offset down
//        hud.mode = MBProgressHUDModeText
//        //    hud.labelText = textString ;
//        hud.label.text = textString
//        hud.margin = 10.0
//        //        hud.yOffset = 150.f;
//        hud.removeFromSuperViewOnHide = true
//        hud.square = true
//        //    [hud hide:YES afterDelay:times];
//        hud.hide(animated: true, afterDelay: times)
//    }
//
//    /**
//     *      通过过滤，把有效的睡眠中的清醒转成浅睡。开始睡眠后 30分钟，就算开始。超过30分钟的清醒才是清醒，否则清醒转浅睡
//     *
//     **/
//    class func filterSleep(toValid sleepArr: [Any]?) -> [AnyHashable]? {
//        if (sleepArr?.count ?? 0) <= 0 {
//            return sleepArr as? [AnyHashable]
//        }
//        var filter: Int = 0 //根据这个值判断是否开始过滤
//        var filtAwakeep: Int = 0 //根据这个值判断是否转化清醒
//
//        var resultArr: [AnyHashable]? = nil
//        if let anArr = sleepArr {
//            resultArr = anArr as? [AnyHashable]
//        }
//
//        var lightSleep: Int = 0
//        var awakeSleep: Int = 0
//        let deepSleep: Int = 0
//        var isBegin = false
//        var nightBeginTime: Int = 0
//        var nightEndTime: Int = 0
//        let sixFiler: Int = 0 //总过滤器。要求六点前过滤
//        for i in 0..<(sleepArr?.count ?? 0) {
//            let sleepState = Int(sleepArr?[i])
//            if sleepState != 0 && sleepState != 3 {
//                if isBegin == false {
//                    isBegin = true
//                    nightBeginTime = i
//                }
//                nightEndTime = i
//            }
//        }
//        if nightEndTime > nightBeginTime {
//            for i in nightBeginTime...nightEndTime {
//                let state = Int(sleepArr?[i])
//                if state == 2 {
//                    if filtAwakeep > 0 && filtAwakeep < 4 && filter > 3 && sixFiler < 49 {
//                        awakeSleep -= filtAwakeep
//                        lightSleep += filtAwakeep
//                        for te in 1...filtAwakeep {
//                            let atIndex: Int = i - te
//                            resultArr?[atIndex] = 1 //把清醒换成浅睡
//                        }
//                        filtAwakeep = 0
//                    } else {
//                        if filtAwakeep > 3 {
//                            filter = 1
//                            filtAwakeep = 0
//                        } else {
//                            filtAwakeep = 0
//                        }
//                    }
//                    deepSleep += 1
//                    //深睡
//                } else if state == 1 {
//                    if filtAwakeep > 0 && filtAwakeep < 4 && filter > 3 && sixFiler < 49 {
//                        awakeSleep -= filtAwakeep
//                        lightSleep += filtAwakeep
//                        for teb in 1...filtAwakeep {
//                            let atIndex: Int = i - teb
//                            resultArr?[atIndex] = 1 //把清醒换成浅睡
//                        }
//                        filtAwakeep = 0
//                    } else {
//                        if filtAwakeep > 3 {
//                            filter = 1
//                            filtAwakeep = 0
//                        } else {
//                            filtAwakeep = 0
//                        }
//                    }
//                    lightSleep += 1
//                    //浅睡
//                } else if state == 0 || state == 3 {
//                    awakeSleep += 1
//                    filtAwakeep += 1
//                    //清醒
//                }
//                filter += 1
//                sixFiler += 1
//            }
//        } else {
//            return sleepArr as? [AnyHashable]
//        }
//
//        return resultArr
//    }
//
//    /**
//     *   求平均值
//     */
//    /**
//     *   求平均值
//     */
//    /**
//     *   求最大值
//     */
//    /**
//     *   把心率带数组转化为分钟。用于以后的计算
//     */
//    //手表的过滤
//    //手环的过滤
//    //核实手环版本是否支持在线运动
//    // 十六进制字符串转换为十进制数
//    //清理绑定设备的缓存
//    //截取时间字符串的一部分
//    //十六进制转二进制
//    //二进制转十六进制
//    //天气内容判断
//    //英文的天气转化为中文的天气
//    class func english(toChinese english: String?) -> String? {
//        var chinese = ""
//        if (english == "Sunny/Clear") {
//            chinese = "晴"
//        } else if (english == "Cloudy") {
//            chinese = "多云"
//        } else if (english == "Few Clouds") {
//            chinese = "少云"
//        } else if (english == "Partly Cloudy") {
//            chinese = "晴间多云"
//        } else if (english == "Overcast") {
//            chinese = "阴"
//        } else if (english == "Windy") {
//            chinese = "有风"
//        } else if (english == "Calm") {
//            chinese = "平静"
//        } else if (english == "Light Breeze") {
//            chinese = "微风"
//        } else if (english == "Moderate/Gentle Breeze") {
//            chinese = "和风"
//        } else if (english == "Fresh Breeze") {
//            chinese = "清风"
//        } else if (english == "Strong Breeze") {
//            chinese = "强风/劲风"
//        } else if (english == "High Wind, Near Gale") {
//            chinese = "疾风"
//        } else if (english == "Gale") {
//            chinese = "大风"
//        } else if (english == "Strong Gale") {
//            chinese = "烈风"
//        } else if (english == "Storm") {
//            chinese = "风暴"
//        } else if (english == "Violent Storm") {
//            chinese = "狂爆风"
//        } else if (english == "Hurricane") {
//            chinese = "飓风"
//        } else if (english == "Tornado") {
//            chinese = "龙卷风"
//        } else if (english == "Tropical Storm") {
//            chinese = "热带风暴"
//        } else if (english == "Shower Rain") {
//            chinese = "阵雨"
//        } else if (english == "Heavy Shower Rain") {
//            chinese = "强阵雨"
//        } else if (english == "Thundershower") {
//            chinese = "雷阵雨"
//        } else if (english == "Heavy Thunderstorm") {
//            chinese = "强雷阵雨"
//        } else if (english == "Hail") {
//            chinese = "雷阵雨伴有冰雹"
//        } else if (english == "Light Rain") {
//            chinese = "小雨"
//        } else if (english == "Moderate Rain") {
//            chinese = "中雨"
//        } else if (english == "Heavy Rain") {
//            chinese = "大雨"
//        } else if (english == "Extreme Rain") {
//            chinese = "极端降雨\t"
//        } else if (english == "Drizzle Rain") {
//            chinese = "毛毛雨/细雨"
//        } else if (english == "Storm") {
//            chinese = "暴雨"
//        } else if (english == "Heavy Storm") {
//            chinese = "大暴雨"
//        } else if (english == "Severe Storm") {
//            chinese = "特大暴雨"
//        } else if (english == "Freezing Rain") {
//            chinese = "冻雨"
//        } else if (english == "Light Snow") {
//            chinese = "小雪"
//        } else if (english == "Moderate Snow") {
//            chinese = "中雪"
//        } else if (english == "Heavy Snow") {
//            chinese = "大雪"
//        } else if (english == "Snowstorm") {
//            chinese = "暴雪"
//        } else if (english == "Sleet") {
//            chinese = "雨夹雪"
//        } else if (english == "Rain And Snow") {
//            chinese = "雨雪天气"
//        } else if (english == "Shower Snow") {
//            chinese = "阵雨夹雪"
//        } else if (english == "Snow Flurry") {
//            chinese = "阵雪"
//        } else if (english == "Mist") {
//            chinese = "薄雾"
//        } else if (english == "Foggy") {
//            chinese = "雾"
//        } else if (english == "Haze") {
//            chinese = "霾"
//        } else if (english == "Sand") {
//            chinese = "扬沙"
//        } else if (english == "Dust") {
//            chinese = "浮尘"
//        } else if (english == "Duststorm") {
//            chinese = "沙尘暴"
//        } else if (english == "Sandstorm") {
//            chinese = "强沙尘暴"
//        } else if (english == "Hot") {
//            chinese = "热"
//        } else if (english == "Cold") {
//            chinese = "冷"
//        } else {
//            chinese = "未知"
//        }
//        //    else if([english isEqualToString:@"Storm"])
//        //    {chinese = @"暴雨";
//        //    }
//        //    else if([english isEqualToString:@"Storm"])
//        //    {chinese = @"暴雨";
//        //    }
//        return chinese
//    }
//
//    /**
//     
//     不是中文 ，提前把天气转成中文
//     
//     **/
//    //紫外线强度判断
//    class func rangeUV(_ UV: String?) -> String? {
//
//        let ishave: Bool = self.isChinese(UV)
//
//        var uv = "0"
//        if ishave {
//            if (UV == "中") || (UV == "中等") {
//                uv = "1"
//            } else {
//                uv = "2"
//            }
//        } else {
//            let grade = Int(truncating: UV ?? "") ?? 0
//            if grade > 6 {
//                uv = "2"
//            } else if grade > 3 && grade <= 5 {
//                uv = "1"
//            } else {
//                uv = "0"
//            }
//        }
//        return uv
//    }
//
//    /**
//     *
//     *取出其中的数字
//     **/
//    /**
//     *      判断其中的 风向
//     *
//     **/
//    //把英文的风向的简称改成中文 用于匹配
//    class func englishWind(_ english: String?) -> String? {
//        var wind = ""
//        wind = english?.replacingOccurrences(of: "E", with: "东") ?? ""
//        wind = english?.replacingOccurrences(of: "S", with: "南") ?? ""
//        wind = english?.replacingOccurrences(of: "W", with: "西") ?? ""
//        wind = english?.replacingOccurrences(of: "N", with: "北") ?? ""
//        return wind
//    }
//
//    /**
//     *把日期截取生成  时 日 月 年
//     */
//    /**
//     *       天气范围   拆分字符串成数组
//     *
//     **/
//    //  十进制转二进制
//    //  二进制转十进制
//    /**
//     *      十六进制字符串转化为数组
//     *
//     **/
//    class func eightEight(_ hexString: String?) -> String? {
//        var hexString = hexString
//
//        if (hexString?.count ?? 0) == 0 {
//            hexString ?? "" += "00000000"
//        } else if (hexString?.count ?? 0) == 1 {
//            hexString?.insert(contentsOf: "0000000", at: s.index(s.startIndex, offsetBy: 0))
//        } else if (hexString?.count ?? 0) == 2 {
//            hexString?.insert(contentsOf: "000000", at: s.index(s.startIndex, offsetBy: 0))
//        } else if (hexString?.count ?? 0) == 3 {
//            hexString?.insert(contentsOf: "00000", at: s.index(s.startIndex, offsetBy: 0))
//        } else if (hexString?.count ?? 0) == 4 {
//            hexString?.insert(contentsOf: "0000", at: s.index(s.startIndex, offsetBy: 0))
//        } else if (hexString?.count ?? 0) == 5 {
//            hexString?.insert(contentsOf: "000", at: s.index(s.startIndex, offsetBy: 0))
//        } else if (hexString?.count ?? 0) == 6 {
//            hexString?.insert(contentsOf: "00", at: s.index(s.startIndex, offsetBy: 0))
//        } else if (hexString?.count ?? 0) == 7 {
//            hexString?.insert(contentsOf: "0", at: s.index(s.startIndex, offsetBy: 0))
//        }
//        return hexString
//    }
//
//    /**
//     *      十进制字符串转化为数组  。用于发给蓝牙
//     *
//     **/
//    /**
//     *  开始上传数据
//     */
//    /**
//     *
//     arrayToString    11，22，33，44,
//     */
//    /**
//     *
//     arrayToString    11，22，33，44
//     */
//    /** *
//     macToString    mac地址转化为字符串
//     */
//    /**
//     *
//     macToString    data  mac地址转化为字符串
//     */
//    /**
//     *
//     获取这个字符串中的所有xxx的所在的index
//     */
//    class func getRangeStr(_ text: String?, findText: String?) -> [AnyHashable]? {
//        var arrayRanges = [AnyHashable](repeating: 0, count: 20)
//        if findText == nil && (findText == "") {
//            return nil
//        }
//        let rang: NSRange? = (text as NSString?)?.range(of: findText ?? "", options: .caseInsensitive) //获取第一次出现的range
//        if Int(rang?.location ?? 0) != NSNotFound && Int(rang?.length ?? 0) != 0 {
//            arrayRanges.append(Int(rang?.location ?? 0)) //将第一次的加入到数组中
//            var rang1 = [0, 0] as? NSRange
//            var location: Int = 0
//            var length: Int = 0
//            var i = 0
//            while  {
//                if 0 == i {
//                    //去掉这个xxx
//                    location = Int((rang?.location ?? 0) + (rang?.length ?? 0))
//                    length = (text?.count ?? 0) - Int(rang?.location ?? 0) - Int(rang?.length ?? 0)
//                    rang1 = NSRange(location: location, length: length)
//                } else {
//                    location = Int((rang1?.location ?? 0) + (rang1?.length ?? 0))
//                    length = (text?.count ?? 0) - Int(rang1?.location ?? 0) - Int(rang1?.length ?? 0)
//                    rang1 = NSRange(location: location, length: length)
//                }
//                //在一个range范围内查找另一个字符串的range
//                if let aRang1 = rang1 {
//                    rang1 = (text as NSString?)?.range(of: findText ?? "", options: .caseInsensitive, range: aRang1)
//                }
//
//                if Int(rang1?.location ?? 0) == NSNotFound && Int(rang1?.length ?? 0) == 0 {
//                    break
//                } else {
//                    arrayRanges.append(Int(rang1?.location ?? 0))
//                }
//                i += 1
//            }
//            return arrayRanges
//        }
//        return nil
//    }
//
//    /**
//     *
//     macToString    data  mac地址转化为字符串
//     */
//    /**
//     *
//     检查到设置中的外设。没有收到广播。就从数据库中取得macAddress  保存本地
//     */
//    /**
//     *
//     字典转json格式字符串：
//     **/
//
//    /*!
//     
//     * @brief 把格式化的JSON格式的字符串转换成字典
//     
//     * @param jsonString JSON格式的字符串
//     
//     * @return 返回字典
//     
//     */
//
//    /*!
//     * @brief 制造180分钟的0值。
//     
//     * @return NSMutableArray
//     */
//    /*!
//     * @brief 制造144分钟的0值。
//     0-清醒 1-浅睡 2-深睡
//     * @return NSMutableArray
//     */
//    // 判断字符串中是否有中文
//    /*
//     校验mac地址的正确性   -- 长度
//     * @param mac地址
//     
//     * @return BOOL
//     */
//    /*
//     校验mac地址的正确性
//     * @param mac地址
//     
//     * @return BOOL
//     */
//    /*
//     核实MacAddress是否需要修正
//     * @param mac地址
//     
//     * @return BOOL
//     */
//    /*
//     保存macAddress之前的获取
//     
//     * @return macAddress
//     */
//    class func deviceName(toGetMacAddress fifthMac: String?) -> String? {
//        var macAddress = ""
//        //从名字中截取mac地址。
//        let deviceName = ADASaveDefaluts[kLastDeviceNAME] as? String
//        let r2range: NSRange? = (deviceName as NSString?)?.range(of: "R2", options: .caseInsensitive)
//        let k18srange: NSRange? = (deviceName as NSString?)?.range(of: "K18s", options: .caseInsensitive)
//        let k64srange: NSRange? = (deviceName as NSString?)?.range(of: "K64s", options: .caseInsensitive)
//        let b7srange: NSRange? = (deviceName as NSString?)?.range(of: "B7", options: .caseInsensitive)
//        if Int(r2range?.location ?? 0) != NSNotFound || Int(k18srange?.location ?? 0) != NSNotFound || Int(k64srange?.location ?? 0) != NSNotFound {
//            //r2,k18s,k64s
//            macAddress = self.r2strAppendstr(fifthMac) ?? ""
//        } else if Int(b7srange?.location ?? 0) != NSNotFound {
//            //b7
//            macAddress = self.b7strAppendstr(fifthMac) ?? ""
//        } else {
//            //r1 多种情况
//            macAddress = self.r1strAppendstr(fifthMac) ?? ""
//        }
//        return macAddress
//    }
//
//    //r2 k18s k64s 拼接的字符串
//    class func r2strAppendstr(_ strR2: String?) -> String? {
//        return "00\(strR2 ?? "")"
//    }
//
//    //r2 k18s k64s 拼接的字符串
//    class func b7strAppendstr(_ strB7: String?) -> String? {
//        return "ed\(strB7 ?? "")"
//    }
//
//    //r1 拼接的字符串
//    class func r1strAppendstr(_ strR1: String?) -> String? {
//        return "e0\(strR1 ?? "")"
//    }
//
//    //　              0-50　Ⅰ　优　可正常活动
//    //            　　51-100　Ⅱ　良　可正常活动
//    //            　　101-150　Ⅲ1　轻微污染　长期接触，易感人群出现症状
//    //            　　151-200　Ⅲ2　轻度污染　长期接触，健康人群出现症状
//    //            　　201-250　Ⅳ1　中度污染　一定时间接触后，健康人群出现症状
//    //            　　251-300　Ⅳ2　中度重污染　一定时间接触后，心脏病和肺病患者症状显著加剧
//    //            　　>300　Ⅴ　重度污染　健康人群明显强烈症状，提前出现某些疾病
//    /*
//     pm25   用于计算空气质量
//     
//     * @return pm25
//     */
//    //经纬度分出
//    /*
//     获取运动目标时间
//     
//     * @return target
//     */
//    /**
//     
//     *  是直接使用
//     
//     */
//    /**
//     
//     *  计算配速
//     
//     */
//    /**
//     
//     *  过滤 255 和 0
//     
//     */
//// MARK: - 更换主页面
//
//    //显示提示框
//    //移除view
//// MARK: - 弹出HUD
//
//    /**
//     *      通过过滤，把有效的睡眠中的清醒转成浅睡。开始睡眠后 30分钟，就算开始。超过30分钟的清醒才是清醒，否则清醒转浅睡
//     *
//     **/
//}
//
//let initNumber = "20"
//func ArraySize(ARR: Any) -> Int {
//    return (MemoryLayout<ARR>.size) / (MemoryLayout<ARR[0]>.size)
//}
//let calculateHeart = 220
