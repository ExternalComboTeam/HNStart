//
//  FoundPasswordViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class FoundPasswordViewController: UIViewController {

    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var mailTitleLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var foundButton: UIButton!
    
    @IBAction func foundAction(_ sender: UIButton) {
        guard let account = self.accountTextField.text, let mail = self.mailTextField.text else { return }
        KRProgressHUD.show()
        UserInfoAPI.forget(account: account, email: mail) { (json) in
            KRProgressHUD.dismiss({
                KRProgressHUD.showMessage("系統寄信中，登入後請記得修改密碼".localized())
                KRProgressHUD.dismiss({
                    self.pop()
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "找回密碼".localized())
        self.accountTitleLabel.text = "帳號".localized()
        self.mailTitleLabel.text = "電子信箱".localized()
    }

}
