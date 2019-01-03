//
//  RSegmentOption.swift
//  SegmentDemo
//
//  Created by Ray on 2018/6/6.
//  Copyright © 2018年 Ray. All rights reserved.
//

import Foundation
import UIKit

// 屬性
class RSegmentOption {
    /// 顏色
    var color: Color = Color()
    /// 模式
    var mode: Mode = Mode()
    /// 是否可滾動
    var isScrollEnable: Bool = true
    /// 可視的最大數量
    var maxVisual: Float = 4.0
    /// 邊距與比例
    var content: Content = Content()
}

// 顏色
class Color {
    /// 背景顏色
    var background: CellState = CellState()
    /// 標題顏色
    var title: CellState = CellState()
    /// 分割線顏色
    var dividersColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}
// Cell狀態
class CellState {
    /// 選擇時
    var selected: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    /// 一般的
    var normal: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}
// 模式
class Mode {
    /// 樣式
    var style: RSegmentStyle = .onlyLabel
    /// 選擇時的樣式
    var selectStyle: RSegmentSelectStyle = .none
    /// 圖片模式
    var imageContentMode: UIView.ContentMode = .center
    /// 文字位置
    var labelTextAlignment: NSTextAlignment = .center
    /// 文字大小
    var labelFont: UIFont = UIFont.systemFont(ofSize: 12)
}
// 邊距與比例
class Content {
    /// Cell 圖片與文字比例
    var proportion: CGFloat = 1.5
    /// Cell 外部邊距
    var margins: UIEdgeInsets = UIEdgeInsets.zero
    /// Cell 內部邊距
    var contentEdge: UIEdgeInsets = UIEdgeInsets.zero
}

var AutoVisual: Float = -1

/// 模式
enum RSegmentStyle {
    case onlyLabel, onlyImage, labelUnderImage, imageUnderLabel, imageBeforeLabel, imageAfterLabel
}
/// 選擇模式
enum RSegmentSelectStyle {
    /// 一般
    case none
    /// 下底線
    case underLine
    /// 方塊
    case Block
}
