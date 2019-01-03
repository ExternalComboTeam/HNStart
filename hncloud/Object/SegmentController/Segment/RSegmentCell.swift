//
//  RSegmentCell.swift
//  SegmentDemo
//
//  Created by Ray on 2018/6/6.
//  Copyright © 2018年 Ray. All rights reserved.
//

import UIKit

class RSegmentCell: UIView {

    // imageAfterLabel
    @IBOutlet weak var imageAfterLabel: UIView!
    // imageBeforeLabel
    @IBOutlet weak var imageBeforeLabel: UIView!
    // imageUnderLabel
    @IBOutlet weak var imageUnderLabel: UIView!
    // labelUnderImage
    @IBOutlet weak var labelUnderImage: UIView!
    
    @IBOutlet weak var image_imageAfterLabel: UIImageView!
    @IBOutlet weak var image_imageBeforeLabel: UIImageView!
    @IBOutlet weak var image_imageUnderLabel: UIImageView!
    @IBOutlet weak var image_labelUnderImage: UIImageView!
    
    @IBOutlet weak var label_imageAfterLabel: UILabel!
    @IBOutlet weak var label_imageBeforeLabel: UILabel!
    @IBOutlet weak var label_imageUnderLabel: UILabel!
    @IBOutlet weak var label_labelUnderImage: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var proportion_imageAfterLabel: NSLayoutConstraint!
    @IBOutlet weak var proportion_imageBeforeLabel: NSLayoutConstraint!
    @IBOutlet weak var proportion_imageUnderLabel: NSLayoutConstraint!
    @IBOutlet weak var proportion_labelUnderImage: NSLayoutConstraint!
    
    /// 為了只顯示圖片或文字
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    private var option: RSegmentOption = RSegmentOption()
    var item: RSegmentUseItem?
    
    func update(frame: CGRect, option: RSegmentOption, item: RSegmentUseItem, super view: UIView) {
        self.frame = frame
        self.backgroundColor = self.option.color.background.normal
        self.option = option
        self.item = item
        
        // 設定邊界
        self.setEdge()
        // 設定圖片與文字的比例
        self.setMultiplier()
        // 變更 Cell的模式
        self.changeStyle()
        // 設定文字
        self.setLabel()
        // 設定文字顏色與圖片
        if view is UIScrollView {
            self.setLabelColor(is: false)
            self.setImage(is: false)
        } else {
            self.setLabelColor(is: true)
            self.setImage(is: true)
        }
    }
    
    /// set cell edge
    private func setEdge() {
        let edge = self.option.content.contentEdge
        self.topConstraint.constant = edge.top
        self.leftConstraint.constant = edge.left
        self.rightConstraint.constant = edge.right
        self.bottomConstraint.constant = edge.bottom
    }
    
    /// set image and label multiplier
    private func setMultiplier() {
        self.proportion_imageAfterLabel = self.change(constraint: self.proportion_imageAfterLabel)
        self.proportion_imageBeforeLabel = self.change(constraint: self.proportion_imageBeforeLabel)
        self.proportion_imageUnderLabel = self.change(constraint: self.proportion_imageUnderLabel)
        self.proportion_labelUnderImage = self.change(constraint: self.proportion_labelUnderImage)
    }
    
    /// change multiplier
    private func change(constraint: NSLayoutConstraint) -> NSLayoutConstraint? {
        guard let firstItem = constraint.firstItem, let secondItem = constraint.secondItem else { return nil }
        let newContrstraint = NSLayoutConstraint(item: firstItem,
                                                 attribute: constraint.firstAttribute,
                                                 relatedBy: constraint.relation,
                                                 toItem: secondItem,
                                                 attribute: constraint.secondAttribute,
                                                 multiplier: self.option.content.proportion,
                                                 constant: constraint.constant)
        newContrstraint.priority = constraint.priority
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newContrstraint])
        return newContrstraint
    }
    
    /// 變更 Cell的模式
    private func changeStyle() {
        let style = self.option.mode.style
        switch style {
        case .onlyImage:
            self.labelUnderImage.isHidden = false
            self.stackView.arrangedSubviews[1].isHidden = true
            break
        case .onlyLabel:
            self.labelUnderImage.isHidden = false
            self.stackView.arrangedSubviews[0].isHidden = true
            break
        case .imageAfterLabel:
            self.imageAfterLabel.isHidden = false
            break
        case .imageBeforeLabel:
            self.imageBeforeLabel.isHidden = false
            break
        case .imageUnderLabel:
            self.imageUnderLabel.isHidden = false
            break
        case .labelUnderImage:
            self.labelUnderImage.isHidden = false
            break
        }
    }
    /// 設定圖片模式
    private func setImageModel() {
        let mode = self.option.mode.imageContentMode
        self.image_imageAfterLabel.contentMode = mode
        self.image_imageBeforeLabel.contentMode = mode
        self.image_imageUnderLabel.contentMode = mode
        self.image_labelUnderImage.contentMode = mode
    }
    /// 變更選擇
    func change(select row: Int) {
        guard let item = self.item else { return }
        guard self.option.mode.selectStyle != .Block else { return }
        let isSelect = row == item.row
        self.setImage(is: isSelect)
        self.setLabelColor(is: isSelect)
    }
    /// 設定圖片
    private func setImage(is highlighted: Bool) {
        guard let item = self.item else { return }
        let image = highlighted ? item.highlightedImage : item.normalImage
        self.image_imageAfterLabel.image = image
        self.image_imageBeforeLabel.image = image
        self.image_imageUnderLabel.image = image
        self.image_labelUnderImage.image = image
    }
    
    /// 設定文字
    private func setLabel() {
        guard let item = self.item else { return }
        let title = item.title
        self.label_imageAfterLabel.text = title
        self.label_imageBeforeLabel.text = title
        self.label_imageUnderLabel.text = title
        self.label_labelUnderImage.text = title
        let font = self.option.mode.labelFont
        self.label_imageAfterLabel.font = font
        self.label_imageBeforeLabel.font = font
        self.label_imageUnderLabel.font = font
        self.label_labelUnderImage.font = font
        let mode = self.option.mode.labelTextAlignment
        self.label_imageAfterLabel.textAlignment = mode
        self.label_imageBeforeLabel.textAlignment = mode
        self.label_imageUnderLabel.textAlignment = mode
        self.label_labelUnderImage.textAlignment = mode
    }
    /// 設定文字顏色
    private func setLabelColor(is highlighted: Bool) {
        let myColor = self.option.color
        let color = highlighted ? myColor.title.selected : myColor.title.normal
        self.label_imageAfterLabel.textColor = color
        self.label_imageBeforeLabel.textColor = color
        self.label_imageUnderLabel.textColor = color
        self.label_labelUnderImage.textColor = color
        
        if self.option.mode.selectStyle == .none {
            self.backgroundColor = highlighted ? myColor.background.selected : myColor.background.normal
        } else {
            self.backgroundColor = myColor.background.normal
        }
    }
}








