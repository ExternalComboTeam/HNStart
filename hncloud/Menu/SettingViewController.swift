//
//  SettingViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift

enum SettingType: Int {
    case clock = 11
    case phone = 12
    case message = 13
    case sit = 14
    case heart = 15
    case forget = 16
    case device = 17
    case setting = 18
}

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
    
    private var type: SettingType = .clock
    
    private var isPhoneAlarmOpen = false
    
    @IBAction func buttonAction(_ sender: UIButton) {
        self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
        self.type = SettingType.init(rawValue: sender.tag) ?? .clock
        self.buttonSet(sender, isSelected: true)
        
//        // MARK: Cell bluetooth setting.
//        switch self.type {
//        case .clock:
//        // TODO: - 鬧鐘
//            break
//        case .phone:
//            
//            if CositeaBlueTooth.instance.isConnected {
//                
//                CositeaBlueTooth.instance.checkSystemAlarm(withType: .Phone) { (index, states) in
//                    
//                    if SystemAlarmType(rawValue: index) == .Phone {
//                        
//                        self.isPhoneAlarmOpen = states != 0
//                        
//                    }
//                    
//                }
//                
//            }
//            
//            
//            
//        case .message:
//            <#code#>
//        case .sit:
//            <#code#>
//        case .heart:
//            <#code#>
//        case .forget:
//            <#code#>
//        case .device:
//            <#code#>
//        case .setting:
//            <#code#>
//        }
        
        
        self.myTableView.reloadData()
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
        self.myTableView.register(xib: SwitchCell.xib, HeartCell.xib, SettingCell.xib, PhoneCell.xib, MessageCell.xib, SetRemindCell.xib)
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.clockButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.phoneButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.messageButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.sitButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.heartButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.forgetButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.deviceButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.deviceSettingButton.addBoard(.bottom, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
        self.settingStackView.addBoard(.right, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), thickness: 0.5)
    }
}
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .clock:
            return 1
        case .phone, .message, .heart, .forget, .device, .setting:
            return 1
        case .sit:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.type {
        case .clock:
            let cell = SetRemindCell.use(table: tableView, for: indexPath)
            cell.type = self.type
            return cell
        case .phone:
            let cell = PhoneCell.use(table: tableView, for: indexPath)
            
            return cell
        case .message:
            let cell = MessageCell.use(table: tableView, for: indexPath)
            return cell
        case .sit:
            let cell = SetRemindCell.use(table: tableView, for: indexPath)
            cell.type = self.type
            return cell
        case .heart:
            let cell = HeartCell.use(table: tableView, for: indexPath)
            return cell
        case .forget:
            let cell = SwitchCell.use(table: tableView, for: indexPath)
            cell.titleLabel.text = "防丟提醒".localized()
            cell.action { (sender) in
                print("onOff = \(sender.isOn)")
            }
            return cell
        case .device:
            let cell = SwitchCell.use(table: tableView, for: indexPath)
            cell.titleLabel.text = "抬腕喚醒".localized()
            cell.action { (sender) in
                print("onOff = \(sender.isOn)")
            }
            return cell
        case .setting:
            let cell = SettingCell.use(table: tableView, for: indexPath)
            return cell
        }
    }
}
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard !(cell is SwitchCell) && !(cell is SettingCell) && !(cell is HeartCell) && !(cell is PhoneCell) && !(cell is MessageCell) else { return }
        
    }
}
