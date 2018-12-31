//
//  BMIInfoViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class BMIInfoViewController: UIViewController {

    private lazy var finishedButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "確定".localized(), style: .plain, target: self, action: #selector(finished))
    }()
    
    @objc private func finished() {
        if UserInfo.share.isLogin {
            self.pop(toRoot: true)
        } else {
            let vc = DeviceListViewController.fromStoryboard()
            self.push(vc: vc)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItems = [self.finishedButton]
        self.setBackButton(title: "個人資訊")
    }

}
