//
//  DeviceListViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/24.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import KRProgressHUD

class DeviceListViewController: UIViewController {
    
    weak var delegate: DeviceListViewControllerDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    private var deviceArray: [DeviceType] = [.Wristband, .Watch]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "設備列表".localized())
        self.navigationItem.hidesBackButton = UserInfo.share.deviceType == .none
        self.myTableView.register(xib: DeviceCell.xib)
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
}
extension DeviceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DeviceCell.use(table: tableView, for: indexPath)
        cell.type = self.deviceArray[indexPath.row]
        return cell
    }
}
extension DeviceListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userInfo = UserInfo.share
        let ud = UserDefaults.standard
        
        if CositeaBlueTooth.instance.isConnected ||
            ud.object(forKey: GlobalProperty.kLastDeviceUUID) != nil {
            
            KRProgressHUD.showMessage("請先解除綁定".localized())
            
            return
        }
        
        
        
        
        
        
        let type = userInfo.deviceType
//        let type = ud.integer(forKey: GlobalProperty.AllDEVICETYPE)
        
        let cellType = (tableView.cellForRow(at: indexPath) as! DeviceCell).type
        
        
        var isChange: Bool {
            if type == cellType {
                return false
            } else {
                return true
            }
        }
        
//            userInfo.deviceChange = isChange
//            ud.set(true, forKey: GlobalProperty.AllDEVICETYPECHANGE)
        userInfo.deviceType = cellType
//            ud.set(cellType.typeNumber, forKey: GlobalProperty.AllDEVICETYPE)
        
        if type != .none {
            
            switch cellType {
                
            case .Wristband:
                
                ud.set("4294967295", forKey: GlobalProperty.SUPPORTPAGEMANAGER)
                
            case .Watch:
                
                ud.set("4294966304", forKey: GlobalProperty.SUPPORTPAGEMANAGER)
                
            case .none:
                break
            }
            
            self.navigationController?.popViewController()
            
            delegate?.deviceisChange(isChange)
            
        } else {
            
            userInfo.deviceType = cellType
            
            let vc = BTListViewController.fromStoryboard()
            self.push(vc: vc)
            
        }
        
//        delegate.deviceisChange(isChange)

//
//
//        if UserInfo.share.deviceType == .none || UserInfo.share.deviceToken.isEmpty || (tableView.cellForRow(at: indexPath) as! DeviceCell).type != UserInfo.share.deviceType {
//            UserInfo.share.deviceType = self.deviceArray[indexPath.row]
//            tableView.reloadData()
//            let vc = BTListViewController.fromStoryboard()
//            self.push(vc: vc)
//
//
//
//        } else {
//            UserInfo.share.deviceType = self.deviceArray[indexPath.row]
//            self.pop()
//        }
    }
}



protocol DeviceListViewControllerDelegate: NSObjectProtocol {
    func deviceisChange(_ change: Bool)
}
