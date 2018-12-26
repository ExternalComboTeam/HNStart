//
//  BTListViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/27.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class BTListViewController: UIViewController {

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
        guard UserInfo.share.deviceToken.isEmpty else { return }
        self.navigationItem.rightBarButtonItems = [self.skipButton]
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
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath)
        cell.textLabel?.text = "XXXXXXX"
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
