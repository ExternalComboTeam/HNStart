//
//  SugerData.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import Foundation
import Charts

class SugerData {
    /// 空腹
    lazy var fpg: BarChartDataSet = {
        let array = (0..<4).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: 0)
        }
        let data = BarChartDataSet(values: array, label: "空腹FPG".localized())
        data.setColor(#colorLiteral(red: 0, green: 0, blue: 0.8981388211, alpha: 1))
        return data
    }()
    /// 飯後
    lazy var pfg: BarChartDataSet = {
        let array = (0..<4).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: 0)
        }
        let data = BarChartDataSet(values: array, label: "飯後PPG".localized())
        data.setColor(#colorLiteral(red: 0, green: 0.3866138756, blue: 0.2844228745, alpha: 1))
        return data
    }()
    /// 早上飯前
    var mFasting: String = "" {
        didSet {
            guard let value = Double(self.mFasting) else { return }
            self.fpg.values[0].y = value
        }
    }
    /// 早上飯後
    var mAfer: String = "" {
        didSet {
            guard let value = Double(self.mAfer) else { return }
            self.pfg.values[0].y = value
        }
    }
    /// 中午飯前
    var lFasting: String = "" {
        didSet {
            guard let value = Double(self.lFasting) else { return }
            self.fpg.values[1].y = value
        }
    }
    /// 中午飯後
    var lAfer: String = "" {
        didSet {
            guard let value = Double(self.lAfer) else { return }
            self.pfg.values[1].y = value
        }
    }
    /// 晚上飯前
    var dFasting: String = "" {
        didSet {
            guard let value = Double(self.dFasting) else { return }
            self.fpg.values[2].y = value
        }
    }
    /// 晚上飯後
    var dAfer: String = "" {
        didSet {
            guard let value = Double(self.dAfer) else { return }
            self.pfg.values[2].y = value
        }
    }
    /// 睡前
    var sBefore: String = "" {
        didSet {
            guard let value = Double(self.sBefore) else { return }
            self.fpg.values[3].y = value
        }
    }
}
