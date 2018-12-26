//
//  DeviceSettingViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class DeviceSettingViewController: UIViewController {

    private lazy var choseDevice: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        let image = UIImage(named: "devicetype")?.scaled(toHeight: 25)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(chose), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var findView: UIView!
    @IBOutlet weak var findTitleLabel: UILabel!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var resetTitleLabel: UILabel!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var clearTitleLabel: UILabel!
    
    @IBAction func connectAction(_ sender: UIButton) {
        if UserInfo.share.isConnect {
            // 解除綁定
            UserInfo.share.deviceToken = "未綁定".localized()
            sender.setTitle("綁定設備".localized(), for: .normal)
        } else {
            let vc = BTListViewController.fromStoryboard()
            self.push(vc: vc)
        }
    }
    // 選擇設備
    @objc private func chose() {
        let vc = DeviceListViewController.fromStoryboard()
        self.push(vc: vc)
    }
    // 尋找設備
    @objc private func searchDevice() {
        print("尋找設備")
    }
    // 恢復設備
    @objc private func resetDevice() {
        print("恢復設備")
    }
    // 清除資料
    @objc private func clearLocalData() {
        print("清除資料")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.choseDevice]
        
        self.findTitleLabel.text = "找手環".localized() + "\n" + "讓你的手環震動，方便查找"
        self.resetTitleLabel.text = "恢復原廠設置".localized()
        self.clearTitleLabel.text = "清除本地數據".localized()
        
        let findTap = UITapGestureRecognizer(target: self, action: #selector(searchDevice))
        self.findView.addGestureRecognizer(findTap)
        let resetTap = UITapGestureRecognizer(target: self, action: #selector(resetDevice))
        self.resetView.addGestureRecognizer(resetTap)
        let clearTap = UITapGestureRecognizer(target: self, action: #selector(clearLocalData))
        self.clearView.addGestureRecognizer(clearTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBackButton(title: UserInfo.share.deviceType.rawValue)
        self.deviceImage.image = UIImage(named: UserInfo.share.isConnect ? "device_connect" : "device_disconnect")
        self.connectButton.setTitle(UserInfo.share.isConnect ? "綁定設備".localized() : "解除綁定".localized(), for: .normal)
    }
}
