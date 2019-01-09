//
//  SedentaryViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SedentaryViewController: UIViewController {
    
    
    
    let thirtyMinutes = 30
    let betweenArray = ["30分鐘".localized(), "60分鐘".localized(), "90分鐘".localized(), "120分鐘".localized()]
    
    var model: SedentaryModel?
    var exitArray: [String] = []
    
    var startTime: Date?
    var endTime: Date?
    var betweenTime = 30
    

    @IBOutlet weak var startTitleLabel: UILabel!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTitleLabel: UILabel!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var betweenTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startTitleLabel.text = "開始久坐時間".localized()
        self.endTitleLabel.text = "結束久坐時間".localized()
        self.tipLabel.text = "開啟久坐提醒後，您的設備將增加一定耗電量".localized()
        self.setBackButton(title: "久坐提醒".localized())
        
        self.betweenTextField.text = betweenArray[0]
        
        self.startTextField.delegate = self
        self.endTextField.delegate = self
        self.betweenTextField.delegate = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let begin = startTime, let end = endTime else { return }
    
        if CositeaBlueTooth.instance.isConnected {
            var tag: Int = -1
            if let index = self.model?.index {
                tag = index
            } else {
                for i in 0..<exitArray.count {
                    let string = exitArray[i]
                    if (string == "") {
                        tag = i
                    }
                }
            }
            let model = SedentaryModel(index: tag,
                                       beginMin: begin.minute,
                                       beginHour: begin.hour,
                                       endMin: end.minute,
                                       endHour: end.hour,
                                       duration: betweenTime)
            CositeaBlueTooth.instance.setSedentaryWith(model)
        }
    }

    
}
extension SedentaryViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case startTextField, endTextField:
            let time = textField.text ?? ""
            let date = time.date(withFormat: "HH:mm") ?? Date()
            ActionSheetDatePicker.show(withTitle: "", datePickerMode: .time, selectedDate: date, doneBlock: { (picker, date, orgin) in
                guard let time = date as? Date else { return }
                
                switch textField {
                case self.startTextField:
                    self.startTime = time
                case self.endTextField:
                    self.endTime = time
                default:
                    break
                }
                
                textField.text = time.string(withFormat: "HH:mm")
            }, cancel: { (picker) in
                
            }, origin: textField)
            return false
            
        case betweenTextField:
            let betweenLabelText = textField.text ?? betweenArray[0]
            let index = betweenArray.firstIndex(of: betweenLabelText) ?? 0
            ActionSheetStringPicker.show(withTitle: "", rows: betweenArray, initialSelection: index, doneBlock: { (picker, row, _) in
                self.betweenTime = self.thirtyMinutes * (row + 1)
                self.betweenTextField.text = self.betweenArray[row]
            }, cancel: { (picker) in
                
            }, origin: textField)
            return false
            
        default:
            return false
        }
    }
}
