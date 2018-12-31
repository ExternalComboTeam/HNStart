//
//  HeartViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/28.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import Charts

class HeartViewController: UIViewController {

    @IBOutlet weak var sysTitleLabel: UILabel!
    @IBOutlet weak var diaTitleLabel: UILabel!
    @IBOutlet weak var ratTitleLabel: UILabel!
    @IBOutlet weak var sysLabel: UILabel!
    @IBOutlet weak var diaLabel: UILabel!
    @IBOutlet weak var ratLabel: UILabel!
    
    @IBAction func curveAction(_ sender: Any) {
        let vc = HeartCurveViewController.fromStoryboard()
        self.push(vc: vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
