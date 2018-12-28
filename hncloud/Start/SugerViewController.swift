//
//  SugerViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import Charts

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
    
    private var suger: SugerData = SugerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setChart()
        self.recordButton.addTarget(self, action: #selector(update), for: .touchUpInside)
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
        self.setData()
    }
    
    private func setData() {
        let data = BarChartData(dataSets: [self.suger.fpg, self.suger.pfg])
        data.barWidth = 0.2
        
        data.groupBars(fromX: 0.5, groupSpace: 0.6, barSpace: 0)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = false })
        chartView.data = data
        chartView.animate(yAxisDuration: 1.5)
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
