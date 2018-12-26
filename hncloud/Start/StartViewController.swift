//
//  StartViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/24.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if UserInfo.share.isLogin {
                self.toMain()
            } else {
                self.toLogin()
            }
        }
    }
}
