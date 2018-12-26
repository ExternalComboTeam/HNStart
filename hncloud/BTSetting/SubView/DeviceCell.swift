//
//  DeviceCell.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceSelect: UIImageView!
    @IBOutlet weak var deviceName: UILabel!
    
    var type: DeviceType = .none {
        didSet {
            self.deviceName.text = self.type.rawValue
            self.deviceImage.image = self.type.image
            self.deviceSelect.isHidden = UserInfo.share.deviceType != self.type
        }
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
