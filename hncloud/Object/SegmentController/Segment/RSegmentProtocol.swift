//
//  RSegmentDelegate.swift
//  SegmentDemo
//
//  Created by Ray on 2018/6/6.
//  Copyright © 2018年 Ray. All rights reserved.
//

import UIKit

protocol RSegmentDelegate: NSObjectProtocol {
    /// 目前選擇
    func Segment(segment: RSegment, didSelect: Int)
}

protocol RSegmentDataSource: NSObjectProtocol {
    /// 選單數量
    func numberOfSegment() -> Int
    /// 選單項目
    func Segment(item row: Int) -> RSegmentItem
}
