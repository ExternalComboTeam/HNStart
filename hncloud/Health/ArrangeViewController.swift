//
//  ArrangeViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/7.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    var medicineValue: JSON = .null
    
    @objc private func nextAction() {
        let vc = ManagementViewController.fromStoryboard()
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
        self.endLabel.text = ""
    }

}
