//
//  PrescriptionViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/8.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class PrescriptionViewController: UIViewController {

    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doctorTitleLabel: UILabel!
    @IBOutlet weak var doctorTimeLabel: UILabel!
    @IBOutlet weak var getTitleLabel: UILabel!
    @IBOutlet weak var getMedicineLabel: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var pre: Prescription?
    
    private func showAlert() {
        let chose = ["兩個月處方簽", "三個月處方簽"]
        ActionSheetStringPicker.init(title: "請選擇此為幾個月的處方簽".localized(), rows: chose, initialSelection: 0, doneBlock: { (picker, row, _) in
            
        }, cancel: { (picker) in
            
        }, origin: self.view)?.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "用藥管理".localized())
        self.nameTitleLabel.text = "姓名".localized()
        self.doctorTitleLabel.text = "門診時間".localized()
        self.getTitleLabel.text = "下次領藥日期".localized()
        
        self.nameLabel.text = self.pre?.name ?? ""
        self.doctorTimeLabel.text = self.pre?.doctorDate ?? ""
        self.getMedicineLabel.text = self.pre?.takeMedicine ?? ""
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            self.showAlert()
        }
    }
}
extension PrescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pre?.array.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath)
        guard let array = self.pre?.array else { return cell }
        cell.imageView?.image = UIImage(named: "")
        cell.textLabel?.text = array[indexPath.row].json["name_c"].stringValue
        return cell
    }
}
extension PrescriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let array = self.pre?.array else { return }
        let vc = ManagementViewController.fromStoryboard()
        vc.medicineValue = array[indexPath.row].json
        vc.usage = array[indexPath.row].frequency
        vc.doas = array[indexPath.row].dosage
        self.push(vc: vc)
    }
}
