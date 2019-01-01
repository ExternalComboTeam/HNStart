//
//  SoprtType.swift
//  hncloud
//
//  Created by 辰 on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

enum SportType {
    case walk
    case run
    case climb
    case ball
    case power
    case aerobic
    case custom
    
    var title: String {
        switch self {
        case .walk:
            return "徒步".localized()
        case .run:
            return "跑步".localized()
        case .climb:
            return "爬山".localized()
        case .ball:
            return "球類遊戲".localized()
        case .power:
            return "力量訓練".localized()
        case .aerobic:
            return "有氧運動".localized()
        case .custom:
            return "自訂設置".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .walk:
            return UIImage(named: "walk")
        case .run:
            return UIImage(named: "running")
        case .climb:
            return UIImage(named: "climing")
        case .ball:
            return UIImage(named: "ball")
        case .power:
            return UIImage(named: "muscle")
        case .aerobic:
            return UIImage(named: "aerobic")
        case .custom:
            return UIImage(named: "custom_sport_type")
        }
    }
}
