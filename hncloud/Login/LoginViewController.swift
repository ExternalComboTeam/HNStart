//
//  LoginViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func forgetAction(_ sender: Any) {
        let vc = FoundPasswordViewController.fromStoryboard()
        self.push(vc: vc)
    }
    @IBAction func loginAction(_ sender: Any) {
        guard let account = self.accountTextField.text, let password = self.passwordTextField.text else { return }
        KRProgressHUD.show()
        UserInfoAPI.login(account: account, password: password) { (json) in
            KRProgressHUD.dismiss()
            UserInfo.share.update(json: json)
            let vc = DeviceListViewController.fromStoryboard()
            self.push(vc: vc)
        }
    }
    @IBAction func registerAction(_ sender: Any) {
        let vc = RegisterViewController.fromStoryboard()
        self.push(vc: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "登入".localized())
        self.accountTitle.text = "帳號".localized()
        self.passwordTitle.text = "密碼".localized()
        self.forgetButton.setTitle("忘記密碼".localized(), for: .normal)
        self.loginButton.setTitle("登入".localized(), for: .normal)
        self.registerButton.setTitle("新用戶註冊".localized(), for: .normal)
        self.accountTextField.placeholder = "帳號的長度是 4 到 32 個字元".localized()
        self.passwordTextField.placeholder = "密碼的長度是 6 到 32 個字元".localized()
    }

}
