//
//  BloodPressureViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

protocol PressureDelegate {
    func savePressure(sys: Int, dia: Int)
}

class BloodPressureViewController: UIViewController {

    @IBOutlet weak var descriptionLabel_1: UILabel!
    @IBOutlet weak var descriptionLabel_2: UILabel!
    @IBOutlet weak var descriptionLabel_3: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sysTextField: UITextField!
    @IBOutlet weak var disTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: PressureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionLabel_1.text = "基於PPG的血壓監測，因個人體質差異".localized()
        self.descriptionLabel_2.text = "請先選擇一款精確的傳統寫血壓計，並將標準的血壓值輸入下列".localized()
        self.pressureLabel.text = "請輸入校正血壓".localized()
        
        self.sysTextField.placeholder = "舒張壓".localized()
        self.disTextField.placeholder = "收縮壓".localized()
        
        self.descriptionLabel_3.text = "請保持血壓手錶與APP已連接".localized()
        self.tipLabel.text = "個人資料頁面可修改血壓基準值".localized()
        self.enterButton.setTitle("確定".localized(), for: .normal)
        self.cancelButton.setTitle("取消".localized(), for: .normal)
        self.enterButton.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    @objc private func enterAction() {
        guard let sys = self.sysTextField.text, let dia = self.disTextField.text else { return }
        guard let sysValue = Int(sys), let diaValue = Int(dia) else { return }
        KRProgressHUD.show()
        #warning("血壓值於 UserInfoAPI.update 回傳值並未更動")
        HealthAPI.update(pressure: sysValue, dia: diaValue) { (json) in
            KRProgressHUD.dismiss()
            self.delegate?.savePressure(sys: sysValue, dia: diaValue)
            self.dismiss(animated: false, completion: nil)
        }
    }
    @objc private func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.enterButton.addBoard(.top, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 1)
        self.enterButton.addBoard(.right, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 1)
        self.cancelButton.addBoard(.top, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 1)
    }
}
