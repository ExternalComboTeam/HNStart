//
//  SportSelectedViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

protocol SportSelectedDelegate {
    func didSelected(_ type: SportType)
}

class SportSelectedViewController: UIViewController {

    @IBOutlet weak var sportTableView: UITableView!
    
    private lazy var enterButton: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.sportTableView.bounds.width, height: 55))
        let button = UIButton(frame: CGRect(x: 16, y: 5, width: self.sportTableView.bounds.width - 32, height: 50))
        button.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        button.setTitle("確定".localized(), for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
        view.addSubview(button)
        return view
    }()
    
    var delegate: SportSelectedDelegate?
    var sportType: SportType = .walk
    
    private var typeArray: [SportType] = [.walk, .run, .climb, .ball, .power, .aerobic, .custom]
    
    @objc private func selected() {
        self.delegate?.didSelected(self.sportType)
        self.pop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "選擇運動模式".localized())
        self.sportTableView.dataSource = self
        self.sportTableView.delegate = self
        self.sportTableView.tableFooterView = self.enterButton
    }

}
extension SportSelectedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportItemCell", for: indexPath) as! SportItemCell
        cell.typeImage.image = self.typeArray[indexPath.row].image
        cell.typeTitle.text = self.typeArray[indexPath.row].title
        cell.selectedCheck.isHidden = self.typeArray[indexPath.row] != self.sportType
        return cell
    }
}
extension SportSelectedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sportType = self.typeArray[indexPath.row]
        tableView.reloadData()
    }
}
