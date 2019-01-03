//
//  SedentaryModel.swift
//  hncloud
//
//  Created by Hong Shih on 2018/12/25.
//  Copyright © 2018 OverSoar Digital Technology Co., Ltd. All rights reserved.
//

import UIKit

class SedentaryModel: NSObject {
    
    var index: Int
    var beginMin: Int
    var beginHour: Int
    var endMin: Int
    var endHour: Int
    var duration: Int

    init(index: Int,
         beginMin: Int,
         beginHour: Int,
         endMin: Int,
         endHour: Int,
         duration: Int) {
        
        self.index = index
        self.beginMin = beginMin
        self.beginHour = beginHour
        self.endMin = endMin
        self.endHour = endHour
        self.duration = duration
        
        super.init()
    }
}
