//
//  FrequencyViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

protocol FrequencyDelegate {
    func finishEdit(up: String, lower: String)
}

class FrequencyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var dangerLabel: UILabel!
    @IBOutlet weak var dangerLabel_1: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var fillLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var upTextField: UITextField!
    @IBOutlet weak var lowerTextField: UITextField!
    
    var delegate: FrequencyDelegate?
    
    lazy private var finishedButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "確定".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishedEdit))
    }()
    
    @objc private func finishedEdit() {
        self.delegate?.finishEdit(up: self.upTextField.text ?? "", lower: self.lowerTextField.text ?? "")
        self.pop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItems = [self.finishedButton]
        self.titleLabel.text = "設置個人最大心率和根據正常心率範圍，以便提醒您在第一次的最低心率。"
        self.referenceLabel.text = "參考:".localized()
        self.dangerLabel_1.text = "危險".localized()
        self.dangerLabel.text = "危險".localized()
        self.setBackButton(title: "心率預警".localized())
        self.normalLabel.text = "正常範圍".localized()
        self.fillLabel.text = "填寫:".localized()
        self.warningLabel.text = "請填寫一個合理的範圍!".localized()
        
        self.setTextField(self.upTextField, up: true)
        self.setTextField(self.lowerTextField, up: false)
    }

    private func setTextField(_ textField: UITextField, up: Bool) {
        let front = UILabel(text: up ? "最大心率:".localized() : "最小心率:".localized())
        front.sizeToFit()
        textField.leftView = front
        textField.leftViewMode = .always
        let back = UILabel(text: "bpm")
        back.sizeToFit()
        textField.rightViewMode = .always
        textField.rightView = back
    }
}
