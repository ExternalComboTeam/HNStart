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
    
    private lazy var move: [Int] = {
        return (1...10).map({ $0 * 2000 })
    }()
    private lazy var sleep: [Int] = {
        return (4...12).map({ $0 })
    }()
    
    private lazy var finishedButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "完成".localized(), style: .plain, target: self, action: #selector(finished))
    }()
    
    @objc private func finished() {
        UserInfo.share.walkTarget = self.move[self.moveSlider.index]
        UserInfo.share.sleepTarget = self.sleep[self.sleepSlider.index]
        self.pop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItems = [self.finishedButton]
        self.setBackButton(title: "設定目標".localized())
        
        self.titleLabel.text = "設定相應的目標，根據個人的資料！".localized()
        self.moveTitleLabel.text = "移動目標".localized()
        self.sleepTitleLabel.text = "睡眠目標".localized()
        
        self.moveSlider.setTitle(normal: move.map({"\($0)"}), selected: ["2000 偏少", "4000 偏少", "6000 正常", "8000 正常", "10000 活動", "12000 活動", "14000 達人", "16000 達人", "18000 達人", "20000 達人"])
        self.moveSlider.sliderTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.moveSlider.index = move.firstIndex(of: UserInfo.share.walkTarget) ?? 5
        self.moveSlider.sliderImage = UIImage(named: "sport_button")
        
        self.sleepSlider.setTitle(normal: sleep.map({"\($0)h"}), selected: ["4h 偏少", "5h 偏少", "6h 正常", "7h 正常", "8h 正常", "9h 充足", "10 充足", "11h 充足", "12h 充足"])
        self.sleepSlider.sliderTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.sleepSlider.index = sleep.firstIndex(of: UserInfo.share.sleepTarget) ?? 4
        self.sleepSlider.sliderImage = UIImage(named: "sleep_button")
        
    }
}
