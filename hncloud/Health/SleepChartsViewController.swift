//
//  SleepChartsViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/7.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import Charts

class SleepChartsViewController: UIViewController {

    lazy private var shareButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_share"), for: .normal)
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var curveButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_trend"), for: .normal)
        button.addTarget(self, action: #selector(curve), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var titleView: UITextField = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        leftImage.center = CGPoint(x: 15, y: 15)
        leftImage.image = UIImage(named: "provios")
        leftButton.addSubview(leftImage)
        leftButton.addTarget(self, action: #selector(lessDate), for: .touchUpInside)
        view.leftView = leftButton
        view.leftViewMode = .always
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        rightImage.center = CGPoint(x: 15, y: 15)
        rightImage.image = UIImage(named: "next")
        rightButton.addSubview(rightImage)
        rightButton.addTarget(self, action: #selector(addDate), for: .touchUpInside)
        view.rightView = rightButton
        view.rightViewMode = .always
        view.text = UserInfo.share.selectedDate.localDate()
        view.textAlignment = .center
        view.delegate = self
        return view
    }()
    @IBOutlet weak var sleepBackView: UIView!
    @IBOutlet weak var sleepChartView: BarChartView!
    @IBOutlet weak var heartChartView: LineChartView!
    
    @objc private func lessDate() {
        let less = UserInfo.share.selectedDate.adding(.day, value: -1)
        self.titleView.text = less.localDate()
        UserInfo.share.selectedDate = less
    }
    @objc private func addDate() {
        guard !UserInfo.share.selectedDate.isInToday else { return }
        let add = UserInfo.share.selectedDate.adding(.day, value: 1)
        self.titleView.text = add.localDate()
        UserInfo.share.selectedDate = add
    }
    // 分享
    @objc private func share(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        var shareItem: [Any] = []
        shareItem.append(window.asImage())
        let share = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        // 設定郵件的標題
        share.setValue(title, forKey: "subject")
        
        var shareType: [UIActivity.ActivityType] = [.addToReadingList, .airDrop, .assignToContact, .openInIBooks, .postToFlickr, .postToTencentWeibo, .postToVimeo, .print , .saveToCameraRoll]
        if #available(iOS 11.0, *) {
            shareType.append(.markupAsPDF)
        }
        
        share.popoverPresentationController?.sourceView = sender
        share.popoverPresentationController?.sourceRect = sender.bounds
        share.excludedActivityTypes = shareType
        share.completionWithItemsHandler = { (type, tage, array, error) in
            //
        }
        DispatchQueue.main.async {
            self.present(share, animated: true, completion: nil)
        }
    }
    // 曲線圖
    @objc private func curve() {
        let vc = CurveViewController.fromStoryboard()
        self.push(vc: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton(title: "")
        self.navigationItem.titleView = self.titleView
        self.navigationItem.rightBarButtonItems = [self.shareButton, self.curveButton]
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setHeartChart()
        self.setSleepChart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sleepBackView.gradientColors = [#colorLiteral(red: 0.6721533537, green: 0.7256482244, blue: 0.9206438065, alpha: 1), #colorLiteral(red: 0.6002121568, green: 0.9308297038, blue: 0.9118930697, alpha: 1)]
    }

    private func setSleepChart() {
        let leftAxis = sleepChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 3
        leftAxis.axisMinimum = 0
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        leftAxis.enabled = false
        
        let xAxis = sleepChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
        //xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.gridColor = .clear
        sleepChartView.rightAxis.enabled = false
        
        // 隱藏文字
        sleepChartView.legend.enabled = false
        // 縮放
        sleepChartView.scaleXEnabled = false
        sleepChartView.scaleYEnabled = false
        
        self.setSleepData()
    }
    
    private func setSleepData() {
        let yVals = (0..<30).map { (i) -> BarChartDataEntry in
            let val = Double(arc4random_uniform(4))
            return BarChartDataEntry(x: Double(i), y: val)
        }
        let barSet = BarChartDataSet(values: yVals, label: "")
        
        let colors = yVals.map { (entry) -> NSUIColor in
            switch entry.y {
            case 1:
                return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            case 2:
                return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            case 3:
                return #colorLiteral(red: 0, green: 0, blue: 0.8981388211, alpha: 1)
            default:
                return #colorLiteral(red: 0, green: 0, blue: 0.8981388211, alpha: 1)
            }
        }
        barSet.colors = colors
        barSet.valueColors = colors
        
        let data = BarChartData(dataSet: barSet)
        data.barWidth = 1
        
        data.groupBars(fromX: 0, groupSpace: 0, barSpace: 0)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = false })
        
        sleepChartView.data = data
    }
    
    private func setHeartChart() {
        let up = ChartLimitLine(limit: 220, label: "220")
        up.lineWidth = 1
        up.labelPosition = .leftBottom
        up.lineDashLengths = [5, 5]
        up.lineColor = .black
        up.valueFont = .systemFont(ofSize: 10)
        
        let middle = ChartLimitLine(limit: 160, label: "160")
        middle.lineWidth = 1
        middle.labelPosition = .leftTop
        middle.lineDashLengths = [5, 5]
        middle.lineColor = .black
        middle.valueFont = .systemFont(ofSize: 10)
        
        let lower = ChartLimitLine(limit: 40, label: "40")
        lower.lineWidth = 1
        lower.labelPosition = .leftTop
        lower.lineDashLengths = [5, 5]
        lower.lineColor = .black
        lower.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = heartChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelCount = 0
        leftAxis.addLimitLine(lower)
        leftAxis.addLimitLine(middle)
        leftAxis.addLimitLine(up)
        leftAxis.axisMaximum = 220
        leftAxis.axisMinimum = 0
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
//        leftAxis.enabled = false
        
        let xAxis = heartChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        //xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.axisMaximum = 5
        xAxis.gridColor = .clear
        xAxis.enabled = false
        heartChartView.rightAxis.enabled = false
        
        // 隱藏文字
        heartChartView.legend.enabled = false
        // 縮放
        heartChartView.scaleXEnabled = false
        heartChartView.scaleYEnabled = false
        
        self.setHeartData()
    }
    private func setHeartData() {
        let yVals1 = (0..<20).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(100))
            return ChartDataEntry(x: Double(i), y: i == 0 ? 0 : val)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "")
        set1.axisDependency = .left
        set1.setColor(.red)
        set1.lineWidth = 1
        set1.drawCirclesEnabled = false
        
        let data = LineChartData(dataSet: set1)
        data.dataSets.forEach({ $0.drawValuesEnabled = false; $0.highlightEnabled = false })
        heartChartView.data = data
    }
}
extension SleepChartsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.selectDate(date: UserInfo.share.selectedDate) { (date) in
            UserInfo.share.selectedDate = date
        }
        return false
    }
}
