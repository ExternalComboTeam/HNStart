//
//  RSideViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class RSideViewController: UIViewController, UIGestureRecognizerDelegate {

    private var leftViewController: UIViewController?
    private var mainViewController: UIViewController?
    
    private var originalPoint: CGPoint = .zero
    
    private lazy var menuWidth: CGFloat = {
        return UIScreen.main.bounds.width * 0.8
    }()
    private lazy var emptyWith: CGFloat = {
        return UIScreen.main.bounds.width * (1 - 0.75)
    }()
    
    /// 遮罩视图
    private lazy var coverView: UIView = { [unowned self ] in
        let coverView:UIView = UIView(frame: self.view.bounds)
        coverView.backgroundColor = UIColor.clear
        coverView.isHidden = true
        return coverView
    }()
    
    lazy private var shadowView: UIView = { [unowned self] in
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.brown
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    convenience init(leftViewController: UIViewController, mainViewController: UIViewController) {
        self.init()
        self.leftViewController = leftViewController
        self.mainViewController = mainViewController
        
        self.addChild(leftViewController)
        self.addChild(mainViewController)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(leftViewController.view)
        self.view.addSubview(self.shadowView)
        self.view.addSubview(mainViewController.view)
    }
    
    override var navigationController: UINavigationController? {
        guard let navigation = self.mainViewController as? UINavigationController else { return nil }
        return navigation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let main = self.mainViewController else { return }
        main.children.forEach { [weak self] (controller) in
            guard let `self` = self else { return }
            let pan = UIPanGestureRecognizer.init(target: self, action:#selector(self.handlePan(_:)) )
            pan.delegate = self
            if let navigation = controller as? UINavigationController {
                navigation.topViewController?.view.addGestureRecognizer(pan)
            } else {
                controller.view.addGestureRecognizer(pan)
            }
        }
        let pan = UIPanGestureRecognizer(target: self, action:#selector(self.handlePan(_:)) )
        pan.delegate = self
        self.coverView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)) )
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        self.coverView.addGestureRecognizer(tap)
        
        main.view.addSubview(self.coverView)
        main.view.bringSubviewToFront(self.coverView)
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        let coverViewH = "H:|[a]|"
        let viewConstraint = ["a": coverView]
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: coverViewH, options:.directionLeftToRight, metrics: nil, views: viewConstraint)
        main.view.addConstraints(constraints)
        
        let coverViewV = "V:|[a]|"
        let constraints2 = NSLayoutConstraint.constraints(withVisualFormat: coverViewV, options: .directionLeftToRight, metrics: nil, views: viewConstraint)
        main.view.addConstraints(constraints2)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    /// 拖拽手勢
    ///
    /// - Parameter pan: 處理拖拽手勢
    @objc private func handlePan(_ pan: UIPanGestureRecognizer){
        guard let main = self.mainViewController else { return }
        switch pan.state {
        case .began:
            self.originalPoint = CGPoint(x: main.view.frame.minX, y: main.view.frame.midY)
        case .changed:
            let point = pan.translation(in: self.view)
            var x = originalPoint.x + point.x
            x = x > 0 ? x : 0
            x = x < menuWidth ? x : menuWidth
            self.changeMainPosition(CGPoint(x: x + main.view.frame.width * 0.5, y: main.view.frame.midY))
            self.updateLeftViewFrame()
            self.coverView.isHidden = false
        case .ended:
            self.leftView(open: main.view.frame.minX > self.menuWidth * 0.5)
        default: print("other")
        }
    }
    
    private func changeMainPosition(_ point: CGPoint) {
        guard let main = self.mainViewController else { return }
        main.view.center = point
        self.shadowView.center = point
    }
    func openMenu() {
        self.leftView(open: true)
    }
    func closeMenu() {
        self.leftView(open: false)
    }
    /// 遮罩點擊手勢
    ///
    /// - Parameter pan: 點擊
    @objc private func handleTap(_ tap: UITapGestureRecognizer){
        self.leftView(open: false)
    }
    private func updateLeftViewFrame(){
        guard let left = self.leftViewController, let main = self.mainViewController else { return }
        left.view.center = CGPoint(x: (main.view.frame.minX + self.emptyWith) * 0.5, y: main.view.frame.midY)
    }
    private func leftView(open: Bool) {
        guard let main = self.mainViewController else { return }
        if open {
            self.coverView.isHidden = !open
        }
        let x = open ? self.view.frame.width * 0.5 + self.menuWidth : main.view.frame.width * 0.5
        UIView.animate(withDuration: 0.25, animations: {
            self.changeMainPosition(CGPoint(x: x, y: main.view.frame.midY))
            self.updateLeftViewFrame()
        }) { (finished) in
            self.coverView.isHidden = !open
        }
    }
}
