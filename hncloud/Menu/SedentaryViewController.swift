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
        
        self.startTextField.delegate = self
        self.endTextField.delegate = self
        self.betweenTextField.delegate = self
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
                textField.text = time.string(withFormat: "HH:mm")
            }, cancel: { (picker) in
                
            }, origin: textField)
            return false
        default:
            return false
        }
    }
}
