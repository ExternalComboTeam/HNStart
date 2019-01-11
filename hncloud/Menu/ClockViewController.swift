//
//  ClockViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class ClockViewController: UIViewController {
    
    
    var index: Int?
    var type: AlarmType?
    var timeArray: [String] = []
    var repeatArray: [Int] = [0, 0, 0, 0, 0, 0, 0]
    var noticeString: String?
    
//    var clockAlarmDataArray: [CustomAlarmModel] = []
    var clockAlarmExitArray: [String] = []
    
    

    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var repeatStackView: UIStackView!
    @IBOutlet weak var weekStackView: UIStackView!
    @IBOutlet weak var clockTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBAction func timeAction(_ sender: UIButton) {
        let vc = ClockTimeSetViewController.fromStoryboard()
        let time = self.timeLabel.text ?? ""
        vc.delegate = self
        vc.timeArray = time.isEmpty ? [] : time.components(separatedBy: "/")
        self.push(vc: vc)
    }
    @IBAction func repeatAction(_ sender: Any) {
        self.repeatStackView.arrangedSubviews[1].isHidden = !self.repeatStackView.arrangedSubviews[1].isHidden
    }
    @IBAction func weekAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        var array: [Int] = []
        self.weekStackView.arrangedSubviews.forEach { (weekButton) in
            guard let button = weekButton as? UIButton else { return }
            button.backgroundColor = button.isSelected ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            guard button.isSelected else { return }
            array.append(button.tag)
            self.repeatArray [button.tag] = sender.isSelected.int
        }
        self.weekArray = array
        self.repeatLabel.text = self.setWeek()
    }
    @IBAction func saveAction(_ sender: Any) {
        
        if type == nil {
            KRProgressHUD.showMessage("請選擇提醒類型".localized())
            return
        } else if type == AlarmType.custom, noticeString == nil {
            KRProgressHUD.showMessage("請輸入提醒類型".localized())
            return
        } else if timeArray.isEmpty {
            KRProgressHUD.showMessage("請選擇提醒時間".localized())
            return
        }
        
        if index == nil {
            
            var isFull = true
            
            for i in 0..<clockAlarmExitArray.count {
                if clockAlarmExitArray[i].isEmpty {
                    index = i
                    isFull = false
                }
            }
            
            if isFull {
                KRProgressHUD.showMessage("提醒不可超過8個".localized())
                return
            }
        }
        
        
        guard let index = index, let type = type else { return }
        
        let model = CustomAlarmModel(index: index,
                                     type: type,
                                     timeArray: timeArray,
                                     repeatArray: repeatArray,
                                     noticeString: noticeString)
        
        CositeaBlueTooth.instance.setAlarmWith(model)
        self.pop()
    }
    
    var weekArray: [Int] = []
    
    private func setWeek() -> String {
        guard self.weekArray.count > 0 else { return "僅此一次" }
        let week: [String] = ["日".localized(), "ㄧ".localized(), "二".localized(), "三".localized(), "四".localized(), "五".localized(), "六".localized()]
        var value = ""
        self.weekArray.forEach({ value = value.isEmpty ? week[$0] : value + "/" + week[$0] })
        return value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clockTypeLabel.text = ""
        self.setBackButton(title: "自訂設置".localized())
        self.tipLabel.text = "打開警報後，手環會輕輕的搖醒你在簡單的睡眠模式下，並在這一天你會更有活力".localized()
        self.repeatLabel.text = self.setWeek()
        self.timeLabel.text = ""
        self.repeatStackView.arrangedSubviews[1].isHidden = self.weekArray.count == 0
        
        if index != nil {
            
            self.selectType(ClockType(rawValue: ((type?.rawValue ?? 1) - 1)) ?? .sport)
            if type == .custom {
                self.setCustomString(noticeString ?? "")
            }
            self.time(self.timeArray)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.myStackView.arrangedSubviews.forEach({ $0.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 0.5) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let controller = segue.destination as! ClockTypeViewController
        controller.delegate = self
    }
}
extension ClockViewController: ClockTypeDelegate {
    func selectType(_ type: ClockType) {
        self.type = AlarmType(rawValue: type.saveValue)
        self.clockTypeLabel.text = type.name
    }
    func setCustomString(_ text: String) {
        self.noticeString = text
        self.clockTypeLabel.text = text
        switch type {
        case .custom:
            let alert = UIAlertController(title: "自訂".localized(), message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
            }
            alert.addAction(title: "確定".localized(), style: .default, isEnabled: true) { (sender) in
                self.clockTypeLabel.text = alert.textFields?.first?.text ?? ""
            }
            alert.addAction(title: "取消".localized(), style: .default, isEnabled: true) { (sender) in
                
            }
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
            //self.clockTypeLabel.text = "自訂"
        default:
            self.clockTypeLabel.text = type.name
        }
    }
}
extension ClockViewController: ClockTimeSetDelegate {
    func time(_ array: [String]) {
        var value = ""
        self.timeArray = array
        array.forEach({ value = value.isEmpty ? $0 : value + "/" + $0 })
        self.timeLabel.text = value
    }
}
