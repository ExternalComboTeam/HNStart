//
//  WalkViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import ZZCircleProgress

class WalkViewController: UIViewController {

    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var progressContentView: UIView!
    @IBOutlet weak var setpsLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.55
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 0.06107305735, green: 0.07715373486, blue: 0.2354443967, alpha: 1), pathFill: #colorLiteral(red: 0, green: 0.9932600856, blue: 0.7853906751, alpha: 1), startAngle: -90, strokeWidth: 15)
        view?.pointImage.image = UIImage(named: "pointer_active")
        view?.pointImage.size = CGSize(width: 35, height: 35)
        view?.showProgressText = false
        return view
    }()
    
    @IBAction func targetAction(_ sender: UIButton) {
        // 目標記錄
        let vc = TargetViewController.fromStoryboard()
        self.push(vc: vc)
    }
    @IBAction func walkRecord(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setHeart(value: 0)
        self.setCal(value: 0)
        self.setDistance(value: "0")
        self.setTime(hour: 0, min: 0)
        
        guard let progressView = self.progressView else { return }
        self.progressContainer.addSubview(progressView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.progressContentView.layer.cornerRadius = self.progressContentView.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.targetLabel.text = "\(UserInfo.share.walkTarget)"
        self.progressView?.progress = 0.75
    }

    /// 設定心律
    private func setHeart(value: Int) {
        let h = NSMutableAttributedString(string: value == 0 ? "--" : "\(value)",
                                          attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let u = NSMutableAttributedString(string: "bpm",
            attributes: [.font: UIFont.systemFont(ofSize: 13),
                         .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        self.heartLabel.attributedText = h + " " + u
    }
    // 設定卡路里
    private func setCal(value: Int) {
        let c = NSMutableAttributedString(string: "\(value)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                         .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let u = NSMutableAttributedString(string: "kcal",
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        self.calLabel.attributedText = c + " " + u
    }
    // 設定路程
    private func setDistance(value: String) {
        let d = NSMutableAttributedString(string: value,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                         .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let u = NSMutableAttributedString(string: "km",
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        self.distanceLabel.attributedText = d + " " + u
    }
    // 設定時間
    private func setTime(hour: Int, min: Int) {
        let h = NSMutableAttributedString(string: "\(hour)",
                                          attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let uh = NSMutableAttributedString(string: "h",
                                          attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                       .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let m = NSMutableAttributedString(string: "\(min)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 20),
                         .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        let um = NSMutableAttributedString(string: "min",
                                           attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                        .foregroundColor: #colorLiteral(red: 0.1784672141, green: 0.2162371576, blue: 0.3614119291, alpha: 1)])
        self.timeLabel.attributedText = h + " " + uh + " " + m + " " + um
    }
}
