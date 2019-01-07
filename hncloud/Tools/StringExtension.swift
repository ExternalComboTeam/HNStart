//
//  StringExtension.swift
//  hncloud
//
//  Created by 辰 on 2019/1/8.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

extension String {
    func substring(_ start: Int, _ end: Int) -> String {
        return (self as NSString).substring(with: NSMakeRange(start, end - start))
    }
}
