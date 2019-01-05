//
//  SwitchCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/3.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchBar: UISwitch!
    @IBAction func switchAction(_ sender: UISwitch) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
