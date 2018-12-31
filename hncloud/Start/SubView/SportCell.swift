//
//  SportCell.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class SportCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTimeLabel: UILabel!
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.calView.addBoard(.right, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), thickness: 0.5)
        self.calView.addBoard(.left, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), thickness: 0.5)
        self.backView.layer.cornerRadius = self.backView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
