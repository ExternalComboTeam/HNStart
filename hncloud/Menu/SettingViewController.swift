//
//  SettingViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settingStackView: UIStackView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var clockButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var sitButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var deviceSettingButton: UIButton!
    
    
    @IBAction func clockAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func phoneAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func messageAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func sitAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func heartAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func forgetAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func deviceAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    @IBAction func settingAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.buttonSet(sender, isSelected: true)
    }
    
    private func buttonSet(_ button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        button.backgroundColor = isSelected ? #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func setButtonIcon() {
        self.set(self.clockButton, image: UIImage(named: "clock"), selected: UIImage(named: "clock_check"))
        self.set(self.phoneButton, image: UIImage(named: "phone"), selected: UIImage(named: "phone_check"))
        self.set(self.messageButton, image: UIImage(named: "info"), selected: UIImage(named: "info_check"))
        self.set(self.sitButton, image: UIImage(named: "sitting"), selected: UIImage(named: "sit_icon_check"))
        self.set(self.heartButton, image: UIImage(named: "heartwarning"), selected: UIImage(named: "heart_icon_check"))
        self.set(self.forgetButton, image: UIImage(named: "lost"), selected: UIImage(named: "lost_check"))
        self.set(self.deviceButton, image: UIImage(named: "hand_up"), selected: UIImage(named: "hand_up_check"))
        self.set(self.deviceSettingButton, image: UIImage(named: "check_device_menu_checked"), selected: UIImage(named: "device_menu_not_checked"))
    }
    private func set(_ button: UIButton, image normal: UIImage?, selected: UIImage?) {
        button.setImage(normal?.scaled(toHeight: 25), for: .normal)
        button.setImage(selected?.scaled(toHeight: 25), for: .selected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "設置".localized())
        self.setButtonIcon()
        self.myTableView.tableFooterView = UIView()
        self.buttonSet(self.clockButton, isSelected: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.clockButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.phoneButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.messageButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.sitButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.heartButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.forgetButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.deviceButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.deviceSettingButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
        self.settingStackView.addBoard(.right, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 1)
    }
}
