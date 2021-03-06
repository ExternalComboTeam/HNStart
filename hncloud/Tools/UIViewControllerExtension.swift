//
//  UIViewControllerExtension.swift
//  hncloud
//
//  Created by 辰 on 2018/12/24.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Instantiates and returns the view controller from *MainStoryboard*.
    ///
    /// **Note**, The storyboard identifier should be the class name.
    static func fromStoryboard() -> Self {
        let id = String(describing: self)
        return fromStoryboardHelper(storyboardName: "Main", storyboardId: id)
    }
    
    fileprivate class func fromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
    
    func push(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop(toRoot: Bool = false) {
        if toRoot {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setBackButton(title: String) {
        self.title = title
        let back = UIBarButtonItem()
        back.image = UIImage(named: "back_icon_new")?.scaled(toHeight: 20)
        back.setTitlePositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .default)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
    }
    // 至登入頁
    func toLogin() {
        let vc = LoginMenuViewController.fromStoryboard()
        let navigation = UINavigationController(rootViewController: vc)
        self.present(navigation, animated: false, completion: nil)
    }
    // 至首頁
    func toMain() {
        let left = MenuViewController.fromStoryboard()
        let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigation")
        let vc = RSideViewController(leftViewController: left, mainViewController: main)
        self.present(vc, animated: false, completion: nil)
    }
}
