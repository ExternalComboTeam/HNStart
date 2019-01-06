//
//  ClockTypeViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwiftMessages

enum ClockType {
    case sport
    case medicine
    case drink
    case sleep
    case date
    case custom
    
    static func getType(by: Int) -> ClockType {
        switch by {
        case 1:
            return .sport
        case 2:
            return .medicine
        case 3:
            return .drink
        case 4:
            return .sleep
        case 5:
            return .date
        default:
            return .custom
        }
    }
    
    var saveValue: Int {
        switch self {
        case .sport:
            return 1
        case .medicine:
            return 2
        case .drink:
            return 3
        case .sleep:
            return 4
        case .date:
            return 5
        case .custom:
            return 6
        }
    }
    
    var name: String {
        switch self {
        case .sport:
            return "運動".localized()
        case .medicine:
            return "吃藥".localized()
        case .drink:
            return "飲料".localized()
        case .sleep:
            return "睡眠".localized()
        case .date:
            return "約會".localized()
        case .custom:
            return ""
        }
    }
}

class ClockTypeViewController: UIViewController {

    var delegate: ClockTypeDelegate?
    @IBAction func sportAction(_ sender: UIButton) {
        self.delegate?.selectType(.sport)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func medicineAction(_ sender: UIButton) {
        self.delegate?.selectType(.medicine)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func drinkAction(_ sender: UIButton) {
        self.delegate?.selectType(.drink)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sleepAction(_ sender: UIButton) {
        self.delegate?.selectType(.sleep)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dateAction(_ sender: UIButton) {
        self.delegate?.selectType(.date)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func customAction(_ sender: UIButton) {
        self.delegate?.selectType(.custom)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

protocol ClockTypeDelegate {
    func selectType(_ type: ClockType)
}

class SwiftMessagesBottomSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomMessage)
    }
}
