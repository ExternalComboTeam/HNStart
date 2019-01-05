//
//  HeartCurveViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import Charts
import Localize_Swift
import ActionSheetPicker_3_0

class HeartCurveViewController: UIViewController {
    @IBOutlet weak var heartChartView: LineChartView!
    @IBOutlet weak var bloodChartView: LineChartView!
    @IBOutlet weak var heartBeatChartView: LineChartView!
    
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
    
    private func setChart(_ view: LineChartView) {
        var limits: [ChartLimitLine] = []
        switch view {
        case heartChartView, bloodChartView:
            let normal = ChartLimitLine(limit: 30, label: "正常".localized())
            normal.lineWidth = 1
            normal.labelPosition = .rightBottom
            normal.lineColor = .blue
            normal.valueFont = .systemFont(ofSize: 10)
            
            let lower = ChartLimitLine(limit: 65, label: "低風險".localized())
            lower.lineWidth = 1
            lower.labelPosition = .rightBottom
            lower.lineColor = .blue
            lower.valueFont = .systemFont(ofSize: 10)
            
            let height = ChartLimitLine(limit: 65, label: "高風險".localized())
            height.lineWidth = 1
            height.labelPosition = .rightTop
            height.lineColor = .blue
            height.valueFont = .systemFont(ofSize: 10)
            limits = [normal, lower, height]
            break
        default:
            let lower = ChartLimitLine(limit: 50, label: "低風險".localized())
            lower.lineWidth = 1
            lower.labelPosition = .rightBottom
            lower.lineColor = .blue
            lower.valueFont = .systemFont(ofSize: 10)
            
            let height = ChartLimitLine(limit: 50, label: "高風險".localized())
            height.lineWidth = 1
            height.labelPosition = .rightTop
            height.lineColor = .blue
            height.valueFont = .systemFont(ofSize: 10)
            limits = [lower, height]
            break
        }
        
        
        let leftAxis = view.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelCount = 10
        limits.forEach({ leftAxis.addLimitLine($0) })
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        // 不畫中間的線
        leftAxis.drawGridLinesEnabled = false
        // 畫底下的線
        leftAxis.drawZeroLineEnabled = true
        
        view.xAxis.enabled = false
        view.rightAxis.enabled = false
        
        // 隱藏文字
        view.legend.enabled = false
        
        self.setData(view)
    }
    
    private func setData(_ view: LineChartView) {
        let yVals1 = (0..<20).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(100))
            return ChartDataEntry(x: Double(i), y: i == 0 ? 0 : val)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "收縮壓")
        set1.axisDependency = .left
        set1.setColor(.red)
        set1.setCircleColor(.red)
        set1.lineWidth = 2
        set1.circleRadius = 3
        
        let data = LineChartData(dataSet: set1)
        data.dataSets.forEach({ $0.drawValuesEnabled = true; $0.highlightEnabled = false })
        view.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "")
        self.navigationItem.titleView = self.titleView
        self.navigationItem.rightBarButtonItems = [self.shareButton, self.curveButton]
        
        self.setChart(self.heartChartView)
        self.setChart(self.bloodChartView)
        self.setChart(self.heartBeatChartView)
    }
}
extension HeartCurveViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.selectDate(date: UserInfo.share.selectedDate) { (date) in
            UserInfo.share.selectedDate = date
        }
        return false
    }
}

