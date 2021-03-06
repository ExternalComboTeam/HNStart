//
//  SleepViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import ZZCircleProgress

class SleepViewController: UIViewController {

    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var wellSleepLabel: UILabel!
    @IBOutlet weak var shallowLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var sleepStateLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.55
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), pathFill: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), startAngle: -90, strokeWidth: 15)
        view?.pointImage.image = UIImage(named: "pointer_sleep")
        view?.showProgressText = false
        return view
    }()
    
    @IBAction func targetAction(_ sender: UIButton) {
    }
    @IBAction func curve(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTime(0, min: 50)
        
        guard let progressView = self.progressView else { return }
        self.progressContainer.addSubview(progressView)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progressView?.progress = 0.75
    }
    
    /// 設定時間
    private func setTime(_ hour: Int, min: Int) {
        let h = NSMutableAttributedString(string: "\(hour)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 28),
                         .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        let sh = NSMutableAttributedString(string: "h",
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        let m = NSMutableAttributedString(string: "\(min)",
                                          attributes: [.font: UIFont.boldSystemFont(ofSize: 28),
                                                       .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        let sm = NSMutableAttributedString(string: "min",
                                           attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                        .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        self.sleepTimeLabel.attributedText = h + sh + m + sm
    }
}
