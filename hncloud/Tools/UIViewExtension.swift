//
//  UIViewExtension.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

extension UIView {
    func addBoard(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        guard edge != .all else {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = thickness
            return
        }
        
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        
        var firstLayout: NSLayoutConstraint.Attribute = .height
        var secondLayout: NSLayoutConstraint.Attribute = .top
        var thirdLayout: NSLayoutConstraint.Attribute = .leading
        var fourthLayout: NSLayoutConstraint.Attribute = .trailing
        
        switch edge {
        case UIRectEdge.top: ///上
            border.tag = 7878780
            firstLayout = .height
            secondLayout = .top
            thirdLayout = .leading
            fourthLayout = .trailing
            break
        case UIRectEdge.bottom: ///下
            border.tag = 7878781
            firstLayout = .height
            secondLayout = .bottom
            thirdLayout = .leading
            fourthLayout = .trailing
            break
        case UIRectEdge.right: ///右
            border.tag = 7878782
            firstLayout = .width
            secondLayout = .trailing
            thirdLayout = .bottom
            fourthLayout = .top
            break
        case UIRectEdge.left: ///左
            border.tag = 7878783
            firstLayout = .width
            secondLayout = .leading
            thirdLayout = .bottom
            fourthLayout = .top
            break
        default:
            break
        }
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: firstLayout,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1, constant: thickness))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: secondLayout,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: secondLayout,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: thirdLayout,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: thirdLayout,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: fourthLayout,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: fourthLayout,
                                              multiplier: 1, constant: 0))
    }
}
