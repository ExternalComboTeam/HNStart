//
//  MessageCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var isMessageAlarmOpen = false

    @IBOutlet weak var openSwitchOL: UISwitch!
    @IBOutlet weak var myStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myStackView.arrangedSubviews.forEach({ $0.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 0.5) })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func KRProgressHUDdismissselfmyTableViewreloadData(_ sender: UISwitch) {
        (self.parentViewController as? SettingViewController)?.isMessageAlarmOpen = sender.isOn
        CositeaBlueTooth.instance.setSystemAlarmWithType(.SMS, state: sender.isOn.int)
    }
    
    func set(isOn: Bool) {
        self.openSwitchOL.isOn = isOn
    }
    
}
