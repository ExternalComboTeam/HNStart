//
//  ClockTimeSetViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol ClockTimeSetDelegate {
    func time(_ array: [String])
}

class ClockTimeSetViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    private lazy var addButton: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 50))
        let button = UIButton(frame: CGRect(x: 16, y: 5, width: UIScreen.main.bounds.width - 32, height: 45))
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        button.setTitle("添加時間".localized(), for: .normal)
        button.addTarget(self, action: #selector(addTime(_:)), for: .touchUpInside)
        view.addSubview(button)
        return view
    }()
    
    @objc private func addTime(_ sender: UIButton) {
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .time, selectedDate: Date(), doneBlock: { (picker, date, orgin) in
            guard let time = date as? Date else { return }
            self.timeArray.append(time.string(withFormat: "HH:mm"))
            self.delegate?.time(self.timeArray)
            self.myTableView.reloadData()
        }, cancel: { (picker) in
            
        }, origin: sender)
    }
    
    var timeArray: [String] = []
    var delegate: ClockTimeSetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "自訂設置".localized())
        self.myTableView.tableFooterView = self.addButton
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }

}
extension ClockTimeSetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeCell
        cell.timeLabel.text = self.timeArray[indexPath.row]
        return cell
    }
}
extension ClockTimeSetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = self.timeArray[indexPath.row]
        let date = time.date(withFormat: "HH:mm") ?? Date()
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .time, selectedDate: date, doneBlock: { (picker, date, orgin) in
            guard let time = date as? Date else { return }
            self.timeArray[indexPath.row] = time.string(withFormat: "HH:mm")
            self.delegate?.time(self.timeArray)
            self.myTableView.reloadData()
        }, cancel: { (picker) in
            
        }, origin: tableView)
    }
}
