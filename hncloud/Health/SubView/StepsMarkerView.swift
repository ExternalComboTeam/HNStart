//
//  StepsMarkerView.swift
//  hncloud
//
//  Created by 辰 on 2019/1/5.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class StepsMarkerView: UIView {

    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBAction func hideAction(_ sender: Any) {
        self.isHidden = true
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private func reSize() {
        guard self.size.width != 50 else { return }
        self.size = CGSize(width: 50, height: 50)
        self.setNeedsDisplay()
    }
    
    func setValue(point: CGPoint, steps: Int) {
        self.reSize()
        self.center = point
        self.stepsLabel.text = "\(steps)"
        self.isHidden = false
    }
    
    override func draw(_ rect: CGRect) {
        let size = CGSize(width: 50, height: 50)
        let b = UIBezierPath()
        b.addArc(withCenter: CGPoint(x: size.width / 2, y: (size.height - 10) / 2), radius: (size.height - 10) / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        b.move(to: CGPoint(x: size.width / 2, y: size.height))
        b.addLine(to: CGPoint(x: (size.width / 2) - 7, y: size.height - 15))
        b.addLine(to: CGPoint(x: (size.width / 2) + 7, y: size.height - 15))
        b.close()
        UIColor.clear.setStroke()
        b.stroke()
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7).setFill()
        b.fill()
    }
}
