//
//  ManagementViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/7.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwiftyJSON
import ActionSheetPicker_3_0

class ManagementViewController: UIViewController {

    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var mdeicineName: UILabel!
    // 劑量
    @IBOutlet weak var doseTitleLabel: UILabel!
    @IBOutlet weak var doseLabel: UILabel!
    // 劑型
    @IBOutlet weak var formTitleLabel: UILabel!
    @IBOutlet weak var formLabel: UILabel!
    // 成分
    @IBOutlet weak var ingreTitleLabel: UILabel!
    @IBOutlet weak var ingreLabel: UILabel!
    // 適應症
    @IBOutlet weak var indicTitleLabel: UILabel!
    @IBOutlet weak var indicLabel: UILabel!
    // 用法
    @IBOutlet weak var usageTitleLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    // 用量
    @IBOutlet weak var doasTitleLabel: UILabel!
    @IBOutlet weak var doasLabel: UILabel!
    
    @IBOutlet weak var tipTitleLabel: UILabel!
    @IBOutlet weak var tipTimeLabel: UILabel!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var timeTextView: UITextView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var alreadyButton: UIButton!
    
    var medicineValue: JSON = .null
    var usage: String = ""
    var doas: String = ""
    var day: String = ""
    
    private var customArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTitleLabel.text = "藥品名稱".localized() + ":"
        self.doseTitleLabel.text = "劑量".localized()
        self.formTitleLabel.text = "劑型".localized()
        self.ingreTitleLabel.text = "成分".localized()
        self.indicTitleLabel.text = "適應症".localized()
        self.usageTitleLabel.text = "用法用量".localized()
        self.doasTitleLabel.text = "使用頻率".localized()
        self.tipTitleLabel.text = "用藥提醒".localized()
        self.tipTimeLabel.text = "自訂提醒時間".localized()
        self.enterButton.setTitle("確定".localized(), for: .normal)
        self.customButton.setTitle("自訂".localized(), for: .normal)
        self.clearButton.setTitle("清除提醒".localized(), for: .normal)
        self.alreadyButton.setTitle("已用藥".localized(), for: .normal)
        
        self.setBackButton(title: "用藥管理".localized())
        self.mdeicineName.text = self.medicineValue["name_c"].stringValue
        self.doseLabel.text = self.medicineValue["quantity"].stringValue + self.medicineValue["unit"].stringValue
        self.formLabel.text = self.medicineValue["formulation"].stringValue
        self.ingreLabel.text = self.medicineValue["ingredient"].stringValue
        self.indicLabel.text = self.medicineValue["indication"].stringValue
        self.usageLabel.text = self.usage
        self.doasLabel.text = self.doas
        self.timeTextView.delegate = self
        self.timeTextView.textAlignment = .center
        self.timeStackView.arrangedSubviews[1].isHidden = true
        self.customButton.addTarget(self, action: #selector(customAction), for: .touchUpInside)
        self.clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
    }
    @objc private func clearAction() {
        self.customArray.removeAll()
        self.timeTextView.text = ""
    }
    @objc private func customAction() {
        self.timeStackView.arrangedSubviews[1].isHidden = !self.timeStackView.arrangedSubviews[1].isHidden
        self.tipTimeLabel.text = self.timeStackView.arrangedSubviews[1].isHidden ? "自訂提醒時間".localized() : ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.timeBackView.addBoard(.bottom, color: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), thickness: 0.5)
    }
}
extension ManagementViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .time, selectedDate: Date(), doneBlock: { (picker, date, orgin) in
            guard let time = date as? Date else { return }
            self.customArray.append(time.string(withFormat: "HH:mm"))
            var value = ""
            self.customArray.forEach({ value = value.isEmpty ? $0 : value + "\n" + $0 })
            textView.text = value
        }, cancel: { (picker) in
            
        }, origin: textView)
        return false
    }
}
