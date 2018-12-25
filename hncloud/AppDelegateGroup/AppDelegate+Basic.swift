//
//  AppDelegate+Basic.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

extension AppDelegate {
    func customizeNavigation() {
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.2900782526, green: 0.2851380706, blue: 0.3431323767, alpha: 1)
        let image = UIImage(named: "back_icon_new")?.scaled(toHeight: 1)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UINavigationBar.appearance().backIndicatorImage = image
    }
}
