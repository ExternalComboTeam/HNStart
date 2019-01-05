//
//  ShowCell.swift
//  hncloud
//
//  Created by 辰 on 2019/1/3.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class ShowCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
