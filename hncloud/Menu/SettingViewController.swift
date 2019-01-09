//
//  SettingViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import KRProgressHUD

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
    
    var fisrtCellIsCompleted = false
    
    
    // MARK: Clock alarm.
    var clockAlarmDataArray: [CustomAlarmModel] = []
    
    // MARK: Phone alarm.
    var isPhoneAlarmOpen = false
    /// 無延遲 = 0, 4秒 = 1, 10秒 = 2
    var phoneDelayType = 0
    
    // MARK: Message alarm.
    var isMessageAlarmOpen = false
    
    // MARK: Sedentary remind.
    var sedentaryDataArray: [SedentaryModel] = []
    var exitArray = ["", "", "", ""]
    
    // MARK: Forget remind.
    var isForgetRemindOpen = false
    
    // MARK: Device wake up.
    var isDevicWakeUpOpen = false
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        btnAction(sender)
    }
    
    func btnAction(_ sender: UIButton? = nil) {
        
        fisrtCellIsCompleted = false
        
        if let sender = sender {
            self.settingStackView.arrangedSubviews.forEach({ self.buttonSet($0 as! UIButton, isSelected: false) })
            self.type = SettingType.init(rawValue: sender.tag) ?? .clock
            self.buttonSet(sender, isSelected: true)
        }
        
        // MARK: Cell bluetooth setting.
        switch self.type {
        case .clock:
            
            KRProgressHUD.show()
            perform(#selector(dismissHUD), with: nil, afterDelay: 5)
            
            if CositeaBlueTooth.instance.isConnected {
                
                CositeaBlueTooth.instance.checkAlarm { (model) in
                    if let model = model {
                        self.clockAlarmDataArray.append(model)
                        self.clockAlarmCheck()
                    }
                }
            }
            
            
            
            
            
            
        case .phone:
            
            KRProgressHUD.show()
            perform(#selector(dismissHUD), with: nil, afterDelay: 5)
            
            if CositeaBlueTooth.instance.isConnected {
                
                CositeaBlueTooth.instance.checkSystemAlarm(withType: .Phone) { (index, states) in
                    
                    if SystemAlarmType(rawValue: index) == .Phone {
                        
                        self.isPhoneAlarmOpen = states != 0
                        
                        CositeaBlueTooth.instance.checkPhoneDealay { (delay) in
                            if delay == 255 || delay == 0 {
                                self.phoneDelayType = 0
                            } else if delay > 2, delay < 8 {
                                self.phoneDelayType = 1
                            } else {
                                self.phoneDelayType = 2
                            }
                            
                            KRProgressHUD.dismiss()
                            
                            self.myTableView.reloadData()
                        }
                    }
                }
            }
            
            
            break
            
            
            
        case .message:
            
            KRProgressHUD.show()
            perform(#selector(dismissHUD), with: nil, afterDelay: 5)
            
            if CositeaBlueTooth.instance.isConnected {
                
                CositeaBlueTooth.instance.checkSystemAlarm(withType: .SMS) { (index, states) in
                    
                    if SystemAlarmType(rawValue: index) == .SMS {
                     
                        self.isMessageAlarmOpen = states != 0
                        
                        KRProgressHUD.dismiss()
                        self.myTableView.reloadData()
                    }
                }
            }
            
            
        case .sit:
            
            
            
            KRProgressHUD.show()
            perform(#selector(dismissHUD), with: nil, afterDelay: 5)
            
            if CositeaBlueTooth.instance.isConnected {
                
                CositeaBlueTooth.instance.checkSedentary { (modelArray) in
                    
                    self.sedentaryDataArray = modelArray as? [SedentaryModel] ?? []
                    for i in 0..<self.sedentaryDataArray.count {
                        self.exitArray[i] = "\(self.sedentaryDataArray[i].index)"
                    }
                    KRProgressHUD.dismiss()
                    self.fisrtCellIsCompleted = false
                    self.myTableView.reloadData()
                }
            }
            
            
        case .heart:
            break
        case .forget:
            
            KRProgressHUD.show()
            perform(#selector(dismissHUD), with: nil, afterDelay: 5)
            
            if CositeaBlueTooth.instance.isConnected {
                
                CositeaBlueTooth.instance.checkSystemAlarm(withType: .Antiloss) { (index, states) in
                    if SystemAlarmType(rawValue: index) == .Antiloss {
                        self.isForgetRemindOpen = states != 0
                        KRProgressHUD.dismiss()
                        self.myTableView.reloadData()
                    }
                }
            }
            
            
            
            
        case .device:
            
            KRProgressHUD.show()
            perform(#selector(dismissHUD), with: nil, afterDelay: 5)
            
            if CositeaBlueTooth.instance.isConnected {
                
                CositeaBlueTooth.instance.checkSystemAlarm(withType: .Taiwan) { (index, states) in
                    if SystemAlarmType(rawValue: index) == .Taiwan {
                        self.isDevicWakeUpOpen = states != 0
                        KRProgressHUD.dismiss()
                        self.myTableView.reloadData()
                    }
                }
            }
            
            
        case .setting:
            break
        }
        
        
        self.myTableView.reloadData()
    }
    
    @objc func dismissHUD() {
        KRProgressHUD.dismiss()
    }
    
    var clockAlarmCheckCounter = 0
    func clockAlarmCheck() {
        clockAlarmCheckCounter += 1
        if clockAlarmCheckCounter == 8 {
            KRProgressHUD.dismiss()
            self.fisrtCellIsCompleted = false
            self.myTableView.reloadData()
            clockAlarmCheckCounter = 0
        }
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

        self.myTableView.isScrollEnabled = false
        
        self.setBackButton(title: "設置".localized())
        self.setButtonIcon()
        self.myTableView.tableFooterView = UIView()
        self.buttonSet(self.clockButton, isSelected: true)
        self.myTableView.register(xib: SwitchCell.xib, HeartCell.xib, SettingCell.xib, PhoneCell.xib, MessageCell.xib, SetRemindCell.xib, SedentaryCell.xib, ClockCell.xib)
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        if UserInfo.share.deviceType == .Wristband {
            self.deviceSettingButton.isHidden = true
            self.deviceSettingButton.isEnabled = false
        }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnAction()
    }
}
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .clock:
            return self.clockAlarmDataArray.count + 1
        case .phone, .message, .heart, .forget, .device, .setting:
            return 1
        case .sit:
            return self.sedentaryDataArray.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.type {
        case .clock:
            if indexPath.row == 0 {
                let cell = SetRemindCell.use(table: tableView, for: indexPath)
                cell.type = self.type
                return cell
            } else {
                let cell = ClockCell.use(table: tableView, for: indexPath)
                
                return cell
            }
        case .phone:
            let cell = PhoneCell.use(table: tableView, for: indexPath)
            cell.set(isOn: self.isPhoneAlarmOpen, delayType: self.phoneDelayType)
            return cell
        case .message:
            let cell = MessageCell.use(table: tableView, for: indexPath)
            cell.set(isOn: self.isMessageAlarmOpen)
            return cell
        case .sit:
            if fisrtCellIsCompleted {
                let cell = SedentaryCell.use(table: tableView, for: indexPath)
                let data = self.sedentaryDataArray[indexPath.row - 1]
                let title = "\(data.beginHour):\(data.beginMin)-\(data.endHour):\(data.endMin)"
                let detail = "\(data.duration)分鐘起身"
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = detail
                return cell
            } else {
                fisrtCellIsCompleted = true
                let cell = SetRemindCell.use(table: tableView, for: indexPath)
                cell.type = self.type
                cell.exitArray = self.exitArray
                return cell
            }
            
        case .heart:
            let cell = HeartCell.use(table: tableView, for: indexPath)
            return cell
        case .forget:
            let cell = SwitchCell.use(table: tableView, for: indexPath)
            cell.titleLabel.text = "防丟提醒".localized()
            cell.action { (sender) in
                guard CositeaBlueTooth.instance.isConnected else {
                    return
                }
                CositeaBlueTooth.instance.setSystemAlarmWithType(.Antiloss, state: sender.isOn.int)
                CositeaBlueTooth.instance.checkSystemAlarm(withType: .Antiloss, stateBlock: { (_, _) in
                })
            }
            return cell
        case .device:
            let cell = SwitchCell.use(table: tableView, for: indexPath)
            cell.titleLabel.text = "抬腕喚醒".localized()
            cell.action { (sender) in
                guard CositeaBlueTooth.instance.isConnected else {
                    return
                }
                CositeaBlueTooth.instance.setSystemAlarmWithType(.Taiwan, state: sender.isOn.int)
                CositeaBlueTooth.instance.setSystemAlarmWithType(.Fanwan, state: sender.isOn.int)
                CositeaBlueTooth.instance.checkSystemAlarm(withType: .Taiwan, stateBlock: { (_, _) in
                })
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
        
        if cell is SedentaryCell {
            let vc = SedentaryViewController.fromStoryboard()
            vc.exitArray = self.exitArray
            self.push(vc: vc)
        }
    }
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        switch self.type {
        case .sit:
            
            let i = indexPath.row - 1
            guard  i <= 0 else {
                return nil
            }
            
            let action = UITableViewRowAction(style: .normal, title: "刪除") { (action, indexPath) in
                let index = self.sedentaryDataArray[i].index
                self.sedentaryDataArray.remove(at: i)
                self.exitArray[i] = ""
                CositeaBlueTooth.instance.deleteSedentaryAlarm(with: index)
                self.btnAction()
            }
            action.backgroundColor = .red
            return [action]
            
        default:
            return nil
        }
    
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch self.type {
        case .sit:
            return indexPath.row != 0
        default:
            return false
        }
    }
}
