//
//  MarkerView.swift
//  hncloud
//
//  Created by 辰 on 2019/1/5.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import Foundation
import Charts

class MarkerView: MarkerImage {
    
    private var entry: BarChartDataEntry?
    private var action: ((CGPoint, BarChartDataEntry) -> Void)?
    
    func tapBar(_ action: ((CGPoint, BarChartDataEntry) -> Void)?) {
        self.action = action
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        guard let entry = self.entry else { return }
        self.action?(point, entry)
    }
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        guard let value = entry as? BarChartDataEntry else { return }
        self.entry = value
    }
}
