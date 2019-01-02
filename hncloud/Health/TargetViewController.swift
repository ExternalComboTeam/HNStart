//
//  TargetViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/3.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class TargetViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moveTitleLabel: UILabel!
    @IBOutlet weak var moveSlider: CustomSlider!
    @IBOutlet weak var sleepTitleLabel: UILabel!
    @IBOutlet weak var sleepSlider: CustomSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "設定目標".localized())
        
        self.titleLabel.text = "設定相應的目標，根據個人的資料！".localized()
        self.moveTitleLabel.text = "移動目標".localized()
        self.sleepTitleLabel.text = "睡眠目標".localized()
        
        
        self.moveSlider.setTitle(normal: ["2000", "4000", "6000", "8000", "10000", "12000", "14000", "16000", "18000", "20000"], selected: ["2000 偏少", "4000 偏少", "6000 正常", "8000 正常", "10000 活動", "12000 活動", "14000 達人", "16000 達人", "18000 達人", "20000 達人"])
        self.moveSlider.sliderTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.moveSlider.index = 4
        self.moveSlider.sliderImage = UIImage(named: "sport_button")
        
        
        self.sleepSlider.setTitle(normal: ["4h", "5h", "6h", "7h", "8h", "9h", "10h", "11h", "12h"], selected: ["4h 偏少", "5h 偏少", "6h 正常", "7h 正常", "8h 正常", "9h 充足", "10 充足", "11h 充足", "12h 充足"])
        self.sleepSlider.sliderTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.sleepSlider.index = 5
        self.sleepSlider.sliderImage = UIImage(named: "sleep_button")
        
    }
}
