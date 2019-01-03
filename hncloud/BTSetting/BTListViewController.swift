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
                print("🍚 model\(i)\nname = \(item.deviceName)\ndeviceID = \(item.deviceID)\nmacAddress = \(item.macAddress)\nperipheral = \(item.peripheral)")
            }
            
//            print("🍚 array = \(array)")
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
        print("🍕 deviceArray = \(deviceArray)")
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
        if UserInfo.share.deviceToken.isEmpty {
            UserInfo.share.deviceToken = "77乳加巧克力"
            self.dismiss(animated: false, completion: nil)
        } else {
            UserInfo.share.deviceToken = "77乳加巧克力"
            self.pop()
        }
    }
}
