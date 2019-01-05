//
//  PagingProtocal.swift
//  TestScrollView
//
//  Created by Ray on 2018/5/16.
//  Copyright © 2018年 Ray. All rights reserved.
//

import UIKit

@objc protocol RPagingViewControllerDataSource: NSObjectProtocol {
    func numberOfViewController() -> Int
    
    func RViewController(_ viewController: RPagingViewController, index: Int) -> UIViewController
    
    @objc optional func containerInsets(_ viewController: RPagingViewController) -> UIEdgeInsets
    
    @objc optional func pagHeaderView(_ viewController: RPagingViewController) -> UIView
    
    @objc optional func pagHeaderBottomInset(_ viewController: RPagingViewController) -> CGFloat
}

@objc protocol RPagingViewControllerDelagate {
    @objc optional func RViewController(_ viewController: RPagingViewController, scrollViewVerticalScroll contentPercentY: CGFloat)
    
    @objc optional func RViewController(_ viewController: RPagingViewController, scrollViewHorizontalScroll contentOffsetX: CGFloat)
    
    @objc optional func RViewController(_ viewController: RPagingViewController, scrollViewWillScrollFromIndex index: Int)
    
    @objc optional func RViewController(_ viewController: RPagingViewController, scrollViewDidScrollToIndex index: Int)
}
