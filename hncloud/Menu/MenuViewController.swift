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
    @IBAction func logoutAction(_ sender: Any) {
        UserInfo.share.clear()
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func userInfoAction(_ sender: Any) {
        let vc = UserInfoViewController.fromStoryboard()
        vc.isEdit = false
        guard let side = self.parent as? RSideViewController else { return }
        side.closeMenu()
        side.navigationController?.pushViewController(vc, animated: false)
    }
    
    private lazy var menuArray: [(UIImage?, String)] = {
        var array: [(UIImage?, String)] = []
        array.append((UIImage(named: "device_amd"), "設備管理".localized()))
        array.append((UIImage(named: "capsule"), "用藥管理".localized()))
        array.append((UIImage(named: "camera"), "遠程拍照".localized()))
        array.append((UIImage(named: "settings"), "設置".localized()))
        array.append((UIImage(named: "about"), "關於".localized()))
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
    }

    private func pushed(_ vc: UIViewController) {
        guard let side = self.parent as? RSideViewController else { return }
        side.closeMenu()
        side.push(vc: vc)
    }
}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.imageView?.image = self.menuArray[indexPath.row].0?.scaled(toHeight: 30)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = self.menuArray[indexPath.row].1
        return cell
    }
}
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.pushed(DeviceSettingViewController.fromStoryboard())
            break
        case 1:
            break
        case 2:
            self.pushed(CameraViewController.fromStoryboard())
            break
        case 3:
            break
        case 4:
            self.pushed(AboutViewController.fromStoryboard())
            break
        default:
            break
        }
    }
}
