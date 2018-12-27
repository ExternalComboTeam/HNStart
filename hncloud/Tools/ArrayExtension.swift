//
//  ArrayExtension.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift

extension Array where Element: UIColor {
    var cgColors: [CGColor] {
        var result: [CGColor] = []
        for item in self {
            result.append(item.cgColor)
        }
        return result
    }
}

extension Array where Element: CGColor {
    var uiColors: [UIColor] {
        var result: [UIColor] = []
        for item in self {
            result.append(item.uiColor!)
        }
        return result
    }
}
