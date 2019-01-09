//
//  SugerViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class SugerViewController: UIViewController {

    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var mFastingTextField: UITextField!
    @IBOutlet weak var mAfterTextField: UITextField!
    @IBOutlet weak var lFastingTextField: UITextField!
    @IBOutlet weak var lAfterTextField: UITextField!
    @IBOutlet weak var dFastingTextField: UITextField!
    @IBOutlet weak var dAfterTextField: UITextField!
    @IBOutlet weak var sBeforeTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var bluetoothStateBtn: UIButton!
    
    private var suger: SugerData = SugerData()
    private var observeDate: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setChart()
        self.getSugur()
        self.recordButton.addTarget(self, action: #selector(update), for: .touchUpInside)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connectedBand()
        self.observeDate = UserInfo.share.observe(\.selectedDate, changeHandler: { (user, date) in
            self.getSugur()
        })
    }
    
    private func getSugur() {
        HealthAPI.search(bloodsugar: UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"), { (json) in
            self.setValue(json["data"])
        }, error: { (error) in
            self.setValue(.null)
        })
    }
    
    private func setValue(_ json: JSON) {
        self.suger.mFasting = json["fpg_a"].stringValue
        self.suger.mAfer = json["ppg_a"].stringValue
        self.suger.lFasting = json["fpg_p"].stringValue
        self.suger.lAfer = json["ppg_p"].stringValue
        self.suger.dFasting = json["fpg_n"].stringValue
        self.suger.dAfer = json["ppg_n"].stringValue
        self.suger.sBefore = json["before_sleep"].stringValue
        
        self.mFastingTextField.text = self.suger.mFasting
        self.mAfterTextField.text = self.suger.mAfer
        self.lFastingTextField.text = self.suger.lFasting
        self.lAfterTextField.text = self.suger.lAfer
        self.dFastingTextField.text = self.suger.dFasting
        self.dAfterTextField.text = self.suger.dAfer
        self.sBeforeTextField.text = self.suger.sBefore
        
        self.setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.observeDate?.invalidate()
        self.observeDate = nil

    }
    @IBAction func bluetoothStateAction(_ sender: Any) {
        connectedBand()
    }
    
    @objc private func update() {
        self.suger.mFasting = self.mFastingTextField.text ?? ""
        self.suger.mAfer = self.mAfterTextField.text ?? ""
        self.suger.lFasting = self.lFastingTextField.text ?? ""
        self.suger.lAfer = self.lAfterTextField.text ?? ""
        self.suger.dFasting = self.dFastingTextField.text ?? ""
        self.suger.dAfer = self.dAfterTextField.text ?? ""
        self.suger.sBefore = self.sBeforeTextField.text ?? ""
        self.setData()
        HealthAPI.bloodsugar(date: UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd"), sugar: self.suger, nil)
    }

    private func setChart() {
        let lower = ChartLimitLine(limit: 80, label: "血糖過低".localized())
        lower.lineWidth = 1
        lower.labelPosition = .rightBottom
        lower.valueFont = .systemFont(ofSize: 10)
        
        let before = ChartLimitLine(limit: 130, label: "空腹血糖過高".localized())
        before.lineWidth = 1
        before.labelPosition = .rightTop
        before.valueFont = .systemFont(ofSize: 10)
        
        let after = ChartLimitLine(limit: 160, label: "飯後血糖過高".localized())
        after.lineWidth = 1
        after.labelPosition = .rightTop
        after.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelCount = 10
        leftAxis.addLimitLine(lower)
        leftAxis.addLimitLine(before)
        leftAxis.addLimitLine(after)
        leftAxis.axisMaximum = 180
        leftAxis.axisMinimum = 0
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        // 畫底下的線
        leftAxis.drawZeroLineEnabled = true
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.axisMaximum = 5
        xAxis.gridColor = .clear
        chartView.rightAxis.enabled = false
        
        // 隱藏文字
        chartView.legend.enabled = false
        // 縮放
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
    }
    
    private func setData() {
        let data = BarChartData(dataSets: [self.suger.fpg, self.suger.pfg])
        data.barWidth = 0.2
        
        data.groupBars(fromX: 0.5, groupSpace: 0.6, barSpace: 0)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = false })
        chartView.data = data
        chartView.animate(yAxisDuration: 1.5)
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
                self.bluetoothStateBtn.setTitle("連接中...".localized(), for: .normal)
                
                guard let uuid = UserDefaults.standard.string(forKey: GlobalProperty.kLastDeviceUUID) else {
                    
                    self.bluetoothStateBtn.isEnabled = true
                    self.bluetoothStateBtn.setTitle("未綁定".localized(), for: .normal)
                    return
                }
                
                CositeaBlueTooth.instance.connect(withUUID: uuid)
                
                CositeaBlueTooth.instance.connectedStateChanged(with: { (stateNum) in
                    if stateNum == 1 {
                        self.bluetoothStateBtn.setTitle("已連接".localized(), for: .normal)
                        self.perform(#selector(self.hideBluetoothStateBtn), with: nil, afterDelay: 1.0)
                    }
                })
            default:
                self.bluetoothStateBtn.isEnabled = true
                self.bluetoothStateBtn.setTitle("未綁定".localized(), for: .normal)
                
            }
        }
    }
    
    @objc func hideBluetoothStateBtn() {
        self.bluetoothStateBtn.isEnabled = false
        self.bluetoothStateBtn.isHidden = true
    }
}
extension SugerViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch value {
        case 1:
            return "早上".localized()
        case 2:
            return "中午".localized()
        case 3:
            return "晚上".localized()
        case 4:
            return "睡前".localized()
        default:
            return ""
        }
    }
}
