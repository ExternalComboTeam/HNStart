//
//  RSidePanelController.swift
//  SideMenu
//
//  Created by Ray on 2017/9/8.
//  Copyright © 2017年 KSD. All rights reserved.
//

import UIKit

enum RSidePanelStyle: Int {
    case Single = 0
    case Multiple
}
enum RSidePanelState: Int {
    case Center = 1
    case Left
    case Right
}

class RSidePanelController: UIViewController, UIGestureRecognizerDelegate {

    @IBInspectable var leftPanel: UIViewController? {
        didSet {
            self.leftPanel?.willMove(toParent: nil)
            self.leftPanel?.view.removeFromSuperview()
            self.leftPanel?.removeFromParent()
            
            guard let left = self.leftPanel else {
                return
            }
            if left != self {
                self.addChild(left)
                left.didMove(toParent: self)
            }
            self.placeButtonForLeftButton()
            
            guard self.state == .Left else {
                return
            }
            self.visbilePanel = self.leftPanel
        }
    }
    
    private let keyValue_1: String = "view"
    private let keyValue_2: String = "viewControllers"
    
    @IBInspectable var centerPanel: UIViewController? {
        didSet {
            
            guard let center = self.centerPanel else {
                return
            }
            
            center.addObserver(self, forKeyPath: self.keyValue_1, options: .new, context: nil)
            center.addObserver(self, forKeyPath: self.keyValue_2, options: .initial, context: nil)
            if self.state == .Center {
                self.visbilePanel = center
            }
            
            if self.isViewLoaded && self.state == .Center {
                self.swapCenter(nil, previousState: .Center, with: center)
            } else if self.isViewLoaded {
                
                let previousState = self.state
                
                self.state = .Center
                
                UIView.animate(withDuration: 0.2, animations: { 
                    let width = UIScreen.main.bounds.width
                    if self.bounceOnCenterPanelChange {
                        let x = previousState == .Left ? width : -width
                        self.centerPanelRestingFrame.origin.x = x
                    }
                    self.centerPanelContainer.frame = self.centerPanelRestingFrame
                }, completion: { (finished) in
                    self.swapCenter(nil, previousState: previousState, with: center)
                    self.showCenterPanel(true, bounce: false)
                })
            }
        }
    }
    @IBInspectable var rightPanel: UIViewController? {
        didSet {
            self.rightPanel?.willMove(toParent: nil)
            self.rightPanel?.view.removeFromSuperview()
            self.rightPanel?.removeFromParent()
            
            guard let right = self.rightPanel else {
                return
            }
            
            if right != self {
                self.addChild(right)
                right.didMove(toParent: self)
            }
            
            guard self.state == .Right else {
                return
            }
            self.visbilePanel = self.rightPanel
        }
    }
    
    private var centerPanelRestingFrame: CGRect = CGRect.zero
    private var locationBeforePan: CGPoint = CGPoint.zero
    
    // MARK: - Look
    private var style: RSidePanelStyle = .Single {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            self.configureContainers()
            self.layoutSideContainer(false, duration: 0)
        }
    }
    private var pushesSidePanels: Bool = false
    // size the left panel based on % of total screen width
    private var leftGapPercentage: CGFloat = 0.8
    // size the left panel based on this fixed size. ovrrides leftGapPercentage
    private var leftVisibleWidth: CGFloat {
        guard self.centerPanelHidden && self.shouldResizeLeftPanel else {
            return self.leftFixedWidth != 0 ? self.leftFixedWidth : UIScreen.main.bounds.width * self.leftGapPercentage
        }
        return UIScreen.main.bounds.width
    }
    // the visible width of the left panel
    private var leftFixedWidth: CGFloat = 0
    // size the right panel based on % of total screen width
    private var rightGapPercentage: CGFloat = 0.8
    // size the right panel based on this fixed size. ovrrides rightGapPercentage
    private var rightVisibleWidth: CGFloat {
        guard self.centerPanelHidden && self.shouldResizeRightPanel else {
            return self.rightFixedWidth != 0 ? self.rightFixedWidth : UIScreen.main.bounds.width * self.rightGapPercentage
        }
        return UIScreen.main.bounds.width
    }
    // the visible width of the right panel
    private var rightFixedWidth: CGFloat = 0
    
    // MARK: - Animation
    // the minimum % of total screen width the centerPanel.view must move for panGesture to succeed
    private var minimumMovePercentage: CGFloat = 0.15
    // the maximum time panel opening/closing should take. Actual time may be less if panGesture has already moved the view.
    private var maxmumAnimatinoDuration: TimeInterval = 0.2
    // how long the bounce animation should take
    private var bounceDuration: TimeInterval = 0.1
    // how far the view should bounce
    private var bouncePercentage: CGFloat = 0.075
    // should the center panel bounce when you are panning open a left/right panel.
    private var bounceOnSidePanelOpen: Bool = true
    // should the center panel bounce when you are panning closed a left/right panel.
    private var bounceOnSidePanelClose: Bool = false
    // while changing the center panel, should we bounce it offscreen?
    private var bounceOnCenterPanelChange: Bool = true
    
    // MARK: - Gesture Behavior
    // Determines whether the pan gesture is limited to the top ViewController in a UINavigationController/UITabBarController
    private var panningLimitedToTopViewController: Bool = true
    // Determines whether showing panels can be controlled through pan gestures, or only through buttons
    private var recognizesPanGesture: Bool = true
    
    // MARK: - Nuts & Bolts
    // Current state of panels. Use KVO to monitor state changes
    private var state: RSidePanelState = .Center
    // Whether or not the center panel is completely hidden
    private var centerPanelHidden: Bool = true {
        didSet {
            self.centerPanelHidden(centerPanel: self.centerPanelHidden, animated: false, duration: 0)
        }
    }
    private var _centerPanelHidden: Bool = false
    
    // The currently visible panel
    private var visbilePanel: UIViewController?
    // If set to yes, "shouldAutorotateToInterfaceOrientation:" will be passed to self.visiblePanel instead of handled directly
    private var shouldDelegateAutorotateToVisiblePanel: Bool = true
    // Determines whether or not the panel's views are removed when not visble. If YES, rightPanel & leftPanel's views are eligible for viewDidUnload
    private var canUnloadRightPanel: Bool = false
    private var canUnloadLeftPanel: Bool = false
    // Determines whether or not the panel's views should be resized when they are displayed. If yes, the views will be resized to their visible width
    private var shouldResizeRightPanel: Bool = false
    private var shouldResizeLeftPanel: Bool = false
    // Determines whether or not the center panel can be panned beyound the the visible area of the side panels
    private var allowRightOverpan: Bool = true
    private var allowLeftOverpan: Bool = true
    // Determines whether or not the left or right panel can be swiped into view. Use if only way to view a panel is with a button
    private var allowLeftSwipe: Bool = true
    private var allowRightSwipe: Bool = true
    // Containers for the panels.
    private var leftPanelContainer: UIView = UIView(frame: UIScreen.main.bounds)
    private var rightPanelContainer: UIView = UIView(frame: UIScreen.main.bounds)
    private var centerPanelContainer: UIView = UIView(frame: UIScreen.main.bounds)
    private var tapView: UIView? {
        willSet {
            self.tapView?.removeFromSuperview()
        }
        didSet {
            guard let tap = self.tapView else {
                return
            }
            tap.frame = self.centerPanelContainer.bounds
            tap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addTapGesture(to: tap)
            
            if self.recognizesPanGesture {
                self.addPanGesture(to: tap)
            }
            
            self.centerPanelContainer.addSubview(tap)
        }
    }
    
    // MARK: - Panel Size
    private var adiustCenterFrame: CGRect {
        
        var frame = self.view.bounds
        switch self.state {
        case .Center:
            frame.origin.x = 0
            if self.style == .Multiple {
                frame.size.width = self.view.bounds.width
            }
            break
        case .Left:
            frame.origin.x = self.leftVisibleWidth
            if self.style == .Multiple {
                frame.size.width = UIScreen.main.bounds.width - self.leftVisibleWidth
            }
            break
        case .Right:
            frame.origin.x = -self.rightVisibleWidth
            if self.style == .Multiple {
                frame.origin.x = 0
                frame.size.width = UIScreen.main.bounds.width - self.rightVisibleWidth
            }
            break
        }
        self.centerPanelRestingFrame = frame
        return self.centerPanelRestingFrame
    }
    
    var leftAction: (() -> Void)?
    var rightAction: (() -> Void)?
    var centerAction: (() -> Void)?
    
    // MARK: - Menu Button
    private func leftButtonForCenterPanel() -> UIBarButtonItem {
        return UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleLeftPanel))
    }
    
    func showLeftPanel(_ animated: Bool = true, action: (() -> Void)? = nil) {
        self.leftAction = action
        self.showLeftPanel(animated, bounce: false)
    }
    
    func showRightPanel(_ animated: Bool = true, action: (() -> Void)? = nil) {
        self.rightAction = action
        self.showRightPanel(animated, bounce: false)
    }
    
    func showCenterPanel(_ animated: Bool = true, action: (() -> Void)? = nil) {
        self.centerAction = action
        if self.centerPanelHidden {
            self.centerPanelHidden = false
            self.unhideCenterPanel()
        }
        
        self.showCenterPanel(animated, bounce: false)
    }
    @objc private func toggleLeftPanel() {
        switch self.state {
        case .Left:
            self.showCenterPanel(true, bounce: false)
            break
        case .Center:
            self.showLeftPanel(true, bounce: false)
            break
        default:
            break
        }
    }
    @objc private func toggleRightPanel() {
        switch self.state {
        case .Right:
            self.showCenterPanel(true, bounce: false)
            break
        case .Center:
            self.showRightPanel(true, bounce: false)
            break
        default:
            break
        }
    }
    
    private func centerPanelHidden(centerPanel hidden: Bool, animated: Bool, duration: TimeInterval) {
        guard hidden != self._centerPanelHidden && self.state != .Center else {
            return
        }
        self._centerPanelHidden = hidden
        
        let animateDuration = animated ? duration : 0
        
        guard hidden else {
            self.unhideCenterPanel()
            UIView.animate(withDuration: animateDuration, animations: { 
                if self.state == .Left {
                    self.showLeftPanel(false)
                } else {
                    self.showRightPanel(false)
                }
                
            })
            guard self.shouldResizeLeftPanel || self.shouldResizeRightPanel else {
                return
            }
            self.layoutSidePanels()
            
            return
        }
        
        UIView.animate(withDuration: animateDuration, animations: { 
            var frame = self.centerPanelContainer.frame
            let centerWidth = self.centerPanelContainer.bounds.width
            frame.origin.x = self.state == .Left ? centerWidth : -centerWidth
            self.centerPanelContainer.frame = frame
            self.layoutSideContainer(false, duration: 0)
            guard self.shouldResizeLeftPanel || self.shouldResizeRightPanel else {
                return
            }
            self.layoutSidePanels()
        }) { (finished) in
            guard hidden else {
                return
            }
            self.hideCenterPanel()
        }
        
    }
    
    // MARK: - Showing Panels
    private func showLeftPanel(_ animated: Bool, bounce: Bool) {
        self.state = .Left
        self.loadLeftPanel()
        
        self.leftAction?()
        let _ = self.adiustCenterFrame
        
        if animated {
            self.animateCenterPanel(should: bounce, completion: nil)
        } else {
            self.centerPanelContainer.frame = self.centerPanelRestingFrame
            self.styleContainer(self.centerPanelContainer, animate: false, duration: 0)
            if self.style == .Multiple || self.pushesSidePanels {
                self.layoutSideContainer(false, duration: 0)
            }
        }
        
        if self.style == .Single {
            self.tapView = UIView()
        }
        self.toggleScrollsToTopForCenter(false, left: true, right: false)
    }
    
    private func showRightPanel(_ animated: Bool, bounce: Bool) {
        self.state = .Right
        
        self.rightAction?()
        
        self.loadRightPanel()
        
        let _ = self.adiustCenterFrame
        
        if animated {
            self.animateCenterPanel(should: bounce, completion: nil)
        } else {
            self.centerPanelContainer.frame = self.centerPanelRestingFrame
            self.styleContainer(self.centerPanelContainer, animate: false, duration: 0)
            if self.style == .Multiple || self.pushesSidePanels {
                self.layoutSideContainer(false, duration: 0)
            }
        }
        
        if self.style == .Single {
            self.tapView = UIView()
        }
        self.toggleScrollsToTopForCenter(false, left: false, right: true)
    }
    
    private func showCenterPanel(_ animated: Bool, bounce: Bool) {
        self.state = .Center
        self.centerAction?()
        let _ = self.adiustCenterFrame
        
        if animated {
            self.animateCenterPanel(should: bounce, completion: { (finished) in
                self.leftPanelContainer.isHidden = true
                self.rightPanelContainer.isHidden = true
                self.unloadPanels()
            })
        } else {
            self.centerPanelContainer.frame = self.adiustCenterFrame
            self.styleContainer(self.centerPanelContainer, animate: false, duration: 0)
            
            if self.style == .Multiple || self.pushesSidePanels {
                self.layoutSideContainer(false, duration: 0)
            }
            
            self.leftPanelContainer.isHidden = true
            self.rightPanelContainer.isHidden = true
            self.unloadPanels()
        }
        self.tapView = nil
        self.toggleScrollsToTopForCenter(true, left: false, right: false)
    }
    
    private func hideCenterPanel() {
        self.centerPanelContainer.isHidden = true
        guard let center = self.centerPanel, center.isViewLoaded else {
            return
        }
        self.centerPanel?.view.removeFromSuperview()
    }
    private func unhideCenterPanel() {
        self.centerPanelContainer.isHidden = false
        guard let center = self.centerPanel, let _ = center.view.superview else {
            return
        }
        center.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        center.view.frame = self.centerPanelContainer.bounds
        self.centerPanelContainer.addSubview(center.view)
    }
    private func toggleScrollsToTopForCenter(_ center: Bool, left: Bool, right: Bool) {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.toggleScrollsToTop(center, for: self.centerPanelContainer)
            self.toggleScrollsToTop(left, for: self.leftPanelContainer)
            self.toggleScrollsToTop(right, for: self.rightPanelContainer)
        }
    }
    
    private func toggleScrollsToTop(_ enable: Bool, for view: UIView) {
        if let scrollview = view as? UIScrollView {
            scrollview.scrollsToTop = enable
        } else {
            for subView in view.subviews {
                self.toggleScrollsToTop(enable, for: subView)
            }
        }
    }
    // MARK: - key Value Observing
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.keyValue_1 {
            if let center = self.centerPanel, center.isViewLoaded, self.recognizesPanGesture {
                self.addPanGesture(to: center.view)
            }
        } else if keyPath == self.keyValue_2 {
            if let oc = object as? UIViewController, oc == self.centerPanel {
                self.placeButtonForLeftButton()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Panels
    private func swapCenter(_ previous: UIViewController?, previousState state: RSidePanelState, with next: UIViewController?) {
        guard previous != next else {
            return
        }
        
        previous?.willMove(toParent: nil)
        previous?.view.removeFromSuperview()
        previous?.removeFromParent()
        
        guard let getNext = next else {
            return
        }
        
        self.loadCenterPanelWithPreviousState(state)
        self.addChild(getNext)
        self.centerPanelContainer.addSubview(getNext.view)
        getNext.didMove(toParent: self)
    }
    
    // MARK: - Loading Panels
    private func loadCenterPanelWithPreviousState(_ previousState: RSidePanelState) {
        self.placeButtonForLeftButton()
        
        if self.style == .Multiple {
            
            var frame = self.centerPanelContainer.frame
            
            switch previousState {
            case .Left:
                frame.size.width = self.view.bounds.width
                break
            case .Right:
                frame.size.width = self.view.bounds.width
                frame.origin.x = -self.rightVisibleWidth
                break
            default:
                break
            }
            
            self.centerPanelContainer.frame = frame
        }
        
        guard let center = self.centerPanel else {
            return
        }
        center.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        center.view.frame = self.centerPanelContainer.bounds
    }
    
    private func loadLeftPanel() {
        self.rightPanelContainer.isHidden = true
        guard let left = self.leftPanel, self.leftPanelContainer.isHidden else {
            return
        }

        if left.view.superview == nil && left != self {
            self.layoutSidePanels()
            left.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.leftPanelContainer.addSubview(left.view)
        }

        self.leftPanelContainer.isHidden = left == self
    }
    
    private func loadRightPanel() {
        self.leftPanelContainer.isHidden = true
        guard let right = self.rightPanel, self.rightPanelContainer.isHidden else {
            return
        }
        
        if right.view.superview == nil && right != self {
            self.layoutSidePanels()
            right.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.rightPanelContainer.addSubview(right.view)
        }
        
        self.rightPanelContainer.isHidden = right == self
    }
    private func unloadPanels() {
        if let left = self.leftPanel, left.isViewLoaded, self.canUnloadLeftPanel {
            self.leftPanel?.view.removeFromSuperview()
        }
        
        if let right = self.rightPanel, right.isViewLoaded, self.canUnloadRightPanel {
            self.rightPanel?.view.removeFromSuperview()
        }
    }
    // MARK: - Gesture Recognizer Delegete
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.tapView {
            return true
        } else if self.panningLimitedToTopViewController && !self.isOnTopLevelViewController(self.centerPanel) {
            return false
        } else if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let translate = pan.translation(in: self.centerPanelContainer)
            // determine if right swipe is allowed
            if translate.x < 0 && !self.allowRightSwipe {
                return false
            }
            // determine if left swipe is allowed
            if translate.x > 0 && !self.allowLeftSwipe {
                return false
            }
            let possible = translate.x != 0 && (fabsf(Float(translate.y)) / fabsf(Float(translate.x))) < 1
            if possible && ((translate.x > 0 && (self.leftPanel != nil)) || (translate.x < 0 && (self.rightPanel != nil))) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Pan Gestures
    private func addPanGesture(to view: UIView) {
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ sender: UIGestureRecognizer) {
        guard let pan = sender as? UIPanGestureRecognizer, self.recognizesPanGesture else {
            return
        }
        
        if pan.state == .began {
            self.locationBeforePan = self.centerPanelContainer.frame.origin
        }
        
        let translate = pan.translation(in: self.centerPanelContainer)
        var frame = self.centerPanelRestingFrame
        
        frame.origin.x = frame.origin.x + CGFloat(roundf(Float(self.correct(move: translate.x))))
        
        if self.style == .Multiple {
            frame.size.width = self.view.bounds.width - frame.origin.x
        }
        self.centerPanelContainer.frame = frame
        
        if self.state == .Center {
            if frame.origin.x > 0 {
                self.loadLeftPanel()
            } else if frame.origin.x < 0 {
                self.loadRightPanel()
            }
        }
        
        if self.style == .Multiple || self.pushesSidePanels {
            self.layoutSideContainer(false, duration: 0)
        }
        
        if sender.state == .ended {
            let deltaX = frame.origin.x - self.locationBeforePan.x
            
            if self.validateThreshould(move: deltaX) {
                self.completePan(deltaX)
            } else {
                self.undoPan()
            }
            
        } else if sender.state == .cancelled {
            self.undoPan()
        }
    }
    
    private func completePan(_ panX: CGFloat) {
        switch self.state {
        case .Center:
            if panX > 0 {
                self.showLeftPanel(true, bounce: self.bounceOnSidePanelOpen)
            } else {
                self.showRightPanel(true, bounce: self.bounceOnSidePanelOpen)
            }
            break
        case .Left, .Right:
            self.showCenterPanel(true, bounce: self.bounceOnSidePanelClose)
            break
        }
    }
    private func undoPan() {
        switch self.state {
        case .Center:
            self.showCenterPanel(true, bounce: false)
            break
        case .Left:
            self.showLeftPanel(true, bounce: false)
            break
        case .Right:
            self.showRightPanel(true, bounce: false)
            break
        }
    }
    // MARK: - Tap Gesture
    private func addTapGesture(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(centerPanelTap(_:)))
        view.addGestureRecognizer(tap)
    }
    @objc private func centerPanelTap(_ sender: UIGestureRecognizer) {
        self.showCenterPanel(true, bounce: false)
    }
    // MARK: - Internal Methods
    private func correct(move moent: CGFloat) -> CGFloat {
        let position = self.centerPanelRestingFrame.origin.x + moent
        if self.state == .Center {
            if (position > 0 && self.leftPanel == nil) || (position < 0 && self.rightPanel == nil) {
                return 0
            } else if !self.allowLeftOverpan && position > self.leftVisibleWidth {
                return self.leftVisibleWidth
            } else if !self.allowRightOverpan && position < -self.rightVisibleWidth {
                return -self.rightVisibleWidth
            }
        } else if self.state == .Right && !self.allowRightOverpan {
            if position < -self.rightVisibleWidth {
                return 0
            } else if position > self.rightPanelContainer.frame.origin.x {
                return self.rightPanelContainer.frame.origin.x - self.centerPanelRestingFrame.origin.x
            }
        } else if self.state == .Left && !self.allowLeftOverpan {
            if position > self.leftVisibleWidth {
                return 0
            } else if (self.style == .Multiple || self.pushesSidePanels) && position < 0 {
                return -self.centerPanelRestingFrame.origin.x
            } else if position < self.leftPanelContainer.frame.origin.x {
                return self.leftPanelContainer.frame.origin.x - self.centerPanelRestingFrame.origin.x
            }
        }
        return moent
    }
    
    private func validateThreshould(move ment: CGFloat) -> Bool {
        let value = Float(UIScreen.main.bounds.width * self.minimumMovePercentage)
        let minimum = CGFloat(floorf(value))
        
        switch self.state {
        case .Left:
            return ment <= -minimum
        case .Center:
            return  CGFloat(fabsf(Float(ment))) >= minimum
        case .Right:
            return ment >= minimum
        }
    }
    
    private func isOnTopLevelViewController(_ root: UIViewController?) -> Bool {
        if let nav = root as? UINavigationController {
            return nav.viewControllers.count == 1
        } else if let tap = root as? UITabBarController {
            return self.isOnTopLevelViewController(tap.selectedViewController)
        }
        
        return root != nil
    }
    
    // MARK: - Animation
    private func calculatedDuration() -> TimeInterval {
        let remaValue = Double(self.centerPanelContainer.frame.origin.x - self.centerPanelRestingFrame.origin.x)
        let remaining = fabs(remaValue)
        
        let otherValue = Double(self.locationBeforePan.x - self.centerPanelRestingFrame.origin.x)
        let other = fabs(otherValue)
        
        let max = self.locationBeforePan.x == self.centerPanelRestingFrame.origin.x ? remaining : other
        
        return max > 0 ? self.maxmumAnimatinoDuration * (remaining / max) : self.maxmumAnimatinoDuration
    }
    
    private func animateCenterPanel(should bounce: Bool, completion: ((Bool) -> Void)?) {
        let bounceDistance = (self.centerPanelRestingFrame.origin.x - self.centerPanelContainer.frame.origin.x) * self.bouncePercentage
        
        var shouldBounce = bounce
        if self.centerPanelRestingFrame.size.width > self.centerPanelContainer.frame.size.width {
            shouldBounce = false
        }
        
        let duration = self.calculatedDuration()
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear, .layoutSubviews], animations: {
            self.centerPanelContainer.frame = self.centerPanelRestingFrame
            self.styleContainer(self.centerPanelContainer, animate: true, duration: duration)
            if self.style == .Multiple || self.pushesSidePanels {
                self.layoutSideContainer(false, duration: 0)
            }
        }) { (finished) in
            if shouldBounce {
                
                if self.state == .Center {
                    bounceDistance > 0 ? self.loadLeftPanel() : self.loadRightPanel()
                }

                UIView.animate(withDuration: self.bounceDuration, delay: 0, options: .curveEaseOut, animations: {
                    var bounceFrame = self.centerPanelRestingFrame
                    bounceFrame.origin.x = bounceFrame.origin.x + bounceDistance
                    self.centerPanelContainer.frame = bounceFrame
                }, completion: { (finish) in
                    UIView.animate(withDuration: self.bounceDuration, delay: 0, options: .curveEaseIn, animations: {
                        self.centerPanelContainer.frame = self.centerPanelRestingFrame
                    }, completion: completion)
                })
            } else if let com = completion {
                com(finished)
            }
        }
    }
    
    // MARK: - Panel Buttons
    private func placeButtonForLeftButton() {
        guard let _ = self.leftPanel, let center = self.centerPanel else {
            return
        }
        if let nav = center as? UINavigationController {
            if nav.viewControllers.count > 0 {
                self.centerPanel = nav.viewControllers[0]
            }
        }
        
        if let _ = center.navigationItem.leftBarButtonItem {
            center.navigationItem.leftBarButtonItem = self.leftButtonForCenterPanel()
        }
    }
    
    // MARK: - Style
    
    private func styleContainer(_ container: UIView, animate: Bool, duration: TimeInterval) {
        let shadowPath: UIBezierPath = UIBezierPath(rect: container.bounds)
        
        if animate {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowPath")
            animation.fromValue = container.layer.shadowPath
            animation.toValue = shadowPath.cgPath
            animation.duration = duration
            container.layer.add(animation, forKey: "shadowPath")
        }
        
        container.layer.shadowPath = shadowPath.cgPath
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowRadius = 10
        container.layer.shadowOpacity = 0.75
        container.clipsToBounds = false
    }
    
    private func configureContainers() {
        self.leftPanelContainer.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        self.rightPanelContainer.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        self.centerPanelContainer.frame = UIScreen.main.bounds
        self.centerPanelContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func layoutSideContainer(_ animate: Bool, duration: TimeInterval) {
        
        var leftFrame = UIScreen.main.bounds
        var rightFrame = UIScreen.main.bounds
        
        if self.style == .Multiple {
            // left panel container
            leftFrame.size.width = self.leftVisibleWidth
            leftFrame.origin.x = self.centerPanelContainer.frame.origin.x - leftFrame.size.width
            
            // right panel container
            rightFrame.size.width = self.rightVisibleWidth
            rightFrame.origin.x = self.centerPanelContainer.frame.origin.x + self.centerPanelContainer.frame.size.width
        } else if self.pushesSidePanels && !self.centerPanelHidden {
            leftFrame.origin.x = self.centerPanelContainer.frame.origin.x - self.leftVisibleWidth
            rightFrame.origin.x = self.centerPanelContainer.frame.origin.x + self.centerPanelContainer.frame.size.width
        }
        
        self.leftPanelContainer.frame = leftFrame
        self.rightPanelContainer.frame = rightFrame
        
        self.styleContainer(self.leftPanelContainer, animate: animate, duration: duration)
        self.styleContainer(self.rightPanelContainer, animate: animate, duration: duration)
    }
    
    private func layoutSidePanels() {
        if let right = self.rightPanel, right.isViewLoaded {
            var frame = self.rightPanelContainer.bounds
            if self.shouldResizeRightPanel {
                if !self.pushesSidePanels {
                    frame.origin.x = self.rightPanelContainer.bounds.width - self.rightVisibleWidth
                }
                frame.size.width = self.rightVisibleWidth
            }
            self.rightPanel?.view.frame = frame
        }
        
        if let left = self.leftPanel, left.isViewLoaded {
            var frame = self.leftPanelContainer.bounds
            if self.shouldResizeLeftPanel {
                frame.size.width = self.leftVisibleWidth
            }
            self.leftPanel?.view.frame = frame
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.centerPanelRestingFrame = self.centerPanelContainer.frame
        self.centerPanelHidden = false
        
        self.leftPanelContainer.isHidden = true
        self.rightPanelContainer.isHidden = true
        
        self.view.addSubview(self.centerPanelContainer)
        self.view.addSubview(self.leftPanelContainer)
        self.view.addSubview(self.rightPanelContainer)
        
        self.state = .Center
        
        self.swapCenter(nil, previousState: .Center, with: self.centerPanel)
        self.view.bringSubviewToFront(self.centerPanelContainer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.layoutSideContainer(false, duration: 0)
        self.layoutSidePanels()
        self.centerPanelContainer.frame = self.adiustCenterFrame
        self.styleContainer(self.centerPanelContainer, animate: false, duration: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = self.adiustCenterFrame
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.centerPanel?.removeObserver(self, forKeyPath: self.keyValue_1)
        self.centerPanel?.removeObserver(self, forKeyPath: self.keyValue_2)
    }
}
