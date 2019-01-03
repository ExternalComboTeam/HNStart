//
//  CurveChildViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/4.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class CurveChildViewController: UIViewController {

    var index: Int = 0
    @IBOutlet weak var curveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.curveView.backgroundColor = self.index == 0 ? .blue : .red
    }
}
