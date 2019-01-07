//
//  QRCodeScanViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/8.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class QRCodeScanViewController: UIViewController {

    @IBOutlet weak var scanView: QRCodeReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "")
        self.scanView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scanView.reStart()
    }
    
    private func frequencyString(_ frequency: String) -> String {
        var frequencyName: String = ""
        
        if (frequency.contains("QOD")) {
            frequencyName = "隔日使用 1 次";
        } else if (frequency.contains("QW")) {
            frequencyName = "每星期 1 次";
        } else if (frequency.contains("BIW")) {
            frequencyName = "每星期 2 次";
        } else if (frequency.contains("TIW")) {
            frequencyName = "每星期 3 次";
        } else if (frequency.contains("STAT")) {
            frequencyName = "立刻使用";
        } else if (frequency.contains("ASORDER")) {
            frequencyName = "依照醫師指示使用";
        } else if (frequency.contains("QD")) {
            frequencyName = "每日 1 次";
        } else if (frequency.contains("QDAM")) {
            frequencyName = "每日 1 次\n上午使用";
        } else if (frequency.contains("QDPM")) {
            frequencyName = "每日 1 次\n下午使用";
        } else if (frequency.contains("QDHS")) {
            frequencyName = "每日 1 次\n睡前使用";
        } else if (frequency.contains("QN")) {
            frequencyName = "每晚使用 1 次";
        } else if (frequency.contains("BID")) {
            frequencyName = "每日 2 次";
        } else if (frequency.contains("QAM&HS")) {
            frequencyName = "上午使用 1 次且睡前 1 次";
        } else if (frequency.contains("QPM&HS")) {
            frequencyName = "下午使用 1 次且睡前 1 次";
        } else if (frequency.contains("QAM&HS")) {
            frequencyName = "每日上下午各使用 1 次";
        } else if (frequency.contains("TID")) {
            frequencyName = "每日三次";
        } else if (frequency.contains("BID&HS")) {
            frequencyName = "每日 2 次且睡前 1 次";
        } else if (frequency.contains("QID")) {
            frequencyName = "每日 4 次";
        } else if (frequency.contains("HS")) {
            frequencyName = "睡前 1 次";
        } else if (frequency.contains("TID&HS")) {
            frequencyName = "每日 3 次且睡前 1 次";
        } else if (frequency.contains("AC")) {
            if (frequency.count > 2 && frequency.substring(3, 4).contains("H")) {
                frequencyName = frequencyName + "\n飯前" + frequency.substring(2, 3) + "小時使用";
            } else if (frequency.count > 2 && frequency.substring(3, 4).contains("M")) {
                frequencyName = frequencyName + "\n飯前" + frequency.substring(2, 3) + "分鐘使用";
            } else {
                frequencyName = frequencyName + "\n飯前使用";
            }
        } else if (frequency.contains("PC")) {
            if (frequency.count > 2 && frequency.substring(3, 4).contains("H")) {
                frequencyName = frequencyName + "\n飯後" + frequency.substring(2, 3) + "小時使用";
            } else if (frequency.count > 2 && frequency.substring(3, 4).contains("M")) {
                frequencyName = frequencyName + "\n飯後" + frequency.substring(2, 3) + "分鐘使用";
            } else {
                frequencyName = frequencyName + "\n飯後使用";
            }
        } else if (frequency.contains("PRN")) {
            frequencyName = frequencyName + "\n需要時使用";
        } else if (frequency.contains("IO")) {
            frequencyName = frequencyName + "\n依需求使用";
        } else {
            if (frequency.substring(0, 2).contains("QW")) {
                var fw = "";
                
                switch (frequency.substring(2, 3)) {
                case "1":
                    fw = "一";
                case "2":
                    fw = "二";
                case "3":
                    fw = "三";
                case "4":
                    fw = "四";
                case "5":
                    fw = "五";
                case "6":
                    fw = "六";
                case "7":
                    fw = "日";
                default:
                    fw = ""
                }
                
                frequencyName = "每星期" + fw + "使用";
            } else if (frequency.substring(1, 2).contains("W") && frequency.substring(3, 4).contains("D")) {
                frequencyName = "每" + "\(codeToNumber(frequency.substring(0, 1)))" + "星期使用" + "\(codeToNumber(frequency.substring(2, 3)))" + "天";
            } else if (frequency.substring(0, 3).contains("MCD")) {
                frequencyName = "月經第" + "\(codeToNumber(frequency.substring(3, 4)))" + "天至第" + "\(codeToNumber(frequency.substring(5, 6)))" + "天使用";
            } else if (frequency.substring(0, 1).contains("Q") && frequency.substring(2, 3).contains("D")) {
                frequencyName = "每" + "\(codeToNumber(frequency.substring(1, 2)))" + "日使用 1 次";
            } else if (frequency.substring(0, 1).contains("Q") && frequency.substring(2, 3).contains("W")) {
                frequencyName = "每" + "\(codeToNumber(frequency.substring(1, 2)))" + "星期使用 1 次";
            } else if (frequency.substring(0, 1).contains("Q") && frequency.substring(2, 3).contains("M")) {
                frequencyName = "每" + "\(codeToNumber(frequency.substring(1, 2)))" + "月使用 1 次";
            } else if (frequency.substring(0, 1).contains("Q") && frequency.substring(2, 3).contains("H")) {
                frequencyName = "每" + "\(codeToNumber(frequency.substring(1, 2)))" + "小時使用 1 次";
            } else if (frequency.substring(0, 1).contains("Q") && frequency.substring(2, 4).contains("MN")) {
                frequencyName = "每" + "\(codeToNumber(frequency.substring(1, 2)))" + "分鐘使用 1 次";
            } else if (frequency.substring(0, 1).contains("Q") && frequency.substring(2, 6).contains("HPRN")) {
                frequencyName = "需要時每" + "\(codeToNumber(frequency.substring(1, 2)))" + "小時使用 1 次";
            } else {
                frequencyName = "依需求使用";
            }
        }
        return frequencyName
    }
    
    private func codeToNumber(_ code: String) -> Int {
        if (code.contains("A") || code.contains("a") || code.contains("1")) {
            return 1;
        }
        if (code.contains("B") || code.contains("b") || code.contains("2")) {
            return 2;
        }
        if (code.contains("C") || code.contains("c") || code.contains("3")) {
            return 3;
        }
        if (code.contains("D") || code.contains("d") || code.contains("4")) {
            return 4;
        }
        if (code.contains("E") || code.contains("e") || code.contains("5")) {
            return 5;
        }
        if (code.contains("F") || code.contains("f") || code.contains("6")) {
            return 6;
        }
        if (code.contains("G") || code.contains("g") || code.contains("7")) {
            return 7;
        }
        if (code.contains("H") || code.contains("h") || code.contains("8")) {
            return 8;
        }
        if (code.contains("I") || code.contains("i") || code.contains("9")) {
            return 9;
        }
        if (code.contains("J") || code.contains("j") || code.contains("10")) {
            return 10;
        }
        if (code.contains("K") || code.contains("k") || code.contains("11")) {
            return 11;
        }
        if (code.contains("L") || code.contains("l") || code.contains("12")) {
            return 12;
        }
        if (code.contains("M") || code.contains("m") || code.contains("13")) {
            return 13;
        }
        if (code.contains("N") || code.contains("n") || code.contains("14")) {
            return 14;
        }
        if (code.contains("O") || code.contains("o") || code.contains("15")) {
            return 15;
        }
        if (code.contains("P") || code.contains("p") || code.contains("16")) {
            return 16;
        }
        if (code.contains("Q") || code.contains("q") || code.contains("17")) {
            return 17;
        }
        if (code.contains("R") || code.contains("r") || code.contains("18")) {
            return 18;
        }
        if (code.contains("S") || code.contains("s") || code.contains("19")) {
            return 19;
        }
        if (code.contains("T") || code.contains("t") || code.contains("20")) {
            return 20;
        }
        if (code.contains("U") || code.contains("u") || code.contains("21")) {
            return 21;
        }
        if (code.contains("V") || code.contains("v") || code.contains("22")) {
            return 22;
        }
        if (code.contains("W") || code.contains("w") || code.contains("23")) {
            return 23;
        }
        if (code.contains("X") || code.contains("x") || code.contains("24")) {
            return 24;
        }
        if (code.contains("Y") || code.contains("Y") || code.contains("25")) {
            return 25;
        }
        if (code.contains("Z") || code.contains("z") || code.contains("26")) {
            return 26;
        }
        
        return 0;
    }
}
extension QRCodeScanViewController: QRCodeReaderDelegate {
    func qrcodeReader(_ qrcodeReader: QRCodeReader, didComplete data: [QRCodeData]) {
        
        guard data.count > 0 else { return }
        qrcodeReader.stop()
        let medicineArray: [String] = data[0].value.components(separatedBy: ";")
        guard medicineArray.count >= 18 else { return }
        // 姓名
        let name = medicineArray[3]
        // 拿藥日期
        let getDate = medicineArray[7]
        let month = (getDate as NSString).substring(with: NSMakeRange(3,2))
        let day = String(getDate.suffix(2))
        let date = "\((Int(getDate.prefix(3)) ?? 0) + 1911)-\(month)-\(day)"
        (14..<medicineArray.count).forEach { (index) in
            if (index - 14) % 5 == 0 {
                /// 藥品健保碼
                print("\(medicineArray[index])")
            } else if (index - 14) % 5 == 1 {
                /// 用量
                print("\(medicineArray[index])")
            } else if (index - 14) % 5 == 2 {
                /// 用藥頻率
                print("\(frequencyString(medicineArray[index]))")
            } else if (index - 14) % 5 == 3 {
                /// 用途
                print("\(medicineArray[index])")
            } else if (index - 14) % 5 == 4 {
                /// 藥品總數量
                print("\(medicineArray[index])")
            }
        }
    }
}
