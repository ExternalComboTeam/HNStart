//
//  UIWindowExtension.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

extension UIWindow {
    
    var visibleViewController: UIViewController? {
        return self.topViewController()
    }
    
    private func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        // 如果是Navigation
        if let navigationCroller = controller as? UINavigationController {
            return topViewController(controller: navigationCroller.visibleViewController)
        }
        // 如果是Tab
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        // 如果是Present
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
