//
//  PhoneCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class PhoneCell: UITableViewCell {

    @IBOutlet weak var myStackView: UIStackView!
    @IBAction func phoneSwitch(_ sender: UISwitch) {
        self.myStackView.arrangedSubviews[1].isHidden = !sender.isOn
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
    }
    @IBOutlet weak var remindLabel: UILabel!
    @IBAction func remindAction(_ sender: UIButton) {
        let choseArray: [String] = ["無延遲".localized(), "4秒鐘".localized(), "10秒鐘".localized()]
        let re = self.remindLabel.text ?? ""
        let selection = choseArray.firstIndex(of: re) ?? 0
        ActionSheetStringPicker.init(title: "", rows: choseArray, initialSelection: selection, doneBlock: { (picker, row, _) in
            self.remindLabel.text = choseArray[row]
        }, cancel: { (picker) in
            
        }, origin: sender)?.show()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myStackView.arrangedSubviews.forEach({ $0.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 0.5) })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
