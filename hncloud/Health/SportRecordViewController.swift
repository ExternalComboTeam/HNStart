//
//  SportRecordViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/31.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import ZZCircleProgress
import SwifterSwift

class SportRecordViewController: UIViewController {

    @IBOutlet weak var progressContainView: UIView!
    @IBOutlet weak var avgRateTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var heatTitleLabel: UILabel!
    @IBOutlet weak var heatLabel: UILabel!
    @IBOutlet weak var powerTitleLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var sportTimeLabel: UILabel!
    
    @IBOutlet weak var rate_1: UILabel!
    @IBOutlet weak var rate_2: UILabel!
    @IBOutlet weak var rate_3: UILabel!
    @IBOutlet weak var rate_4: UILabel!
    @IBOutlet weak var rate_5: UILabel!
    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.5
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 0.06107305735, green: 0.07715373486, blue: 0.2354443967, alpha: 1), pathFill: #colorLiteral(red: 0, green: 0.9932600856, blue: 0.7853906751, alpha: 1), startAngle: -90, strokeWidth: 15)
        view?.showPoint = false
        view?.showProgressText = false
        return view
    }()
    
    private func setRate() {
        guard let birthday = UserInfo.share.birthday.date?.year else { return }
        let current = Date().year
        let age = current - birthday
        let max = 220 - age
        let rate1 = Int(Double(max) * 0.6)
        let rate2 = Int(Double(max) * 0.7)
        let rate3 = Int(Double(max) * 0.8)
        let rate4 = Int(Double(max) * 0.9)
        self.rate_1.text = "≤ \(rate1)"
        self.rate_2.text = "\(rate1) - \(rate2)"
        self.rate_3.text = "\(rate2) - \(rate3)"
        self.rate_4.text = "\(rate3) - \(rate4)"
        self.rate_5.text = "≥ \(rate4)"
    }
    
    private func setAvgRate(value: Int) {
        let h = NSMutableAttributedString(string: "\(value)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                         .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let u = NSMutableAttributedString(string: "次/分鐘".localized(),
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        self.rateLabel.attributedText = h + " " + u
    }
    
    private func setHeat(value: Int) {
        let h = NSMutableAttributedString(string: "\(value)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                         .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let u = NSMutableAttributedString(string: "千卡".localized(),
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        self.heatLabel.attributedText = h + " " + u
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "")
        self.setRate()
        
        self.avgRateTitleLabel.text = "平均心律".localized()
        self.heatTitleLabel.text = "熱量".localized()
        self.sportTimeLabel.text = "運動強度".localized()
        
        self.setAvgRate(value: 0)
        self.setHeat(value: 0)
        
        guard let progressView = self.progressView else { return }
        self.progressContainView.addSubview(progressView)
        progressView.prepareToShow = true
    }

}
