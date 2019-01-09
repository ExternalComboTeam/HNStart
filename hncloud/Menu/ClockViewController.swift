//
//  ClockViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

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
        }
        self.weekArray = array
        self.repeatLabel.text = self.setWeek()
    }
    @IBAction func saveAction(_ sender: Any) {
        
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

        self.setBackButton(title: "自訂設置".localized())
        self.tipLabel.text = "打開警報後，手環會輕輕的搖醒你在簡單的睡眠模式下，並在這一天你會更有活力".localized()
        self.repeatLabel.text = self.setWeek()
        self.timeLabel.text = ""
        self.repeatStackView.arrangedSubviews[1].isHidden = self.weekArray.count == 0
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
        array.forEach({ value = value.isEmpty ? $0 : value + "/" + $0 })
        self.timeLabel.text = value
    }
}
