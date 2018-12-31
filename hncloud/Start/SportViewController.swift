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
    @IBOutlet weak var progressContainer: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sportTableView: UITableView!
    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.5
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 0.06107305735, green: 0.07715373486, blue: 0.2354443967, alpha: 1), pathFill: #colorLiteral(red: 0, green: 0.9932600856, blue: 0.7853906751, alpha: 1), startAngle: 135, strokeWidth: 15)
        view?.pointImage.image = UIImage(named: "pointer_active")
        view?.pointImage.size = CGSize(width: 35, height: 35)
        view?.showProgressText = false
        view?.reduceAngle = 90
        return view
    }()
    
    @IBAction func statusAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.statusLabel.text = sender.isSelected ? "Pause" : "Start"
    }
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

        self.sportTableView.dataSource = self
        self.sportTableView.delegate = self
//        movement_restart_icon
//        pause_movement_icon
        guard let progressView = self.progressView else { return }
        self.progressContainer.addSubview(progressView)
        progressView.prepareToShow = true
        progressView.progress = 0.75
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
extension SportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportCell
        
        return cell
    }
}
extension SportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SportRecordViewController.fromStoryboard()
        self.push(vc: vc)
    }
}
