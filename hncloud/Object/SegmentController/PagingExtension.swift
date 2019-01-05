//
//  PagingExtension.swift
//  TestScrollView
//
//  Created by Ray on 2018/5/16.
//  Copyright © 2018年 Ray. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private struct RPagingKey {
        static var name = "RPagName"
        static var scroll = "RPagScroll"
    }
    
    var pagViewController: RPagingViewController? {
        get {
            return objc_getAssociatedObject(self, &RPagingKey.name) as? RPagingViewController
        }
        set {
            objc_setAssociatedObject(self, &RPagingKey.name, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var pagContentScrollView: UIScrollView? {
        get {
            guard let scroll = objc_getAssociatedObject(self, &RPagingKey.scroll) as? UIScrollView else {
                if let view = self.view as? UIScrollView {
                    self.pagContentScrollView = view
                } else {
                    guard let view = self.view.subviews.first(where: { $0 is UIScrollView }) else { return nil }
                    self.pagContentScrollView = view as? UIScrollView
                }
                
                guard let scroll = objc_getAssociatedObject(self, &RPagingKey.scroll) as? UIScrollView else { return nil }
                return scroll
            }
            return scroll
        }
        set {
            objc_setAssociatedObject(self, &RPagingKey.scroll, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
