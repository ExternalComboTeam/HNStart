//
//  SleepMarkerView.swift
//  hncloud
//
//  Created by 辰 on 2019/1/6.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class SleepMarkerView: UIView {

    @IBOutlet weak var deepLabel: UILabel!
    @IBOutlet weak var shallowLabel: UILabel!
    @IBOutlet weak var wakeupLabel: UILabel!
    
    private func reSize() {
        guard self.size.width != 85 else { return }
        self.size = CGSize(width: 85, height: 60)
        self.setNeedsDisplay()
    }
    
    func setValue(point: CGPoint, values: [Double]) {
        guard values.count == 3 else { return }
        self.reSize()
        self.center = point
        self.deepLabel.text = self.getTime(values[0])
        self.shallowLabel.text = self.getTime(values[1])
        self.wakeupLabel.text = self.getTime(values[2])
        self.isHidden = false
    }
    
    private func getTime(_ value: Double) -> String {
        let time = Int(value)
        let h = time / 60
        let m = time % 60
        return h == 0 ? "\(m)min" : "\(h)h\(m)min"
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let size = CGSize(width: 85, height: 60)
        let roundedRect = CGRect(x: 0, y: 0, width: 85, height: 55)
        let b = UIBezierPath(roundedRect: roundedRect, cornerRadius: 5)
        
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
