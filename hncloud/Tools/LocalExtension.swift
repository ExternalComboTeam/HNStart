//
//  LocalExtension.swift
//  hncloud
//
//  Created by 辰 on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

extension Locale {
    static var appLanguage: String {
        guard let array = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] else { return "" }
        return array.first ?? ""
    }
}
