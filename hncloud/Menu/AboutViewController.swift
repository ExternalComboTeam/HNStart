//
//  AboutViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var appVersion: UITextField!
    @IBOutlet weak var deviceVersion: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    
    private lazy var version: String = {
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "" }
        return currentVersion
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "關於".localized())
        
        self.appVersion.isEnabled = false
        self.deviceVersion.isEnabled = false
        
        let appVersionLabel: UILabel = UILabel(text: "App版本".localized() + "：")
        appVersionLabel.sizeToFit()
        appVersionLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.appVersion.leftView = appVersionLabel
        self.appVersion.leftViewMode = .always
        
        let deviceLabel: UILabel = UILabel(text: "韌體版本".localized() + "：")
        deviceLabel.sizeToFit()
        deviceLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.deviceVersion.leftView = deviceLabel
        self.deviceVersion.leftViewMode = .always
        
        self.setBandFirmwareVersion()
        
        let descriptionLabel: UILabel = UILabel(text: "產品說明")
        descriptionLabel.sizeToFit()
        descriptionLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.descriptionText.leftView = descriptionLabel
        self.descriptionText.leftViewMode = .always
        
        self.appVersion.text = self.version
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.appVersion.addBoard(.bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), thickness: 0.5)
        self.deviceVersion.addBoard(.bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), thickness: 0.5)
        self.descriptionText.addBoard(.bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), thickness: 0.5)
    }
    
    private func setBandFirmwareVersion() {
        guard CositeaBlueTooth.instance.isConnected else {
            self.deviceVersion.text = "未連接".localized()
            return
        }
        PZBlueToothManager.instance.checkVerSion { [weak self] (firstFirmwareVersion, secondFirmwareVersion, softwareVersion, bluetoothVersion) in
            var deviceVersionText = ""
            if softwareVersion == 161616 {
                deviceVersionText = String(format: "%02x.%02x.%02x", firstFirmwareVersion, bluetoothVersion, softwareVersion)
            } else {
                deviceVersionText = String(format: "%02x%02x.%02x.%02x", secondFirmwareVersion, firstFirmwareVersion, bluetoothVersion, softwareVersion)
            }
            DispatchQueue.main.async {
                self?.deviceVersion.text = deviceVersionText
            }
        }
    }
}
