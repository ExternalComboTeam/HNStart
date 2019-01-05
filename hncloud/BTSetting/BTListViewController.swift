//
//  BTListViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import CoreBluetooth
import KRProgressHUD

class BTListViewController: UIViewController {
    
    var deviceArray: [PerModel]?
    

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func buttonAction(_ sender: UIButton) {
        if self.activityIndicator.isAnimating {
            self.stopSearch()
        } else {
            self.startSearch()
            self.TestAnimation()
        }
    }
    
    private lazy var skipButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "略過".localized(), style: .plain, target: self, action: #selector(skipSearch))
    }()
    
    @objc private func skipSearch() {
        UserInfo.share.deviceToken = "未綁定".localized()
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "連接設備".localized())
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.startSearch()
//        guard UserInfo.share.deviceToken.isEmpty else { return }
        self.navigationItem.rightBarButtonItems = [self.skipButton]
        
        // Check bluetooth
        if HCHCommonManager.instance.blueToothState != .poweredOn {
            
            KRProgressHUD.showMessage("請打開藍牙".localized())
            
            return
        }
        
        CositeaBlueTooth.instance.scanDevices { [weak self] (array) in
            
            for i in 0..<array!.count {
                let item = (array as! [PerModel])[i]
            }
            

            guard let array = array as? [PerModel] else { return }
            
            let devices = array
            
            switch UserInfo.share.deviceType {
            case .Wristband:
                self?.deviceArray = ToolBox.checkBracelet(devices)
            case .Watch:
                self?.deviceArray = ToolBox.checkWatch(devices)
            case .none:
                break
            }
            
            self?.myTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    private func stopSearch() {
        self.activityIndicator.stopAnimating()
        self.loadingView.isHidden = true
        self.actionButton.setTitle("綁定設備".localized(), for: .normal)
    }
    private func startSearch() {
        self.loadingView.isHidden = false
        self.activityIndicator.startAnimating()
        self.actionButton.setTitle("取消搜尋".localized(), for: .normal)
    }
    
    @objc private func connectSuccessTimeOut() {
        KRProgressHUD.showSuccess(withMessage: "連接成功".localized())
        KRProgressHUD.set(duration: 0.75)
        if self.parent?.parent is RSideViewController {
            self.pop()
        } else {
            let left = MenuViewController.fromStoryboard()
            let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigation")
            let vc = RSideViewController(leftViewController: left, mainViewController: main)
            self.present(vc, animated: false, completion: nil)
        }
        
        
    }
    
    private func TestAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.stopSearch()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.TestAnimation()
    }
}
extension BTListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath)
        
        if let deviceArray = deviceArray {
            cell.textLabel?.text = deviceArray[indexPath.row].peripheral.name ?? "未知裝置"
            
        } else {
            cell.textLabel?.text = "找不到裝置"
        }
        
        return cell
    }
}
extension BTListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let model = self.deviceArray?.item(at: indexPath.row) else {
            return
        }
        
        let llString = model.peripheral.identifier.uuidString
        
        if let macAddress = model.macAddress {
            
            UserDefaults.standard.set(macAddress, forKey: GlobalProperty.kLastDeviceMACADDRESS)
            
        } else {
            
            if ToolBox.setMacaddress(llString) {
                #if DEBUG
                print("\(#function)\nsetMacaddress success.")
                #endif
            } else {
                #if DEBUG
                print("\(#function)\nsetMacaddress fail.")
                #endif
            }
        }
        
        if let name = model.peripheral.name {
            UserDefaults.standard.set(model.type, forKey: name)
        }

        KRProgressHUD.set(duration: 5)
        KRProgressHUD.show(withMessage: "正在連接...", completion: nil)
        
        
        CositeaBlueTooth.instance.connect(withUUID: llString)
        if ToolBox.savePeripheral(model) {
            
            print("""
                🍾🍾
                deviceID = \(model.deviceID ?? "no id")
                deviceName = \(model.deviceName ?? "no name")
                macAddress = \(model.macAddress ?? "no macAddr")
                peripheral = \(model.peripheral)
                """)
            
            let userInfo = UserInfo.share
            
            userInfo.deviceToken = model.deviceName ?? "未知裝置"
            
            perform(#selector(self.connectSuccessTimeOut), with: nil, afterDelay: 5.0)
            
        } else {
            KRProgressHUD.showError(withMessage: "錯誤")
        }
        
//
//
//
//        if UserInfo.share.deviceToken.isEmpty {
//            UserInfo.share.deviceToken = "77乳加巧克力"
//            self.dismiss(animated: false, completion: nil)
//        } else {
//            UserInfo.share.deviceToken = "77乳加巧克力"
//            self.pop()
//        }
    }
}




