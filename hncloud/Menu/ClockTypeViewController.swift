//
//  ClockTypeViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import SwiftMessages

enum ClockType: Int {
    
    case sport = 0
    case date
    case drink
    case medicine
    case sleep
    case custom
    
    static func getType(by: Int) -> ClockType {
        switch by {
        case 1:
            return .sport
        case 2:
            return .date
        case 3:
            return .drink
        case 4:
            return .medicine
        case 5:
            return .sleep
        default:
            return .custom
        }
    }
    
    var saveValue: Int {
        switch self {
        case .sport:
            return 1
        case .date:
            return 2
        case .drink:
            return 3
        case .medicine:
            return 4
        case .sleep:
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
    
    var image: UIImage? {
        switch self {
        case .sport:
            return #imageLiteral(resourceName: "running")
        case .medicine:
            return #imageLiteral(resourceName: "medicine")
        case .drink:
            return #imageLiteral(resourceName: "dringk")
        case .sleep:
            return #imageLiteral(resourceName: "sleep")
        case .date:
            return #imageLiteral(resourceName: "appo")
        case .custom:
            return #imageLiteral(resourceName: "running")
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
        
        let alert = UIAlertController(title: "提醒的名稱", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(title: "取消".localized(), style: .cancel, isEnabled: true, handler: nil)
        alert.addAction(title: "確定".localized(), style: .default, isEnabled: true) { (_alert) in
            self.delegate?.selectType(.custom)
            self.delegate?.setCustomString(alert.textFields?.first?.text ?? "")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

protocol ClockTypeDelegate {
    func selectType(_ type: ClockType)
    func setCustomString(_ text: String)
}

class SwiftMessagesBottomSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomMessage)
    }
}
