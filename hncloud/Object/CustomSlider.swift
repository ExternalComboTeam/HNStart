//
//  CustomSlider.swift
//  hncloud
//
//  Created by 辰 on 2019/1/2.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import Foundation
import StepSlider

class CustomSlider: UIView {
    private var stepSlider: StepSlider = StepSlider(frame: .zero)
    
    private var normalFont: UIFont = UIFont.systemFont(ofSize: 10)
    private var selectedFont: UIFont = UIFont.systemFont(ofSize: 17)
    
    private var normalTitle: [String] = []
    private var selectedTitle: [String] = []
    private var labelsArray: [UILabel] = []
    private var stepHeight: CGFloat = 0
    
    var index: Int {
        set {
            self.stepSlider.setIndex(UInt(newValue), animated: true)
        }
        get {
            return Int(self.stepSlider.index)
        }
    }
    
    var sliderImage: UIImage? {
        didSet {
            guard let image = self.sliderImage else { return }
            self.stepSlider.sliderCircleImage = image
        }
    }
    
    var selectedTitleColor: UIColor = .blue
    
    var sliderTintColor: UIColor = .blue {
        didSet {
            self.stepSlider.tintColor = self.sliderTintColor
            self.stepSlider.trackColor = self.sliderTintColor
        }
    }
    
    func setTitle(normal: [String], selected: [String]) {
        guard normal.count == selected.count else { return }
        self.normalTitle = normal
        self.selectedTitle = selected
        self.labelsArray.forEach({ $0.removeFromSuperview() })
        self.stepSlider.removeFromSuperview()
        self.normalTitle.forEach { (title) in
            let lab = UILabel(text: title)
            lab.font = self.normalFont
            lab.sizeToFit()
            self.labelsArray.append(lab)
            self.addSubview(lab)
        }
        self.addSubview(self.stepSlider)
        self.stepSlider.isDotsInteractionEnabled = false
        self.stepSlider.trackHeight = 10
        self.stepSlider.sliderCircleRadius = 10
        self.stepSlider.maxCount = UInt(self.normalTitle.count)
        self.stepSlider.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        self.setNeedsLayout()
    }
    
    @objc private func valueChange() {
        self.handleSliderAction()
    }
    
    private func handleSliderAction() {
        UIView.beginAnimations(nil, context: nil)
        
        self.setNormal()
        
        let selectedLab = self.labelsArray[self.index]
        selectedLab.font = self.selectedFont
        selectedLab.text = self.selectedTitle[self.index]
        let center = selectedLab.center
        selectedLab.sizeToFit()
        selectedLab.textColor = self.selectedTitleColor
        let minX = center.x - selectedLab.frame.width / 2
        let maxX = center.x + selectedLab.frame.width / 2
        
        if minX < 0 {
            selectedLab.center.x = center.x - (2 * minX)
        } else if maxX > self.bounds.width {
            selectedLab.center.x = center.x - selectedLab.frame.width / 2
        } else {
            selectedLab.center.x = center.x
        }
        selectedLab.center.y = center.y - 20
        UIView.commitAnimations()
    }
    
    private func setNormal() {
        let width = self.bounds.width - 40
        let height = frame.height * 0.5
        let labW = (width - 20) / CGFloat(self.labelsArray.count - 1)
        for i in 0..<self.labelsArray.count {
            let label = self.labelsArray[i]
            label.text = self.normalTitle[i]
            label.textColor = .black
            label.sizeToFit()
            label.font = self.normalFont
            label.center.x = CGFloat(i) * labW + 30
            label.center.y = height - 20
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.bounds.width != self.stepSlider.frame.width + 40 else { return }
        let width = self.bounds.width - 40
        let height = frame.height * 0.5
        self.stepSlider.frame = CGRect(x: 20, y: height, width: width, height: frame.height - height)
        self.handleSliderAction()
    }
}
