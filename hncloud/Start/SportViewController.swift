//
//  SportViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import ZZCircleProgress
import ActionSheetPicker_3_0
import SwifterSwift

class SportViewController: UIViewController {
    @IBOutlet weak var progressView: ZZCircleProgress!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func timeButton(_ sender: UIButton) {
        let selectDate = Date(timeIntervalSinceNow: self.second)
        ActionSheetDatePicker.init(title: "",
                                   datePickerMode: .countDownTimer,
                                   selectedDate: selectDate,
                                   doneBlock: { (picker, date, origin) in
                                    guard let sec = date as? TimeInterval else { return }
                                    self.second = sec
                                    let min = Int(sec / 60)
                                    self.timeLabel.text = "\(min/60)h\(min%60)min"
        },
                                   cancel: { (picker) in
                                    
        },
                                   origin: sender).show()
    }
    
    private var second: TimeInterval = 1800
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setProgress()
    }

    private func setProgress() {
        
        self.progressView.startAngle = 135
        self.progressView.reduceAngle = 90
        self.progressView.strokeWidth = 15
        self.progressView.pointImage.image = UIImage(named: "pointer_active")
        self.progressView.pointImage.size = CGSize(width: 35, height: 35)
        self.progressView.pathBackColor = #colorLiteral(red: 0.05523516983, green: 0.1226971373, blue: 0.2389225662, alpha: 1)
        self.progressView.pathFillColor = #colorLiteral(red: 0.03700235445, green: 1, blue: 1, alpha: 1)
        self.progressView.showProgressText = false
        self.progressView.progress = 0.75
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
