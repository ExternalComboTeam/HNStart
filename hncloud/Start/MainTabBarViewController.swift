//
//  MainTabBarViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CoreBluetooth

class MainTabBarViewController: UITabBarController {

    lazy private var menuButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        button.setImage(UIImage(named: "three_line"), for: .normal)
        button.addTarget(self, action: #selector(sideMenu), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var shareButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_share"), for: .normal)
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var curveButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_trend"), for: .normal)
        button.addTarget(self, action: #selector(curve), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var titleView: UITextField = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        leftImage.center = CGPoint(x: 15, y: 15)
        leftImage.image = UIImage(named: "provios")
        leftButton.addSubview(leftImage)
        leftButton.addTarget(self, action: #selector(lessDate), for: .touchUpInside)
        view.leftView = leftButton
        view.leftViewMode = .always
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        rightImage.center = CGPoint(x: 15, y: 15)
        rightImage.image = UIImage(named: "next")
        rightButton.addSubview(rightImage)
        rightButton.addTarget(self, action: #selector(addDate), for: .touchUpInside)
        view.rightView = rightButton
        view.rightViewMode = .always
        view.text = UserInfo.share.selectedDate.localDate()
        view.textAlignment = .center
        view.delegate = self
        return view
    }()
    
    lazy private var sugerViewController: SugerViewController = {
        let vc = SugerViewController.fromStoryboard()
        vc.tabBarItem = self.sugerTabBarItem
        return vc
    }()
    lazy private var sugerTabBarItem: UITabBarItem = {
        let tab = UITabBarItem(title: "", image: UIImage(named: "suger_icon"), tag: 4)
        tab.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return tab
    }()
    
    private var observe: NSKeyValueObservation?
    //
    @objc private func lessDate() {
        let less = UserInfo.share.selectedDate.adding(.day, value: -1)
        self.titleView.text = less.localDate()
        UserInfo.share.selectedDate = less
    }
    @objc private func addDate() {
        guard !UserInfo.share.selectedDate.isInToday else { return }
        let add = UserInfo.share.selectedDate.adding(.day, value: 1)
        self.titleView.text = add.localDate()
        UserInfo.share.selectedDate = add
    }
    // 側拉選單
    @objc private func sideMenu() {
        guard let menu = self.parent?.parent as? RSideViewController else { return }
        menu.openMenu()
    }
    // 分享
    @objc private func share(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        var shareItem: [Any] = []
        shareItem.append(window.asImage())
        let share = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        // 設定郵件的標題
        share.setValue(title, forKey: "subject")
        
        var shareType: [UIActivity.ActivityType] = [.addToReadingList, .airDrop, .assignToContact, .openInIBooks, .postToFlickr, .postToTencentWeibo, .postToVimeo, .print , .saveToCameraRoll]
        if #available(iOS 11.0, *) {
            shareType.append(.markupAsPDF)
        }
        
        share.popoverPresentationController?.sourceView = sender
        share.popoverPresentationController?.sourceRect = sender.bounds
        share.excludedActivityTypes = shareType
        share.completionWithItemsHandler = { (type, tage, array, error) in
            //
        }
        DispatchQueue.main.async {
            self.present(share, animated: true, completion: nil)
        }
    }
    // 曲線圖
    @objc private func curve() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationItem.titleView = self.titleView
        self.navigationItem.leftBarButtonItems = [self.menuButton]
        self.navigationItem.rightBarButtonItems = [self.shareButton, self.curveButton]
        
        self.checkViewControllers()
        self.setIcon()
        
        self.observe = UserInfo.share.observe(\.deviceChange) { (user, _) in
            self.checkViewControllers()
            self.setIcon()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleView.text = UserInfo.share.selectedDate.localDate()
    }
    
    private func checkViewControllers() {
        guard let controllers = self.viewControllers else { return }
        switch UserInfo.share.deviceType {
        case .Watch:
            guard !controllers.contains(where: { $0 is SugerViewController }) else { return }
            self.viewControllers?.append(self.sugerViewController)
            break
        case .Wristband:
            guard let index = controllers.firstIndex(where: { $0 is SugerViewController }) else { return }
            self.viewControllers?.remove(at: index)
            break
        default:
            break
        }
    }
    
    private func setIcon() {
        self.tabBar.items?.forEach({ (item) in
            switch item.tag {
            case 0:
                item.image = UIImage(named: "active_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "active_checked")?.scaled(toHeight: 40)
                break
            case 1:
                item.image = UIImage(named: "movement_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "movement_checked")?.scaled(toHeight: 40)
                break
            case 2:
                item.image = UIImage(named: "sleep_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "sleep_checked")?.scaled(toHeight: 40)
                break
            case 3:
                item.image = UIImage(named: "blood_not_checked")?.scaled(toHeight: 40)
                item.selectedImage = UIImage(named: "blood_checked")?.scaled(toHeight: 35)
                break
            case 4:
                item.image = UIImage(named: "suger_icon")?.scaled(toHeight: 45)
                item.selectedImage = UIImage(named: "suger_icon_blue")?.scaled(toHeight: 45)
                break
            default:
                break
            }
            
        })
    }

}
extension MainTabBarViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.selectDate(date: UserInfo.share.selectedDate) { (date) in
            UserInfo.share.selectedDate = date
        }
        return false
    }
}
