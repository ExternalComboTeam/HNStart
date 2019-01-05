//
//  RPluginTabBar.swift
//  TestScrollView
//
//  Created by Ray on 2018/5/16.
//  Copyright © 2018年 Ray. All rights reserved.
//

import UIKit

class RPluginTabBar: RPagingViewControllerPlugin {
    
    private var tabViewBar: RSegment?
    private var loadFlag: Bool = false
    private var tabCount: Int = 0
    private let defaultHeight: CGFloat = 44
    
    convenience init(_ tabViewBar: RSegment) {
        self.init()
        self.tabViewBar = tabViewBar
    }
    
    override func removePlugin() {
        self.tabViewBar?.removeFromSuperview()
        self.loadFlag = false
    }
    
    override func initPlugin() {
        guard let view = self.tabViewBar else {
            self.tabViewBar = RSegment()
            self.initPlugin()
            return
        }
        guard view.bounds.height < 1 else { return }
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.defaultHeight)
    }
    
    override func loadPlugin() {
        guard let count = self.pagViewController?.dataSource?.numberOfViewController() else { return }
        self.tabCount = count
        self.layoutTabBar()
        self.tabViewBar?.currentIndex = 0
    }
    
    private func layoutTabBar() {
        guard !self.loadFlag else { return }
        
        guard let tab = self.tabViewBar else { return }
        
        self.loadFlag = true
        
        guard let scroll = self.pagViewController?.scrollView else { return }
        let tabBarHeight = tab.bounds.height
        
        guard let header = self.pagViewController?.headerView else {
            self.tabViewBar?.frame = CGRect(x: 0, y: 0, width: scroll.bounds.width, height: tabBarHeight)
            self.pagViewController?.headerView = self.tabViewBar
            return
        }
        let oldHeadHeight = header.bounds.height
        let newHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: scroll.bounds.width, height: oldHeadHeight + tabBarHeight))
        newHeaderView.addSubview(header)
        let tabBarFrameMinY = header.bounds.height
        tab.frame = CGRect(x: 0, y: tabBarFrameMinY, width: scroll.bounds.width, height: tabBarHeight)
        tab.autoresizingMask = .flexibleTopMargin
        newHeaderView.autoresizingMask = .flexibleTopMargin
        newHeaderView.addSubview(tab)
        self.pagViewController?.headerView = newHeaderView
    }
    
    override func scrollViewHorizontalScroll(_ contentOffsetX: CGFloat) {
        let proportion = contentOffsetX / UIScreen.main.bounds.width
        self.tabViewBar?.moveView(proportion: proportion)
    }
    
    override func scrollViewDidScrollToIndex(_ index: Int) {
        self.tabViewBar?.currentIndex = index
    }
}
