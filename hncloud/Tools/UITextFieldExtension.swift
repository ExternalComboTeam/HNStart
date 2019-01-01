//
//  UITextFieldExtension.swift
//  hncloud
//
//  Created by 辰 on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import ActionSheetPicker_3_0

extension UITextField {
    func selectDate(date: Date, _ complete: ((Date) -> Void)?) {
        let minDate = "2018-01-01".date(withFormat: "yyyy-MM-dd") ?? Date()
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate: date, minimumDate: minDate, maximumDate: Date(), doneBlock: { (picker, selected, origin) in
            guard let selected = selected as? Date else { return }
            complete?(selected)
            self.text = selected.isInToday ? "今日".localized() : selected.localDate()
        }, cancel: { (picker) in
            
        }, origin: self)
    }
}
