//
//  ModifyPasswordViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class ModifyPasswordViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var newPassTextFiled: UITextField!
    @IBOutlet weak var checkTextField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func enterAction(_ sender: Any) {
        guard let old = self.oldPassTextField.text, let new = self.newPassTextFiled.text, let check = self.checkTextField.text, new == check else { return }
        KRProgressHUD.show()
        UserInfoAPI.modify(password: old, new: new) { (json) in
            KRProgressHUD.dismiss({
                KRProgressHUD.showMessage("更新成功，請重新登入".localized())
                KRProgressHUD.dismiss({
                    UserInfo.share.clear()
                    self.dismiss(animated: false, completion: nil)
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "修改密碼".localized())
        self.accountLabel.text = "帳戶".localized() + ":" + UserInfo.share.account
        self.oldPassTextField.placeholder = "舊密碼".localized()
        self.newPassTextFiled.placeholder = "新密碼".localized()
        self.checkTextField.placeholder = "確認新密碼".localized()
        self.enterButton.setTitle("確認".localized(), for: .normal)
    }

}
