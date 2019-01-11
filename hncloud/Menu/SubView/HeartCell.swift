//
//  HeartCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import KRProgressHUD

class HeartCell: UITableViewCell {
    
    @IBOutlet weak var monitorSwitchOutlet: UISwitch!
    @IBOutlet weak var alarmSwitchOutlet: UISwitch!
    
    let choseArray: [String] = ["10分鐘".localized(), "30分鐘".localized(), "連續監測".localized()]
    
    
    var max: Int {
        set {
            UserInfo.share.warningMax = newValue
        }
        get {
            return UserInfo.share.warningMax
        }
    }
    var min: Int {
        set {
            UserInfo.share.warningMin = newValue
        }
        get {
            return UserInfo.share.warningMin
        }
    }
    
    var hrMonitorStatus = false
    var hrMonitorMinuteIndex = 0
    var hrAlarmStatus = false

    @IBOutlet weak var myStackView: UIStackView!
    @IBAction func monitor(_ sender: UISwitch) {
        self.hrMonitorStatus = sender.isOn
        (self.parentViewController as? SettingViewController)?.hrMonitorStatus = sender.isOn
        
        self.myStackView.arrangedSubviews[1].isHidden = !sender.isOn
        
        guard CositeaBlueTooth.instance.isConnected else { return }
        CositeaBlueTooth.instance.changeHeartRateMonitorState(withState: sender.isOn)
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
    }
    @IBAction func frequencyAction(_ sender: UIButton) {
        
        let fre = self.frequencyLabel.text ?? ""
        let first = fre.components(separatedBy: "/").first ?? ""
        let selection = choseArray.firstIndex(of: first) ?? 0
        ActionSheetStringPicker.init(title: "", rows: choseArray, initialSelection: selection, doneBlock: { (picker, row, _) in
            self.frequencyLabel.text = row == 2 ? self.choseArray[2] : self.choseArray[row] + "/次".localized()
            
            guard CositeaBlueTooth.instance.isConnected else { return }
            var minutes: Int {
                if row == 0 {
                    return 30
                } else if row == 1 {
                    return 60
                } else {
                    return 0x01
                }
            }
            CositeaBlueTooth.instance.setHeartRateMonitorDurantionWithTime(minutes)
            
        }, cancel: { (picker) in
            
        }, origin: sender)?.show()
    }
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBAction func warningSwitch(_ sender: UISwitch) {
        self.hrAlarmStatus = sender.isOn
        (self.parentViewController as? SettingViewController)?.hrAlarmStatus = sender.isOn
        alarmSwitchAction(senderIsOn: sender.isOn)
        
    }
    @IBAction func warningAction(_ sender: UIButton) {
        let vc = FrequencyViewController.fromStoryboard()
        vc.delegate = self
        self.parentViewController?.push(vc: vc)
    }
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myStackView.arrangedSubviews.forEach({ $0.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 0.5) })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(montiorStatus: Bool, montiorIndex: Int, alarmStatus: Bool) {
        self.hrMonitorStatus = montiorStatus
        self.hrMonitorMinuteIndex = montiorIndex
        self.hrAlarmStatus = alarmStatus
        print(UserInfo.share.warningMax.string)
        self.frequencyLabel.text = choseArray[montiorIndex]
        self.upLabel.text = UserInfo.share.warningMax.string
        self.lowerLabel.text = UserInfo.share.warningMin.string
        
        alarmSwitchOutlet.isOn = alarmStatus
        
        self.myStackView.arrangedSubviews[3].isHidden = !alarmStatus
        self.myStackView.arrangedSubviews[4].isHidden = !alarmStatus
        self.myStackView.arrangedSubviews[5].isHidden = !alarmStatus
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
        self.monitorSwitchOutlet.isOn = montiorStatus
    }
    
    func alarmSwitchAction(senderIsOn: Bool) {
        
        alarmSwitchOutlet.isOn = senderIsOn
        
        self.myStackView.arrangedSubviews[3].isHidden = !senderIsOn
        self.myStackView.arrangedSubviews[4].isHidden = !senderIsOn
        self.myStackView.arrangedSubviews[5].isHidden = !senderIsOn
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
        
        guard CositeaBlueTooth.instance.isConnected else { return }
        CositeaBlueTooth.instance.setHeartRateAlarmWithState(senderIsOn, maxHeartRate: max, minHeartRate: min)
    }
}
extension HeartCell: FrequencyDelegate {
    func finishEdit(up: String, lower: String) {
        
        guard let max = Int(up), let min = Int(lower) else { return }
        
        self.upLabel.text = up
        self.lowerLabel.text = lower
        self.max = max
        self.min = min
    }
}
