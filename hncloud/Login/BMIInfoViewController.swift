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
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
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
        self.setBackButton(title: "個人資訊".localized())
        
        let width = Float(UserInfo.share.weight) ?? 0
        let height = Float(UserInfo.share.height) ?? 0
        let bmi = width * 10000 / height / height
        self.BMILabel.text = String(format: "%.1f", bmi)
        if bmi < 18.5 {
            self.statusLabel.text = "偏瘦".localized()
        } else if bmi < 25 {
            self.statusLabel.text = "正常".localized()
        } else if bmi < 30 {
            self.statusLabel.text = "超重".localized()
        } else {
            self.statusLabel.text = "肥胖".localized()
        }
    }

}
