//
//  RegisterViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var checkPasswordLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextAction(_ sender: Any) {
        guard let account = self.accountTextField.text,
            let password = self.passwordTextField.text,
            let chpassword = self.checkPasswordTextField.text,
            let mail = self.mailTextField.text,
            !password.isEmpty, password == chpassword else { return }
        KRProgressHUD.show()
        UserInfoAPI.register(account: account, password: password, email: mail) { (json) in
            KRProgressHUD.dismiss()
            UserInfo.share.account = account
            UserInfo.share.email = mail
            let vc = UserInfoViewController.fromStoryboard()
            self.push(vc: vc)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "註冊")
        self.accountLabel.text = "帳號".localized()
        self.passwordLabel.text = "密碼".localized()
        self.checkPasswordLabel.text = "確認密碼".localized()
        self.mailLabel.text = "郵件信箱".localized()
        self.accountTextField.placeholder = "帳號的長度是 4 到 32 個字元".localized()
        self.passwordTextField.placeholder = "密碼的長度是 6 到 32 個字元".localized()
        self.checkPasswordTextField.placeholder = "密碼的長度是 6 到 32 個字元".localized()
        self.mailTextField.placeholder = "請輸入一個有效的郵箱".localized()
    }
}
