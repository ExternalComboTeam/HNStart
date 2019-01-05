//
//  MenuViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/26.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var btStateLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var batteryImageView: UIImageView!
    
    @IBAction func logoutAction(_ sender: Any) {
        UserInfo.share.clear()
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func userInfoAction(_ sender: Any) {
        let vc = UserInfoViewController.fromStoryboard()
        vc.isEdit = false
        self.pushed(vc)
        /*
        guard let side = self.parent as? RSideViewController else { return }
        side.closeMenu()
        side.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    enum MenuType {
        case device
        case capsule
        case camera
        case setting
        case about
        
        var title: String {
            switch self {
            case .device:
                return "設備管理".localized()
            case .capsule:
                return "用藥管理".localized()
            case .camera:
                return "遠程拍照".localized()
            case .setting:
                return "設置".localized()
            case .about:
                return "關於".localized()
            }
        }
        var image: UIImage? {
            switch self {
            case .device:
                return UIImage(named: "device_amd")
            case .capsule:
                return UIImage(named: "capsule")
            case .camera:
                return UIImage(named: "camera")
            case .setting:
                return UIImage(named: "settings")
            case .about:
                return UIImage(named: "about")
            }
        }
    }
    
    private var menuArray: [MenuType] = []
    private var observe: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        self.setMenuArray(with: UserInfo.share.deviceType)
        self.observe = UserInfo.share.observe(\.deviceChange) { (user, _) in
            self.setMenuArray(with: user.deviceType)
        }
        (self.parent as? RSideViewController)?.open({
            self.checkBandPower()
            self.bandConnecticCheck()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNickName.text = UserInfo.share.nickName
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.observe?.invalidate()
    }
    /// 設定目錄選項
    private func setMenuArray(with device: DeviceType) {
        switch device {
        case .Watch:
            self.menuArray = [.device, .capsule, .camera, .setting, .about]
            break
        case .Wristband:
            self.menuArray = [.device, .camera, .setting, .about]
            break
        default:
            break
        }
        self.menuTableView.reloadData()
    }

    private func pushed(_ vc: UIViewController) {
        guard let side = self.parent as? RSideViewController else { return }
        side.closeMenu()
        side.push(vc: vc)
    }
    
    func checkBandPower() {
        PZBlueToothManager.instance.checkBandPower { (power) in
            print("🔋🔋🔋  bandPower = \(power)")
            
            guard let batteryState = BatteryState(power) else { return }
            
            self.batteryImageView.image = batteryState.image
            self.batteryLabel.text = "\(power)%"
        }
    }
    func bandConnecticCheck() {
        var btState = "未連接".localized()
        if CositeaBlueTooth.instance.isConnected {
            btState = "已連接".localized()
        }
        self.btStateLabel.text = btState
    }
}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.imageView?.image = self.menuArray[indexPath.row].image?.scaled(toHeight: 30)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = self.menuArray[indexPath.row].title
        return cell
    }
}
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.menuArray[indexPath.row] {
        case .device:
            self.pushed(DeviceSettingViewController.fromStoryboard())
        case .capsule:
            break
        case .camera:
            self.pushed(CameraViewController.fromStoryboard())
        case .setting:
            self.pushed(SettingViewController.fromStoryboard())
        case .about:
            self.pushed(AboutViewController.fromStoryboard())
        }
    }
}
