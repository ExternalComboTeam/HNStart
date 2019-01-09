//
//  SetRemindCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class SetRemindCell: UITableViewCell {
    
    
    var exitArray: [String] = []
    

    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func clickAction(_ sender: UIButton) {
        switch self.type {
        case .clock:
            let vc = ClockViewController.fromStoryboard()
            self.parentViewController?.push(vc: vc)
            break
        case .sit:
            let vc = SedentaryViewController.fromStoryboard()
            vc.exitArray = self.exitArray
            self.parentViewController?.push(vc: vc)
            break
        default:
            break
        }
    }
    
    var type: SettingType = .clock {
        didSet {
            self.titleLabel.text = self.type == .clock ? "鬧鈴" : "久坐提醒".localized()
            self.myStackView.arrangedSubviews[1].isHidden = self.type == .clock
        }
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
