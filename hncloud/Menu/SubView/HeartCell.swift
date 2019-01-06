//
//  HeartCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class HeartCell: UITableViewCell {

    @IBOutlet weak var myStackView: UIStackView!
    @IBAction func monitor(_ sender: UISwitch) {
        self.myStackView.arrangedSubviews[1].isHidden = !sender.isOn
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
    }
    @IBAction func frequencyAction(_ sender: UIButton) {
        let choseArray: [String] = ["10分鐘".localized(), "30分鐘".localized(), "連續監測".localized()]
        let fre = self.frequencyLabel.text ?? ""
        let first = fre.components(separatedBy: "/").first ?? ""
        let selection = choseArray.firstIndex(of: first) ?? 0
        ActionSheetStringPicker.init(title: "", rows: choseArray, initialSelection: selection, doneBlock: { (picker, row, _) in
            self.frequencyLabel.text = row == 2 ? choseArray[2] : choseArray[row] + "/次".localized()
        }, cancel: { (picker) in
            
        }, origin: sender)?.show()
    }
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBAction func warningSwitch(_ sender: UISwitch) {
        self.myStackView.arrangedSubviews[3].isHidden = !sender.isOn
        self.myStackView.arrangedSubviews[4].isHidden = !sender.isOn
        self.myStackView.arrangedSubviews[5].isHidden = !sender.isOn
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
    }
    @IBAction func warningAction(_ sender: UIButton) {
        let vc = FrequencyViewController.fromStoryboard()
        vc.delegate = self
        self.parentViewController?.push(vc: vc)
    }
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myStackView.arrangedSubviews.forEach({ $0.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 0.5) })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension HeartCell: FrequencyDelegate {
    func finishEdit(up: String, lower: String) {
        self.upLabel.text = up
        self.lowerLabel.text = lower
    }
}
