//
//  RPluginHeaderScroll.swift
//  TestScrollView
//
//  Created by Ray on 2018/5/16.
//  Copyright © 2018年 Ray. All rights reserved.
//

import Foundation

class RPluginHeaderScroll: RPagingViewControllerPlugin {
    
    private var index: Int = 0
    
    override func removePlugin() {
        guard let controller = self.pagViewController else {
            return
        }
        self.removePan(for: controller.curIndex)
    }
    
    override func loadPlugin() {
        guard let controller = self.pagViewController else {
            return
        }
        self.addPan(for: controller.curIndex)
        self.index = controller.curIndex
    }
    override func scrollViewDidScrollToIndex(_ index: Int) {
        guard self.index != index else {
            return
        }
        self.removePan(for: self.index)
        self.addPan(for: index)
        self.index = index
    }
    override func scrollViewWillScrollFromIndex(_ index: Int) {
        self.index = index
    }
    
    
    private func addPan(for index: Int) {
        guard let controller = self.pagViewController else {
            return
        }
        guard let vc = controller.childViewController(index) else {
            return
        }
        guard let scroll = vc.pagContentScrollView else { return }
        controller.view.addGestureRecognizer(scroll.panGestureRecognizer)
    }
    
    private func removePan(for index: Int) {
        guard let controller = self.pagViewController else {
            return
        }
        guard let vc = controller.childViewController(index) else {
            return
        }
        guard let scroll = vc.pagContentScrollView else { return }
        controller.view.removeGestureRecognizer(scroll.panGestureRecognizer)
    }
}
