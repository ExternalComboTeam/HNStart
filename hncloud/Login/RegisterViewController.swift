//
//  RegisterViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

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
        let vc = UserInfoViewController.fromStoryboard()
        self.push(vc: vc)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "註冊")
    }

}
