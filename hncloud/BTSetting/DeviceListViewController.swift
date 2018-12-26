//
//  DeviceListViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/24.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class DeviceListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    private var deviceArray: [DeviceType] = [.Wristband, .Watch]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "設備列表")
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
        if UserInfo.share.deviceType == .none || UserInfo.share.deviceToken.isEmpty {
            UserInfo.share.deviceType = self.deviceArray[indexPath.row]
            tableView.reloadData()
            let vc = BTListViewController.fromStoryboard()
            self.push(vc: vc)
        } else {
            UserInfo.share.deviceType = self.deviceArray[indexPath.row]
            self.pop()
        }
    }
}
