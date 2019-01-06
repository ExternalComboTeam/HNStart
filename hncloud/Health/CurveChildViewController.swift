//
//  CurveChildViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/4.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import Charts
import SwifterSwift

class CurveChildViewController: UIViewController {

    var index: Int = 0
    @IBOutlet weak var chartBackView: UIView!
    @IBOutlet weak var stepsChartView: BarChartView!
    @IBOutlet weak var stepTitleView: UIView!
    @IBOutlet weak var sleepChartView: BarChartView!
    @IBOutlet weak var sleepTitleView: UIView!
    
    private var isLoad: Bool = false
    
    private lazy var monthDay: Double = {
        guard let day = Date().end(of: .month)?.string(withFormat: "dd") else { return 0 }
        let total = Double(day) ?? 0
        return total + 1
    }()
    private lazy var dayArray: [String] = {
        guard let start = Date().beginning(of: self.index == 0 ? .weekOfMonth : .month) else { return [] }
        let dayCount = self.index == 0 ? 7 : Int(self.monthDay) - 1
        return (0...dayCount).map({ start.adding(.day, value: $0).string(withFormat: "MM/dd") })
    }()
    
    private lazy var stepsView: StepsMarkerView = {
        guard let view = StepsMarkerView.xib() else { return StepsMarkerView() }
        view.unitLabel.text = "步".localized()
        view.isHidden = true
        return view
    }()
    private lazy var sleepView: SleepMarkerView = {
        guard let view = SleepMarkerView.xib() else { return SleepMarkerView() }
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setChart(self.stepsChartView)
        self.setChart(self.sleepChartView)
        self.stepsChartView.addSubview(self.stepsView)
        self.sleepChartView.addSubview(self.sleepView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.chartBackView.gradientColors = [#colorLiteral(red: 0.4179144204, green: 0.683541894, blue: 0.6642404795, alpha: 1), #colorLiteral(red: 0.734546721, green: 0.4212638736, blue: 0.7398764491, alpha: 1)]
        
        self.stepTitleView.addBoard(.bottom, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), thickness: 1)
        self.sleepTitleView.addBoard(.bottom, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), thickness: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setStepsData()
        self.setSleepData()
        
        guard !self.isLoad else { return }
        self.isLoad = true
        self.chartBackView.gradientColors = [#colorLiteral(red: 0.4179144204, green: 0.683541894, blue: 0.6642404795, alpha: 1), #colorLiteral(red: 0.734546721, green: 0.4212638736, blue: 0.7398764491, alpha: 1)]
    }
    
    private func setChart(_ chartView: BarChartView) {
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMinimum = 0
        leftAxis.enabled = false
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.axisMaximum = self.index == 0 ? 8 : self.monthDay
        xAxis.gridColor = .clear
        chartView.rightAxis.enabled = false
        
        // 隱藏文字
        chartView.legend.enabled = false
        // 縮放
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
        
        let marker = MarkerView()
        marker.chartView = chartView
        marker.tapBar { (point, entry) in
            if let values = entry.yValues {
                let gap = point.y - self.sleepView.height
                let y = gap < 0 ? (self.sleepView.height / 2) : point.y - (self.sleepView.height / 2)
                self.sleepView.setValue(point: CGPoint(x: point.x, y: y), values: values)
            } else {
                let gap = point.y - self.stepsView.height
                let y = gap < 0 ? (self.stepsView.height / 2) : point.y - (self.stepsView.height / 2)
                self.stepsView.setValue(point: CGPoint(x: point.x, y: y), steps: Int(entry.y))
            }
        }
        chartView.marker = marker
        
//        self.setData(chartView)
    }
    private func setData(_ chartView: BarChartView) {
        let count = self.index == 0 ? 8 : Int(self.monthDay)
        let yVals1 = (0..<count).map { (i) -> BarChartDataEntry in
            let val = Double(arc4random_uniform(140) + 60)
            return BarChartDataEntry(x: Double(i), y: i == 0 ? 0 : val)
        }
        let barSet = BarChartDataSet(values: yVals1, label: "")
        barSet.setColor(#colorLiteral(red: 0, green: 0, blue: 0.8981388211, alpha: 1))
        let data = BarChartData(dataSet: nil/*barSet*/)
        data.barWidth = 0.2
        
        data.groupBars(fromX: 0.5, groupSpace: 0.6, barSpace: 0)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = false })
        
        chartView.data = data
        chartView.animate(yAxisDuration: 1.5)
    }
    
    private func setSleepData() {
        let count = self.index == 0 ? 8 : Int(self.monthDay)
        let yVals1 = (0..<count).map { (i) -> BarChartDataEntry in
            let val = Double(arc4random_uniform(4000) + 60)
            let va2 = Double(arc4random_uniform(5000) + 60)
            let va3 = Double(arc4random_uniform(2000) + 60)
            return BarChartDataEntry(x: Double(i), yValues: i == 0 ? [0, 0, 0] : [val, va2, va3])
        }
        let barSet = BarChartDataSet(values: yVals1, label: "")
        barSet.colors = [#colorLiteral(red: 0, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.4980392157, blue: 1, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
        barSet.highlightAlpha = 0
        let data = BarChartData(dataSet: barSet)
        data.barWidth = 0.2
        
        data.groupBars(fromX: 0.5, groupSpace: 0.6, barSpace: 0)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = true })
        self.sleepChartView.data = data
        self.sleepChartView.animate(yAxisDuration: 1.5)
    }
    
    private func setStepsData() {
        let count = self.index == 0 ? 8 : Int(self.monthDay)
        let yVals1 = (0..<count).map { (i) -> BarChartDataEntry in
            let val = Double(arc4random_uniform(140) + 60)
            return BarChartDataEntry(x: Double(i), y: i == 0 ? 0 : val)
        }
        let barSet = BarChartDataSet(values: yVals1, label: "")
        barSet.setColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        barSet.highlightAlpha = 0
        let data = BarChartData(dataSet: barSet)
        data.barWidth = 0.2
        
        data.groupBars(fromX: 0.5, groupSpace: 0.6, barSpace: 0)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = true })
        
        self.stepsChartView.data = data
        self.stepsChartView.animate(yAxisDuration: 1.5)
    }
}
extension CurveChildViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let row = Int(value)
        guard row != 0 && row != self.dayArray.count else { return "" }
        return self.dayArray[row - 1]
    }
}
