//
//  HeartViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import Charts

class HeartViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var sysTitleLabel: UILabel!
    @IBOutlet weak var diaTitleLabel: UILabel!
    @IBOutlet weak var ratTitleLabel: UILabel!
    @IBOutlet weak var sysLabel: UILabel!
    @IBOutlet weak var diaLabel: UILabel!
    @IBOutlet weak var ratLabel: UILabel!
    @IBOutlet weak var spoLabel: UILabel!
    
    @IBAction func curveAction(_ sender: Any) {
        let vc = HeartCurveViewController.fromStoryboard()
        self.push(vc: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sysTitleLabel.text = "收縮壓".localized()
        self.diaTitleLabel.text = "舒張壓".localized()
        self.ratTitleLabel.text = "心律".localized()
        
        self.setSPO(value: 0)
        
        self.setChart()
        self.setData()
    }

    
    private func setChart() {
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelCount = 8
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 60
        leftAxis.gridLineDashLengths = [2, 2]
        chartView.rightAxis.enabled = false
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.gridColor = .clear
        xAxis.drawAxisLineEnabled = false
        xAxis.enabled = false
        // 隱藏文字
        chartView.legend.enabled = false
        // 縮放
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
    }
    
    private func setData() {
        let yVals1 = (0..<20).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(140) + 60)
            return ChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "sport_button")?.scaled(toWidth: 10))
        }
        let yVals2 = (0..<20).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: 0)
        }
        
        let yVals3 = (0..<20).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(60))
            return ChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "sport_button")?.scaled(toWidth: 10))
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "收縮壓")
        set1.axisDependency = .left
        set1.setColor(.clear)
        set1.drawCircleHoleEnabled = false
        let gradientColors = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor, #colorLiteral(red: 0.05903590565, green: 0, blue: 0.9331281676, alpha: 1).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        
        set1.drawFilledEnabled = true
        set1.drawIconsEnabled = true
        
        let set2 = LineChartDataSet(values: yVals2, label: "")
        set2.axisDependency = .left
        set2.setColor(.clear)
        set2.setCircleColor(.clear)
        set2.drawCircleHoleEnabled = false
        
        let set3 = LineChartDataSet(values: yVals3, label: "舒張壓")
        set3.axisDependency = .right
        set3.setColor(.clear)
        set3.drawCircleHoleEnabled = false
        let gradientColors3 = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor, #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor]
        let gradient3 = CGGradient(colorsSpace: nil, colors: gradientColors3 as CFArray, locations: nil)!
        
        set3.fillAlpha = 1
        set3.fill = Fill(linearGradient: gradient3, angle: 90)
        set3.drawFilledEnabled = true
        set3.drawIconsEnabled = true
        
        
        
        let data = LineChartData(dataSets: [set1, set2, set3])
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = false })
        chartView.data = data
    }
    
    private func setSPO(value: Int) {
        let u = NSMutableAttributedString(string: "SPO2%",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 12),
                         .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        let v = NSMutableAttributedString(string: "\(value)",
                                          attributes: [.font: UIFont.systemFont(ofSize: 17),
                                                       .foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        self.spoLabel.attributedText = u + " " + v
    }
}
