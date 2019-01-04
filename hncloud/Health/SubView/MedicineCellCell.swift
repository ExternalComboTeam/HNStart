//
//  MedicineCellCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/4.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class MedicineCellCell: UITableViewCell {

    @IBOutlet weak var chName: UILabel!
    @IBOutlet weak var enName: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
