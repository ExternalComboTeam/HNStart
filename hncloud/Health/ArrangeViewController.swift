//
//  ArrangeViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/7.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwiftyJSON
import ActionSheetPicker_3_0

class ArrangeViewController: UIViewController {

    // 藥名
    @IBOutlet weak var medicineName: UILabel!
    // 劑量
    @IBOutlet weak var doseLabel: UILabel!
    // 單/複方
    @IBOutlet weak var prescriptionLabel: UILabel!
    // 劑型
    @IBOutlet weak var formLabel: UILabel!
    // 成分
    @IBOutlet weak var ingreLabel: UILabel!
    // 適應症
    @IBOutlet weak var indicLabel: UILabel!
    // 用藥天數
    @IBOutlet weak var dayTextField: UITextField!
    // 開始日期
    @IBOutlet weak var startLabel: UILabel!
    // 結束日期
    @IBOutlet weak var endLabel: UILabel!
    // 用法
    @IBOutlet weak var usageTextField: UITextField!
    // 用量
    @IBOutlet weak var doasTextField: UITextField!
    
    lazy private var nextButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "下一步".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextAction))
    }()
    lazy private var usageArray: [String] = {
        return ["口服".localized(), "外服".localized()]
    }()
    lazy private var doasArray: [String] = {
        var array = ["隔日使用 1 次".localized(), "每星期 1 次".localized(), "每星期 2 次".localized(),
                     "每星期 3 次".localized(), "立刻使用".localized(), "依照醫生指示使用".localized(),
                     "每日 1 次".localized(), "每日 1 次 上午使用".localized(), "每日 1 次 下午使用".localized(),
                     "每日 1 次 睡前使用".localized(), "每晚使用 1 次".localized(), "每日 2 次".localized()]
        array.append("上午使用 1 次且睡前 1 次".localized())
        array.append("下午使用 1 次且睡前 1 次".localized())
        array.append("每日上下午各使用 1 次".localized())
        array.append("每日 3 次".localized())
        array.append("每日 2 次且睡前 1 次".localized())
        array.append("每日 4 次".localized())
        array.append("睡前 1 次".localized())
        array.append("每日 3 次且睡前 1 次".localized())
        array.append("需要時使用".localized())
        array.append("依需求使用".localized())
        return array
    }()
    
    var medicineValue: JSON = .null
    
    @objc private func nextAction() {
        guard let day = self.dayTextField.text, !day.isEmpty else { return }
        let vc = ManagementViewController.fromStoryboard()
        vc.medicineValue = self.medicineValue
        vc.usage = self.usageTextField.text ?? ""
        vc.doas = self.doasTextField.text ?? ""
        vc.day = day
        self.push(vc: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "用藥安排".localized())
        self.navigationItem.rightBarButtonItems = [self.nextButton]
        
        self.medicineName.text = self.medicineValue["name_c"].stringValue + "\n" + self.medicineValue["name_e"].stringValue
        self.doseLabel.text = self.medicineValue["quantity"].stringValue + self.medicineValue["unit"].stringValue
        self.prescriptionLabel.text = self.medicineValue["compound"].stringValue
        self.formLabel.text = self.medicineValue["formulation"].stringValue
        self.ingreLabel.text = self.medicineValue["ingredient"].stringValue
        self.indicLabel.text = self.medicineValue["indication"].stringValue
        
        self.startLabel.text = Date().string(withFormat: "yyyy-MM-dd") + " " + "開始用藥".localized()
        self.endLabel.text = "-"
        
        self.dayTextField.delegate = self
        self.usageTextField.delegate = self
        self.doasTextField.delegate = self
        self.usageTextField.text = self.usageArray[0]
        self.doasTextField.text = self.doasArray[0]
        self.setTextField(self.usageTextField)
        self.setTextField(self.doasTextField)
    }
    
    private func setTextField(_ textField: UITextField) {
        textField.textAlignment = .center
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
        let image = UIImageView(image: UIImage(named: "pull_conner"))
        image.size = CGSize(width: 10, height: 5)
        image.center = CGPoint(x: 25, y: 17)
        view.addSubview(image)
        textField.rightView = view
        textField.rightViewMode = .always
    }
}
extension ArrangeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == self.dayTextField else { return }
        guard let day = Int(textField.text ?? "") else { return }
        self.endLabel.text = Date().string(withFormat: "yyyy-MM-dd") + "-" + Date().adding(.day, value: day).string(withFormat: "yyyy-MM-dd")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.dayTextField:
            return true
        case self.usageTextField:
            textField.resignFirstResponder()
            let value = textField.text ?? ""
            let selection = self.usageArray.firstIndex(of: value) ?? 0
            ActionSheetStringPicker.init(title: "", rows: self.usageArray, initialSelection: selection, doneBlock: { (picker, row, _) in
                textField.text = self.usageArray[row]
            }, cancel: { (picker) in
                
            }, origin: textField)?.show()
            return false
        case self.doasTextField:
            textField.resignFirstResponder()
            let value = textField.text ?? ""
            let selection = self.doasArray.firstIndex(of: value) ?? 0
            ActionSheetStringPicker.init(title: "", rows: self.doasArray, initialSelection: selection, doneBlock: { (picker, row, _) in
                textField.text = self.doasArray[row]
            }, cancel: { (picker) in
                
            }, origin: textField)?.show()
            return false
        default:
            return true
        }
    }
}
