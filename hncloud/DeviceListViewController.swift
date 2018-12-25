//
//  DeviceListViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/24.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class DeviceListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "設備列表")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
