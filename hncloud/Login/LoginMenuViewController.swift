//
//  LoginMenuViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class LoginMenuViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func loginAction(_ sender: UIButton) {
        let vc = LoginViewController.fromStoryboard()
        self.push(vc: vc)
    }
    @IBAction func registerAction(_ sender: UIButton) {
        let vc = RegisterViewController.fromStoryboard()
        self.push(vc: vc)
    }
    
    @IBAction func ignore(_ sender: Any) {
        let vc = DeviceListViewController.fromStoryboard()
        self.push(vc: vc)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.setTitle("登入".localized(), for: .normal)
        self.registerButton.setTitle("註冊".localized(), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
