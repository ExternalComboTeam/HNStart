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
        
        self.appVersion.text = self.version
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.appVersion.addBoard(.bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), thickness: 0.5)
        self.deviceVersion.addBoard(.bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), thickness: 0.5)
        self.descriptionText.addBoard(.bottom, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), thickness: 0.5)
    }
}
