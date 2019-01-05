//
//  RPagingViewController.swift
//  TestScrollView
//
//  Created by Ray on 2018/5/15.
//  Copyright © 2018年 Ray. All rights reserved.
//

// 7204-0278-1078-3252
// 4904-0261-1079-4496

import UIKit

class RPagingViewController: UIViewController {

    weak var dataSource: RPagingViewControllerDataSource?
    weak var delegate: RPagingViewControllerDelagate?
    
    private struct loadParameter {
        /// 分頁載入標籤
        var pagViewLoadFlag: Bool
        /// 插件標籤
        var pluginsLoadFlag: Bool
    }
    
    private struct headParameter {
        /// 抬頭高度
        var headHeight: CGFloat = 0
        /// 底部高度
        var bottomInset: CGFloat = 0
        /// 隱藏 head 最小位置
        var minHeadFrameOriginY: CGFloat = 0
    }
    
    private var containerView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.isPagingEnabled = true
        view.bounces = false
        view.scrollsToTop = false
        view.delaysContentTouches = false
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }()
    
    private let contentKey: String = "contentOffset"
    private var plugins: NSMutableArray = NSMutableArray()
    
    private var viewControllers: [UIViewController]?
    var headerView: UIView?
    var curIndex: Int = 0
    private var showIndexAfter: Int = 0
    
    private var contentOffsetY: CGFloat = 0
    private var headViewScrollEnable: Bool = false
    private var viewDidAppearIsCalledBefore: Bool = false
    private var _loadParameter: loadParameter = loadParameter(pagViewLoadFlag: false, pluginsLoadFlag: false)
    private var _headParameter: headParameter = headParameter()
    
    // MARK: - 建立container View
    private func loadContainerView() {
        self.view.insertSubview(self.containerView, at: 0)
        self.containerView.addSubview(self.scrollView)
        self.scrollView.delegate = self
    }
    // MARK: - 初始化畫面
    private func loadContentView() {
        guard let count = self.dataSource?.numberOfViewController() else { return }
        guard count > 0 else { return }
        guard !self._loadParameter.pagViewLoadFlag else { return }
        self._loadParameter.pagViewLoadFlag = true
        // 取得 child viewController
        self.getChildViewController()
        // 取得 Header View
        self.getHeaderView()
        // 載入插件
        self.loadPlugin()
        // 設定邊界
        self.layoutContainViewEdge()
        // 取得 headerView height
        self.getHeaderHeight()
        // 設定 child viewController 大小 位置
        self.setChildViewController()
        // 載入 head view
        self.loadHeadView()
        // 滑動時 child viewController 執行 view will appear
        self.reloadChildViewController()
        // 移動 child scroll to top
        self.enableCurScrollViewScrollToTop(true)
        guard self.headViewScrollEnable else { return }
        self.scrollViewVertical(scrollTo: 0)
    }
    // MARK: - 設定邊界
    private func layoutContainViewEdge() {
        if let insets = self.dataSource?.containerInsets?(self) {
            self.containerView.frame = self.view.bounds.inset(by: insets)
        }
        if let array = self.viewControllers,
            array.none(matching: {$0.pagContentScrollView != nil }),
            let header = self.headerView {
            let insets = UIEdgeInsets(top: header.height, left: 0, bottom: 49, right: 0)
            self.scrollView.frame = self.containerView.bounds.inset(by: insets) 
        }
    }
    // MARK: - 取得 child viewController
    private func getChildViewController() {
        guard let count = self.dataSource?.numberOfViewController() else { return }
        self.viewControllers = []
        for i in 0..<count {
            guard let vc = self.dataSource?.RViewController(self, index: i) else { return }
            self.viewControllers?.append(vc)
        }
    }
    // MARK: - 取得 header view
    private func getHeaderView() {
        guard let header = self.dataSource?.pagHeaderView?(self) else { return }
        self.headerView = header
        self.headViewScrollEnable = true
    }
    // MARK: - set header height
    private func getHeaderHeight() {
        if let bottomHeight = self.dataSource?.pagHeaderBottomInset?(self) {
            self._headParameter.bottomInset = bottomHeight
        }
        
        if let header = self.headerView {
            self._headParameter.headHeight = header.bounds.height
        } else {
            self._headParameter.headHeight = self._headParameter.bottomInset
        }
        self._headParameter.minHeadFrameOriginY = -self._headParameter.headHeight + self._headParameter.bottomInset
    }
    // MARK: - 設定 child viewController 大小及位置
    private func setChildViewController() {
        guard let array = self.viewControllers else { return }
        let width = self.scrollView.bounds.width
        let height = self.scrollView.bounds.height
        
        self.scrollView.contentSize = CGSize(width: width * CGFloat(array.count), height: height)
        
        for i in 0..<array.count {
            array[i].view.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
            array[i].pagViewController = self
            
            if let scroll = array[i].pagContentScrollView {
                var inset = scroll.contentInset
                inset.top = inset.top + self._headParameter.headHeight
                scroll.contentInset = inset
                scroll.scrollIndicatorInsets = inset
                scroll.contentOffset = CGPoint(x: 0, y: -inset.top)
                scroll.scrollsToTop = false
                scroll.addObserver(self, forKeyPath: self.contentKey, options: .old, context: nil)
            }
        }
    }
    // MARK: - 載入 Head view
    private func loadHeadView() {
        guard let view = self.headerView else { return }
        view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self._headParameter.headHeight)
        self.containerView.insertSubview(view, aboveSubview: self.scrollView)
    }
    // MARK: - 滑動時 child viewController 執行 view will appear
    private func reloadChildViewController() {
        guard let array = self.viewControllers else { return }
        let width = self.scrollView.bounds.width
        
        for i in 0..<array.count {
            let pageOffsetForChild = CGFloat(i) * width
            let child = array[i]
            // 當下可視的 child ViewController 添加到父視圖的結構中
            if abs(self.scrollView.contentOffset.x - pageOffsetForChild) < width {
                if child.parent == nil {
                    child.willMove(toParent: self)
                    self.addChild(child)
                    self.scrollView.addSubview(child.view)
                    child.didMove(toParent: self)
                }
            } else {
                // 從父視圖的結構中移除
                if child.parent != nil {
                    child.willMove(toParent: nil)
                    child.beginAppearanceTransition(false, animated: true)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    child.endAppearanceTransition()
                }
            }
        }
    }
    // MARK - 滑動監聽動作
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == self.contentKey else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard self.headViewScrollEnable else { return }
        guard let _ = object as? UIScrollView else { return }
        guard let array = self.viewControllers else { return }
        let child = array[self.curIndex]
        guard let scroll = child.pagContentScrollView else { return }
        guard let head = self.headerView else { return }
        let disY = self.contentOffsetY - scroll.contentOffset.y
        self.contentOffsetY = scroll.contentOffset.y
        if disY > 0 && self.contentOffsetY > -head.frame.maxY {
            return
        }
        var rect = head.frame
        rect.size.height = self._headParameter.headHeight
        if self.contentOffsetY > -self._headParameter.headHeight {
            rect.origin.y = rect.origin.y + disY
            rect.origin.y = min(rect.minY, 0)
            rect.origin.y = max(rect.minY, self._headParameter.minHeadFrameOriginY)
            rect.origin.y = max(rect.minY, -self.contentOffsetY - self._headParameter.headHeight)
        } else {
            rect.origin.y = 0
        }
        
        self.headerView?.frame = rect
        var parcent: CGFloat = 1
        if self._headParameter.minHeadFrameOriginY != 0 {
            parcent = max(0, rect.minY / self._headParameter.minHeadFrameOriginY)
            parcent = min(1, parcent)
        }
        self.scrollViewVertical(scrollTo: parcent)
    }
    
    // MARK: get child viewController
    func childViewController(_ row: Int) -> UIViewController? {
        guard let array = self.viewControllers else { return nil }
        guard array.count > self.curIndex else { return nil }
        return array[row]
    }
    
    func reloadViewControllers() {
        self._loadParameter.pagViewLoadFlag = false
        self.loadContainerView()
    }
    
    // MARK: - 移除child viewController scroll 滑動監聽
    private func removeChildContentObserver() {
        guard let array = self.viewControllers else { return }
        array.forEach( { $0.pagContentScrollView?.removeObserver(self, forKeyPath: self.contentKey) } )
    }
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContainerView()
    }
    
    // MARK: - view did layout subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.loadContentView()
        
        guard self.showIndexAfter > 0 else { return }
        self.scroll(to: self.showIndexAfter, animtion: false)
        self.showIndexAfter = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !self.viewDidAppearIsCalledBefore else { return }
        self.viewDidAppearIsCalledBefore = true
        self.viewDidScroll(to: self.curIndex)
        guard self.headViewScrollEnable else { return }
        self.scrollViewVertical(scrollTo: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard CGFloat(self.curIndex) != self.scrollView.contentOffset.x / self.scrollView.bounds.width else { return }
        self.scrollViewDidEndDecelerating(self.scrollView)
    }
    
    // MARK: - 移除
    deinit {
        self.removeChildContentObserver()
        self.pluginAction({$0.removePlugin()})
        
        guard let array = self.viewControllers else { return }
        array.forEach( { $0.pagViewController = nil } )
    }
}
extension RPagingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.reloadChildViewController()
        self.delegate?.RViewController?(self, scrollViewHorizontalScroll: scrollView.contentOffset.x)
        self.pluginAction({$0.scrollViewHorizontalScroll(scrollView.contentOffset.x)})
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.enableCurScrollViewScrollToTop(false)
        self.viewControllersAutoFitToScroll(to: self.curIndex - 1)
        self.viewControllersAutoFitToScroll(to: self.curIndex + 1)
        self.delegate?.RViewController?(self, scrollViewWillScrollFromIndex: self.curIndex)
        self.pluginAction({$0.scrollViewWillScrollFromIndex(self.curIndex)})
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let array = self.viewControllers else { return }
        self.curIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        self.viewDidScroll(to: self.curIndex)
        let child = array[self.curIndex]
        guard let scroll = child.pagContentScrollView else { return }
        let inset = scroll.contentInset
        let maxY = inset.bottom + scroll.contentSize.height - scroll.bounds.height
        if scroll.contentOffset.y > maxY {
            let point = CGPoint(x: 0, y: -inset.top)
            scroll.setContentOffset(point, animated: true)
        }
        self.contentOffsetY = scroll.contentOffset.y
        self.enableCurScrollViewScrollToTop(true)
    }
}

extension RPagingViewController {
    // MARK: - 移動 child scroll to top
    private func enableCurScrollViewScrollToTop(_ enable: Bool) {
        guard let child = self.childViewController(self.curIndex) else { return }
        child.pagContentScrollView?.scrollsToTop = true
    }
    // MARK: - 左右移動時 每個 child viewController 移動至同一位置
    private func viewControllersAutoFitToScroll(to row: Int) {
        guard let array = self.viewControllers else { return }
        guard row < array.count && row != -1 else { return }
        guard let head = self.headerView else { return }
        var minRow: Int = 0
        var maxRow: Int = array.count
        if row < self.curIndex {
            minRow = row
            maxRow = self.curIndex - 1
        } else {
            minRow = self.curIndex + 1
            maxRow = row
        }
        for i in minRow...maxRow {
            let child = array[i]
            
            if let scroll = child.pagContentScrollView {
                let maxY = -min(head.frame.maxY, self._headParameter.headHeight)
                
                if scroll.contentOffset.y < maxY {
                    scroll.contentOffset = CGPoint(x: scroll.contentOffset.x, y: maxY)
                }
                
                let minY = scroll.contentSize.height - scroll.bounds.height
                if scroll.contentOffset.y > minY {
                    scroll.contentOffset = CGPoint(x: scroll.contentOffset.x, y: -head.frame.maxY)
                }
            }
        }
    }
    // MARK: - 左右滑動
    func scroll(to row: Int, animtion: Bool = true) {
        guard self._loadParameter.pagViewLoadFlag else {
            self.showIndexAfter = row
            return
        }
        
        guard let array = self.viewControllers else { return }
        guard row < array.count && row > -1 && row != self.curIndex else { return }
        self.enableCurScrollViewScrollToTop(false)
        self.viewControllersAutoFitToScroll(to: row)
        self.delegate?.RViewController?(self, scrollViewWillScrollFromIndex: self.curIndex)
        // 插件
        self.pluginAction({$0.scrollViewWillScrollFromIndex(self.curIndex)})
        let point = CGPoint(x: CGFloat(row) * self.scrollView.bounds.width, y: 0)
        self.scrollView.setContentOffset(point, animated: animtion)
        guard !animtion else { return }
        self.scrollViewDidEndDecelerating(self.scrollView)
    }
}
// MARK: - 插件 Action
extension RPagingViewController {
    // MARK: - 插入插件
    func enablePlugin(_ plugin: RPagingViewControllerPlugin) {
        guard !self.plugins.contains(plugin) else { return }
        
        self.plugins.add(plugin)
        plugin.pagViewController = self
        plugin.initPlugin()
        guard self._loadParameter.pluginsLoadFlag else { return }
        plugin.loadPlugin()
    }
    // MARK: - 載入插件
    private func loadPlugin() {
        self.pluginAction({$0.loadPlugin()})
        self._loadParameter.pluginsLoadFlag = true
    }
    // MARK: - 移除插件
    private func removePlugin(_ plugin: RPagingViewControllerPlugin) {
        plugin.removePlugin()
        plugin.pagViewController = nil
        self.plugins.remove(plugin)
    }
    // MARK: 插件 Action
    private func pluginAction(_ action: ((RPagingViewControllerPlugin) -> Void)) {
        self.plugins.enumerateObjects({ (plugin, idx, stop) in
            if let plug = plugin as? RPagingViewControllerPlugin {
                action(plug)
            }
        })
    }
}

extension RPagingViewController {
    // MARK: - scroll移動距離
    private func scrollViewVertical(scrollTo percent: CGFloat) {
        self.delegate?.RViewController?(self, scrollViewVerticalScroll: percent)
        self.pluginAction({$0.scrollViewVerticalScroll(percent)})
    }
    // MARK: - 畫面移動至何處
    private func viewDidScroll(to row: Int) {
        self.delegate?.RViewController?(self, scrollViewDidScrollToIndex: row)
        self.pluginAction({$0.scrollViewDidScrollToIndex(row)})
    }
}

