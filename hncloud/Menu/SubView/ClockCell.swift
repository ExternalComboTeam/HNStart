//
//  ClockCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/7.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class ClockCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var clockAlarmExitArray: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
