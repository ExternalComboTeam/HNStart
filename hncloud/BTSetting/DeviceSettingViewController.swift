//
//  DeviceSettingViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

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
            self.setDeviceStatus()
        } else {
            let vc = BTListViewController.fromStoryboard()
            self.push(vc: vc)
        }
    }
    // 選擇設備
    @objc private func chose() {
        let vc = DeviceListViewController.fromStoryboard()
        vc.delegate = self
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
    
    private func setDeviceStatus() {
        self.deviceImage.image = UIImage(named: UserInfo.share.isConnect ? "device_connect" : "device_disconnect")
        self.deviceName.text = UserInfo.share.deviceToken
        self.connectButton.setTitle(UserInfo.share.isConnect ? "解除綁定".localized() : "綁定設備".localized(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.choseDevice]
        self.deviceView.gradientColors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)]
        self.findTitleLabel.text = "找手環".localized() + "\n" + "讓你的手環震動，方便查找".localized()
        self.resetTitleLabel.text = "恢復原廠設置".localized()
        self.clearTitleLabel.text = "清除本地數據".localized()
        
        let findTap = UITapGestureRecognizer(target: self, action: #selector(searchDevice))
        self.findView.addGestureRecognizer(findTap)
        let resetTap = UITapGestureRecognizer(target: self, action: #selector(resetDevice))
        self.resetView.addGestureRecognizer(resetTap)
        let clearTap = UITapGestureRecognizer(target: self, action: #selector(clearLocalData))
        self.clearView.addGestureRecognizer(clearTap)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.deviceView.gradientColors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)]
        
        self.findView.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.resetView.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.clearView.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBackButton(title: UserInfo.share.deviceType.rawValue)
        self.setDeviceStatus()
    }
}


// MARK: - DeviceListViewControllerDelegate.

extension DeviceSettingViewController: DeviceListViewControllerDelegate {
    
    func deviceisChange(_ change: Bool) {
        
        var title: String {
            
            switch UserInfo.share.deviceType {
            case .Wristband:
                
                if change {
                    return "設備類型已切換為手環"
                } else {
                    return "設備類型已經是手環，無需切換"
                }
                
            case .Watch:
                
                if change {
                    return "設備類型已切換為手錶"
                } else {
                    return "設備類型已經是手錶，無需切換"
                }
                
            case .none:
                return ""
            }
            
        }
        
        KRProgressHUD.showMessage(title.localized())
    }
    
}
