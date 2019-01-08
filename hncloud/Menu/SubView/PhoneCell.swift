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
    
    var isPhoneAlarmOpen = false
    let choseArray: [String] = ["無延遲".localized(), "4秒鐘".localized(), "10秒鐘".localized()]
    
    @IBOutlet weak var phoneSwitchOutlet: UISwitch!
    
    @IBOutlet weak var myStackView: UIStackView!
    @IBAction func phoneSwitch(_ sender: UISwitch) {
        
        self.isPhoneAlarmOpen = sender.isOn
        
        self.myStackView.arrangedSubviews[1].isHidden = !sender.isOn
        (self.parentViewController as? SettingViewController)?.myTableView.reloadData()
        
        CositeaBlueTooth.instance.setSystemAlarmWithType(.Phone, state: self.isPhoneAlarmOpen.int)
        
    }
    @IBOutlet weak var remindLabel: UILabel!
    @IBAction func remindAction(_ sender: UIButton) {
        let re = self.remindLabel.text ?? ""
        let selection = choseArray.firstIndex(of: re) ?? 0
        ActionSheetStringPicker.init(title: "", rows: choseArray, initialSelection: selection, doneBlock: { (picker, row, _) in
            self.remindLabel.text = self.choseArray[row]
        }, cancel: { (picker) in
            
        }, origin: sender)?.show()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myStackView.arrangedSubviews.forEach({ $0.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 0.5) })
        
        self.phoneSwitchOutlet.isOn = isPhoneAlarmOpen
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// Return choseArray index.
//    func checkPhoneAlarmDelay(_: (_ delay: Int) -> Void){
//        CositeaBlueTooth.instance.checkPhoneDealay { (delay) in
//            if delay == 255 || delay == 0 {
//                return 0
//            } else if delay > 2, delay < 8 {
//                return 1
//            } else {
//                return 2
//            }
//        }
//    }
}
