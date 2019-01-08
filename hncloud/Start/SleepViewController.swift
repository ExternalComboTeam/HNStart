//
//  SleepViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import ZZCircleProgress

class SleepViewController: UIViewController {

    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var wellSleepLabel: UILabel!
    @IBOutlet weak var shallowLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var sleepStateLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    
    @IBOutlet weak var bluetoothStateBtn: UIButton!
    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.55
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), pathFill: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), startAngle: -90, strokeWidth: 15)
        view?.pointImage.image = UIImage(named: "pointer_sleep")
        view?.showProgressText = false
        return view
    }()
    
    @IBAction func targetAction(_ sender: UIButton) {
        // 目標記錄
        let vc = TargetViewController.fromStoryboard()
        self.push(vc: vc)
    }
    @IBAction func curve(_ sender: UIButton) {
        let vc = SleepChartsViewController.fromStoryboard()
        self.push(vc: vc)
    }
    
    @IBAction func bluetoothStateAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTime(0, min: 50)
        
        guard let progressView = self.progressView else { return }
        self.progressContainer.addSubview(progressView)
        progressView.progress = 0
        progressView.prepareToShow = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.targetLabel.text = "\(UserInfo.share.sleepTarget)h"
        connectedBand()
        setSleepValue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// 設定時間
    private func setTime(_ hour: Int, min: Int) {
        let h = NSMutableAttributedString(string: "\(hour)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 28),
                         .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        let sh = NSMutableAttributedString(string: "h",
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        let m = NSMutableAttributedString(string: "\(min)",
                                          attributes: [.font: UIFont.boldSystemFont(ofSize: 28),
                                                       .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        let sm = NSMutableAttributedString(string: "min",
                                           attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                        .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        self.sleepTimeLabel.attributedText = h + sh + m + sm
    }
    
    /// 設定深睡時間
    func setWellSleepTime(_ hour: Int, min: Int) {
        wellSleepLabel.text = "\(hour)h\(min)min\n深睡"
    }
    
    /// 設定淺睡時間
    func setShallowSleepTime(_ hour: Int, min: Int) {
        shallowLabel.text = "\(hour)h\(min)min\n淺睡"
    }
    
    /// 設定清醒時間
    func setWakeTime(_ hour: Int, min: Int) {
        wakeLabel.text = "\(hour)h\(min)min\n清醒"
    }
    
    /// 設定睡眠品質
    func setSleepState(sleepTotalCount: Int) {
        let text = "\n睡眠品質"
        if sleepTotalCount < 36 {
            sleepStateLabel.text = "偏少" + text
        } else if sleepTotalCount < 54 {
            sleepStateLabel.text = "正常" + text
        } else {
            sleepStateLabel.text = "充裕" + text
        }
    }
    
    func connectedBand() {
        
        bluetoothStateBtn.isEnabled = false
        
        if CositeaBlueTooth.instance.isConnected {
            print("CositeaBlueTooth.instance.isConnected = \(CositeaBlueTooth.instance.isConnected)")
            hideBluetoothStateBtn()
            return
        } else {
            self.bluetoothStateBtn.isHidden = false
        }
        
        CositeaBlueTooth.instance.checkCBCentralManagerState { (state) in
            
            switch state {
                
            case .poweredOn:
                self.bluetoothStateBtn.setTitle("連接中...", for: .normal)
                
                guard let uuid = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceUUID) else {
                    
                    self.bluetoothStateBtn.isEnabled = true
                    self.bluetoothStateBtn.setTitle("未綁定", for: .normal)
                    return
                }
                
                CositeaBlueTooth.instance.connect(withUUID: uuid)
                
                CositeaBlueTooth.instance.connectedStateChanged(with: { (stateNum) in
                    if stateNum == 1 {
                        self.bluetoothStateBtn.setTitle("已連接", for: .normal)
                        self.perform(#selector(self.hideBluetoothStateBtn), with: nil, afterDelay: 1.0)
                    }
                })
            default:
                self.bluetoothStateBtn.isEnabled = true
                self.bluetoothStateBtn.setTitle("未綁定", for: .normal)
                
            }
        }
    }
    
    @objc func hideBluetoothStateBtn() {
        self.bluetoothStateBtn.isEnabled = false
        self.bluetoothStateBtn.isHidden = true
    }
    
    func setSleepValue() {
        
        PZBlueToothManager.instance.checkTodaySleepState { (timeSeconds, sleepArray) in
            
            guard let sleepArray = ToolBox.filterSleep(toValid: sleepArray as? [Int]) else { return }
            
            var lightSleep: Int = 0
            var awakeSleep: Int = 0
            var deepSleep: Int = 0
            var isBegin = false
            var nightBeginTime: Int = 0
            var nightEndTime: Int = 0
            
            for i in 0..<sleepArray.count {
                let sleepState: Int = sleepArray[i]
                if sleepState != 0 && sleepState != 3 {
                    if isBegin == false {
                        isBegin = true
                        nightBeginTime = i
                    }
                    nightEndTime = i
                }
            }
            if sleepArray.count != 0 {
                if nightEndTime > nightBeginTime {
                    for i in nightBeginTime...nightEndTime {
                        let state: Int = sleepArray[i]
                        if state == 2 {
                            deepSleep += 1
                        } else if state == 1 {
                            lightSleep += 1
                        } else if state == 0 || state == 3 {
                            awakeSleep += 1
                        }
                    }
                }
            }
            
            let totalCount: Int = awakeSleep + lightSleep + deepSleep
            
            self.setTime(totalCount / 60, min: totalCount % 60)
            self.setWellSleepTime((deepSleep * 10) / 60, min: (deepSleep * 10) % 60)
            self.setShallowSleepTime((lightSleep * 10) / 60, min: (lightSleep * 10) % 60)
            self.setWakeTime((awakeSleep * 10) / 60, min: (awakeSleep * 10) % 60)
            
            var sleepPlan = UserInfo.share.sleepTarget
            self.targetLabel.text = "\(sleepPlan)h"
            sleepPlan = sleepPlan == 0 ? 1: sleepPlan
            let finished = CGFloat(totalCount) / CGFloat(sleepPlan)
            
            self.progressView?.progress = finished
            
            self.finishedLabel.text = "\(Int(finished * 100))%"
        }
    }
}
