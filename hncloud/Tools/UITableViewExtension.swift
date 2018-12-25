//
//  UITableViewExtension.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

extension UITableView {
    /// 註冊 Cell
    func register(xib name: String...) {
        name.forEach({ self.register($0) })
    }
    private func register(_ name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
}
extension UITableViewCell {
    /// Cell 的ID
    static var xib: String {
        return String(describing: self)
    }
    
    static func use(table view: UITableView, for index: IndexPath) -> Self {
        return cell(tableView: view, for: index)
    }
    private static func cell<T>(tableView: UITableView, for index: IndexPath) -> T {
        let id = String(describing: self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: index) as! T
        return cell
    }
}
