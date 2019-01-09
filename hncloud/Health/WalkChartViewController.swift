//
//  WalkChartViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/8.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import Charts

class WalkChartViewController: UIViewController {

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
    
    private lazy var stepsView: StepsMarkerView = {
        guard let view = StepsMarkerView.xib() else { return StepsMarkerView() }
        view.unitLabel.text = "步".localized()
        view.isHidden = true
        return view
    }()
    
    @IBOutlet weak var setpSegment: UISegmentedControl!
    
    @IBOutlet weak var stepBackView: UIView!
    @IBOutlet weak var stepTopView: UIView!
    @IBOutlet weak var stepChartView: BarChartView!
    @IBOutlet weak var walkTimeLabel: UILabel!
    @IBOutlet weak var walkCalLabel: UILabel!
    @IBOutlet weak var sitTimeLabel: UILabel!
    @IBOutlet weak var sitCalLabel: UILabel!
    
    @IBOutlet weak var heartSegment: UISegmentedControl!
    @IBOutlet weak var maxHRLabel: UILabel!
    @IBOutlet weak var avgHeartLabel: UILabel!
    @IBOutlet weak var hrvChartView: LineChartView!
    @IBOutlet weak var heartChartView: LineChartView!
    @IBAction func stepAction(_ sender: UISegmentedControl) {
        self.stepBackView.gradientColors = sender.selectedSegmentIndex == 0 ? [#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)] : [#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        self.stepsView.isHidden = true
        self.stepsView.unitLabel.text = sender.selectedSegmentIndex == 0 ? "步".localized() : "cal"
        self.setStepChart()
    }
    @IBAction func heartAction(_ sender: UISegmentedControl) {
        self.changeChartView(sender.selectedSegmentIndex == 0)
    }
    
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
    
    private func changeChartView(_ isHeart: Bool) {
        self.heartChartView.isHidden = !isHeart
        self.hrvChartView.isHidden = isHeart
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stepBackView.gradientColors = [#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]
        self.stepChartView.addSubview(self.stepsView)
        self.setBackButton(title: "")
        self.navigationItem.titleView = self.titleView
        self.navigationItem.rightBarButtonItems = [self.shareButton, self.curveButton]
        self.changeChartView(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.stepBackView.gradientColors = [#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]
        self.setStepChart()
        self.setHRVChart()
        self.setHeartChart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.stepTopView.addBoard(.bottom, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), thickness: 1)
    }

    private func setStepChart() {
        let leftAxis = stepChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMinimum = 0
        leftAxis.enabled = false
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        
        let xAxis = stepChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
//        xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.gridColor = .clear
        stepChartView.rightAxis.enabled = false
        
        // 隱藏文字
        stepChartView.legend.enabled = false
        // 縮放
        stepChartView.scaleXEnabled = true
        stepChartView.scaleYEnabled = false
        
        let marker = MarkerView()
        marker.chartView = stepChartView
        marker.tapBar { (point, entry) in
            let gap = point.y - self.stepsView.height
            let y = gap < 0 ? (self.stepsView.height / 2) : point.y - (self.stepsView.height / 2)
            self.stepsView.setValue(point: CGPoint(x: point.x, y: y), steps: Int(entry.y))
        }
        stepChartView.marker = marker
        self.setData(stepChartView)
    }
    
    private func setData(_ chartView: BarChartView) {
        let count = 30
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
        
        chartView.data = data
        chartView.animate(yAxisDuration: 1.5)
    }
    
    private func setHRVChart() {
        let up = ChartLimitLine(limit: 20, label: "高危".localized())
        up.lineWidth = 1
        up.labelPosition = .rightBottom
        up.lineDashLengths = [5, 5]
        up.lineColor = .red
        up.valueFont = .systemFont(ofSize: 10)
        
        let middle = ChartLimitLine(limit: 20, label: "危險".localized())
        middle.lineWidth = 1
        middle.labelPosition = .rightTop
        middle.lineDashLengths = [5, 5]
        middle.lineColor = .red
        middle.valueFont = .systemFont(ofSize: 10)
        
        let noraml = ChartLimitLine(limit: 35, label: "正常".localized())
        noraml.lineWidth = 1
        noraml.labelPosition = .leftTop
        noraml.lineDashLengths = [5, 5]
        noraml.lineColor = .blue
        noraml.valueFont = .systemFont(ofSize: 10)
        
        let safe = ChartLimitLine(limit: 45, label: "健康".localized())
        safe.lineWidth = 1
        safe.labelPosition = .leftTop
        safe.lineDashLengths = [5, 5]
        safe.lineColor = .green
        safe.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = hrvChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelCount = 10
        leftAxis.addLimitLine(safe)
        leftAxis.addLimitLine(noraml)
        leftAxis.addLimitLine(middle)
        leftAxis.addLimitLine(up)
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        
        let xAxis = hrvChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        //xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.gridColor = .clear
        hrvChartView.rightAxis.enabled = false
        
        // 隱藏文字
        hrvChartView.legend.enabled = false
        // 縮放
        hrvChartView.scaleXEnabled = false
        hrvChartView.scaleYEnabled = false
        
        self.setHRVData()
    }
    
    private func setHRVData() {
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
        hrvChartView.data = data
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
        //leftAxis.enabled = false
        
        let xAxis = heartChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        //xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.axisMaximum = 5
        xAxis.gridColor = .clear
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
extension WalkChartViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.selectDate(date: UserInfo.share.selectedDate) { (date) in
            UserInfo.share.selectedDate = date
        }
        return false
    }
}
