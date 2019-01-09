//
//  UILabelExtension.swift
//  hncloud
//
//  Created by 辰 on 2019/1/9.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

@IBDesignable
extension UILabel {
    @IBInspectable var localText: String {
        get {
            return self.text ?? ""
        }
        set {
            self.text = localText.localized()
        }
    }
}
