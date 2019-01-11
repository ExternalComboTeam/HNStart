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
        
//        DBManager.share.insertData(second: 100, lightSleep: 60)
//        DBManager.share.query(second: 100)
//        DBManager.share.insertData(second: 100, lightSleep: 30)
//        DBManager.share.query(second: 100)
//        DBManager.share.insertData(second: 100, lightSleep: 20)
//        DBManager.share.query(second: 100)
//        DBManager.share.insertData(second: 100, lightSleep: 10)
//        DBManager.share.query(second: 100)
        DBManager.share.delete(by: 100)
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
