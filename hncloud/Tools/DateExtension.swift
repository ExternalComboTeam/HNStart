//
//  DateExtension.swift
//  hncloud
//
//  Created by 辰 on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

extension Date {
    func localDate(_ dateFormat: String = "MM.dd EEE", showToday: Bool = true) -> String {
        let formater = DateFormatter()
        formater.locale = Locale(identifier: Locale.appLanguage)
        formater.dateFormat = dateFormat
        guard showToday else {
            return formater.string(from: self)
        }
        return self.isInToday ? "今日".localized() : formater.string(from: self)
    }
}
