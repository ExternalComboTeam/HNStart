//
//  SettingCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var caLabel: UILabel!
    @IBOutlet weak var slLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var boLabel: UILabel!
    @IBOutlet weak var meLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.text = "選擇開關設備功能".localized()
        self.sportLabel.text = "離線運動".localized()
        self.kmLabel.text = "里程".localized()
        self.caLabel.text = "卡路里".localized()
        self.slLabel.text = "睡眠".localized()
        self.setLabel.text = "設置".localized()
        self.boLabel.text = "血壓".localized()
        self.meLabel.text = "未讀消息".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
