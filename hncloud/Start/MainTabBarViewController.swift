//
//  MainTabBarViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    lazy private var menuButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "three_line"), style: .plain, target: self, action: #selector(self.sideMenu))
    }()
    
    @objc private func sideMenu() {
        
        print("view = \(self.presentedViewController) \(self.presentingViewController)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = menuButton
        self.tabBar.items?.forEach({ (item) in
            switch item.tag {
            case 0:
                item.image = UIImage(named: "active_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "active_checked")?.scaled(toHeight: 40)
                break
            case 1:
                item.image = UIImage(named: "movement_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "movement_checked")?.scaled(toHeight: 40)
                break
            case 2:
                item.image = UIImage(named: "sleep_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "sleep_checked")?.scaled(toHeight: 40)
                break
            case 3:
                item.image = UIImage(named: "blood_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "blood_checked")?.scaled(toHeight: 40)
                break
            case 4:
                item.image = UIImage(named: "suger_icon")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "suger_icon_blue")?.scaled(toHeight: 40)
                break
            default:
                break
            }
            
        })
    }

}
