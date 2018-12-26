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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setImage(UIImage(named: "three_line"), for: .normal)
        button.addTarget(self, action: #selector(sideMenu), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    @objc private func sideMenu() {
        guard let menu = self.parent?.parent as? RSideViewController else { return }
        menu.openMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItems = [self.menuButton]
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
                item.selectedImage = UIImage(named: "blood_checked")?.scaled(toHeight: 35)
                break
            case 4:
                item.image = UIImage(named: "suger_icon")?.scaled(toHeight: 45)
                item.selectedImage = UIImage(named: "suger_icon_blue")?.scaled(toHeight: 45)
                break
            default:
                break
            }
            
        })
    }

}
