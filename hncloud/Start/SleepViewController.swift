//
//  SleepViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import ZZCircleProgress

class SleepViewController: UIViewController {

    @IBOutlet weak var progressView: ZZCircleProgress!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var wellSleepLabel: UILabel!
    @IBOutlet weak var shallowLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var sleepStateLabel: UILabel!
    
    @IBAction func targetAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.progressView.startAngle = -90
        self.progressView.strokeWidth = 15
        self.progressView.pointImage.image = UIImage(named: "pointer_sleep")
        self.progressView.pathBackColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.progressView.pathFillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.progressView.showProgressText = false
        self.progressView.progress = 0.75
    }

}
