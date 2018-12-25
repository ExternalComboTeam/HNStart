//
//  StartViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/24.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KeychainSwift

class StartViewController: UIViewController {

    private let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let user = self.keychain.get("account") {
                let vc = DeviceListViewController.fromStoryboard()
                //self.push(vc: vc)
            } else {
                self.toLogin()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
