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
    
    @IBOutlet weak var bluetoothStateBtn: UIButton!
    
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
