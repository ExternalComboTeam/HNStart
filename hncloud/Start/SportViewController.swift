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
    
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sportTableView: UITableView!
    

    @IBOutlet weak var bluetoothStateBtn: UIButton!

    private var sportType: SportType = .walk

    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.5
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 0.06107305735, green: 0.07715373486, blue: 0.2354443967, alpha: 1), pathFill: #colorLiteral(red: 0, green: 0.9932600856, blue: 0.7853906751, alpha: 1), startAngle: 135, strokeWidth: 15)
        view?.pointImage.image = UIImage(named: "pointer_active")
        view?.pointImage.size = CGSize(width: 35, height: 35)
        view?.showProgressText = false
        view?.reduceAngle = 90
        view?.showPoint = false
        view?.increaseFromLast = true
        view?.duration = 0
        return view
    }()
    
    @IBAction func statusAction(_ sender: UIButton) {
        let vc = SportSelectedViewController.fromStoryboard()
        vc.sportType = self.sportType
        vc.delegate = self
        self.push(vc: vc)
    }
    @IBAction func stopAction(_ sender: Any) {
        let alert = UIAlertController(title: "是否保存運動".localized(), message: nil, preferredStyle: .alert)
        alert.addAction(title: "確定".localized(), style: .default, isEnabled: true) { (sender) in
            self.isStart = false
            self.progressView?.progress = 0
            // 保存運動
            
            let vc = SportRecordViewController.fromStoryboard()
            self.push(vc: vc)
        }
        alert.addAction(title: "取消".localized(), style: .cancel, isEnabled: true) { (sender) in
            self.isStart = false
            self.progressView?.progress = 0
        }
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func timeButton(_ sender: UIButton) {
        let picker = ActionSheetDatePicker(title: "", datePickerMode: .countDownTimer, selectedDate: Date(), doneBlock: { (picker, date, origin) in
            guard let sec = date as? TimeInterval else { return }
            self.second = sec
        }, cancel: { (picker) in
            
        }, origin: sender)
        picker?.countDownDuration = self.second
        picker?.show()
    }
    private var isStart: Bool = false {
        didSet {
            self.statusStackView.arrangedSubviews[0].isHidden = self.isStart
            self.statusStackView.arrangedSubviews[1].isHidden = !self.isStart
            self.progressView?.showPoint = self.isStart
            self.progressView?.prepareToShow = true
        }
    }
    private var second: TimeInterval = 1800 {
        didSet {
            let min = Int(second / 60)
            self.timeLabel.text = (min / 60) == 0 ? "\(min%60)min" : "\(min/60)h\(min%60)min"
        }
    }
    private var timing: TimeInterval = 0 {
        didSet {
            guard self.timing >= 0 && self.isStart else { return }
            let value = Int(self.timing)
            let sce = value % 60
            let min = value / 60
            let hour = min / 60
            self.timingLabel.text = "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(min < 10 ? "0\(min)" : "\(min)"):\(sce < 10 ? "0\(sce)" : "\(sce)")"
            self.progressView?.progress = CGFloat(self.timing / self.second)
        }
    }
    

    @IBAction func bluetoothStateAction(_ sender: Any) {
        connectedBand()
    }
    
    func connectedBand() {
        
        bluetoothStateBtn.isEnabled = false
        
        if CositeaBlueTooth.instance.isConnected {
            print("CositeaBlueTooth.instance.isConnected = \(CositeaBlueTooth.instance.isConnected)")
            hideBluetoothStateBtn()
            return
        } else {
            self.bluetoothStateBtn.isHidden = false
        }
        
        CositeaBlueTooth.instance.checkCBCentralManagerState { (state) in
            
            switch state {
                
            case .poweredOn:
                self.bluetoothStateBtn.setTitle("連接中...", for: .normal)
                
                guard let uuid = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceUUID) else {
                    
                    self.bluetoothStateBtn.isEnabled = true
                    self.bluetoothStateBtn.setTitle("未綁定", for: .normal)
                    return
                }
                
                CositeaBlueTooth.instance.connect(withUUID: uuid)
                
                CositeaBlueTooth.instance.connectedStateChanged(with: { (stateNum) in
                    if stateNum == 1 {
                        self.bluetoothStateBtn.setTitle("已連接", for: .normal)
                        self.perform(#selector(self.hideBluetoothStateBtn), with: nil, afterDelay: 1.0)
                    }
                })
            default:
                self.bluetoothStateBtn.isEnabled = true
                self.bluetoothStateBtn.setTitle("未綁定", for: .normal)
                
            }
        }
    }
    
    @objc func hideBluetoothStateBtn() {
        self.bluetoothStateBtn.isEnabled = false
        self.bluetoothStateBtn.isHidden = true
    }

    private func runTiming() {
        guard self.isStart else { return }
        self.timing = self.timing + 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.runTiming()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isStart = false
        self.second = 1800
        self.sportTableView.dataSource = self
        self.sportTableView.delegate = self
        guard let progressView = self.progressView else { return }
        self.progressContainer.addSubview(progressView)
        progressView.progress = 0
        progressView.prepareToShow = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        connectedBand()
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
extension SportViewController: SportSelectedDelegate {
    func didSelected(_ type: SportType) {
        self.timing = -1
        self.isStart = true
        self.sportType = type
        self.runTiming()
    }
}
