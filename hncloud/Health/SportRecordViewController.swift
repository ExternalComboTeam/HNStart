//
//  SportRecordViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/31.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import ZZCircleProgress

class SportRecordViewController: UIViewController {

    @IBOutlet weak var progressContainView: UIView!
    
    private lazy var progressView: ZZCircleProgress? = {
        let width: CGFloat = UIScreen.main.bounds.width * 0.5
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let view = ZZCircleProgress(frame: frame, pathBack: #colorLiteral(red: 0.06107305735, green: 0.07715373486, blue: 0.2354443967, alpha: 1), pathFill: #colorLiteral(red: 0, green: 0.9932600856, blue: 0.7853906751, alpha: 1), startAngle: -90, strokeWidth: 15)
        view?.showPoint = false
        view?.showProgressText = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "")
        
        guard let progressView = self.progressView else { return }
        self.progressContainView.addSubview(progressView)
        progressView.prepareToShow = true
    }

}
