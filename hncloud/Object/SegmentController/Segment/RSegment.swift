//
//  RSegment.swift
//  SegmentDemo
//
//  Created by Ray on 2018/6/6.
//  Copyright © 2018年 Ray. All rights reserved.
//

import Foundation
import UIKit

// 項目
public class RSegmentItem {
    var title: String
    var normalImage: UIImage?
    var highlightedImage: UIImage?
    
    init(title: String, normal image: UIImage? = nil, highlighted imaged: UIImage? = nil) {
        self.title = title
        self.normalImage = image
        self.highlightedImage = imaged
    }
}

// 使用項目
internal class RSegmentUseItem: RSegmentItem {
    var row: Int = 0
    init(item: RSegmentItem, row: Int) {
        super.init(title: item.title, normal: item.normalImage, highlighted: item.highlightedImage)
        self.title = item.title
        self.normalImage = item.normalImage
        self.highlightedImage = item.highlightedImage
        self.row = row
    }
}

class RSegment: UIView {
    
    weak var delegate: RSegmentDelegate?
    weak var dataSource: RSegmentDataSource?
    
    /// 選擇項目
    var currentIndex: Int = 0 {
        didSet {
            guard let dataSource = self.dataSource else {
                self.beforeCurrentIndex = self.currentIndex
                return
            }
            guard self.currentIndex < dataSource.numberOfSegment() && self.currentIndex > -1 else { return }
            self.scroll(to: self.currentIndex)
            self.changeSelect()
        }
    }
    var alphaSegment: CGFloat = 1 {
        didSet {
            self.alpha = self.alphaSegment
            self.scroll?.alpha = self.alphaSegment
            self.scroll?.subviews.forEach({ $0.alpha = self.alphaSegment })
            self.moveView?.alpha = self.alphaSegment
            self.blockView?.alpha = self.alphaSegment
        }
    }
    
    private var beforeCurrentIndex: Int = -1
    
    private var scroll: UIScrollView?
    private var optional: RSegmentOption = RSegmentOption()
    private var array: [RSegmentUseItem] = []
    
    private var moveView: UIView?
    private var blockView: UIView?
    
    private var isUpdating: Bool = false
    
    /// 建立 ScrollView
    private func createScrollView() {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        self.scroll = scrollView
        self.addSubview(scrollView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createScrollView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scroll?.frame.size = self.bounds.size
        self.updateArray()
    }
}
extension RSegment {
    /// 參數設定
    ///
    /// - Parameters:
    ///   - content: 選單陣列
    ///   - option: 屬性
    public func setup(_ option: RSegmentOption = RSegmentOption()) {
        self.updateArray()
        self.optional = option
        self.scroll?.backgroundColor = option.color.dividersColor
    }
    
    /// 更新選單
    public func reloadData() {
        self.isUpdating = false
        self.updateArray()
    }
    /// 更新選單
    private func updateArray() {
        guard !self.isUpdating else { return }
        self.isUpdating = true
        guard let source = self.dataSource else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.scroll?.subviews.forEach({ $0.removeFromSuperview() })
            let number = source.numberOfSegment()
            self.array.removeAll()
            for item in 0..<number {
                let useItem = RSegmentUseItem(item: source.Segment(item: item), row: item)
                self.array.append(useItem)
            }
            guard number > 0 else { return }
            self.createContent(self.currentIndex)
            self.isUpdating = false
        }
    }
}
extension RSegment {
    // Cell Width
    private var cellWidth: CGFloat {
        let frameWidth = self.bounds.width
        let edge = self.optional.content.margins
        let unitWidth = frameWidth / CGFloat(self.maxVisual)
        let width = unitWidth - edge.right - edge.left
        return width
    }
    // Cell Height
    private var cellHeight: CGFloat {
        let frameHeight = self.bounds.height
        let edge = self.optional.content.margins
        let height = frameHeight - edge.top - edge.bottom
        return height
    }
    /// 畫面最多顯示多少Cell
    private var maxVisual: Float {
        let number = Float(self.array.count) < self.optional.maxVisual ? Float(self.array.count) : self.optional.maxVisual
        return number
    }
    /// 總長度
    private var totalWidth: CGFloat {
        let edge = self.optional.content.margins
        if self.optional.maxVisual > 0 {
            let unitWidth: CGFloat = edge.right + edge.left + self.cellWidth
            return unitWidth * CGFloat(self.array.count)
        } else {
            var width: CGFloat = 0
            self.array.forEach { (item) in
                width = width + edge.right + edge.left + self.widthForComment(item.title, height: self.bounds.height)
            }
            return width
        }
    }
    
    /// 建立選單
    private func createContent(_ current: Int) {
        guard let scrollView = self.scroll else { return }
        let contentWidth: CGFloat = self.totalWidth < self.bounds.width ? self.bounds.width : self.totalWidth
        guard !contentWidth.isNaN else { return }
        self.scroll?.contentSize = CGSize(width: contentWidth, height: 0)
        let edge = self.optional.content.margins
        self.createCell(scrollView, edge: edge)
        
        switch self.optional.mode.selectStyle {
        case .none:
            break
        case .underLine:
            let underBarView = UIView(frame: CGRect(x: edge.right, y: self.bounds.height - 3, width: self.cellWidth, height: 3))
            underBarView.backgroundColor = self.optional.color.background.selected
            scrollView.addSubview(underBarView)
            self.moveView = underBarView
            self.moveView(proportion: CGFloat(current))
            break
        case .Block:
            let width: CGFloat = self.bounds.width / CGFloat(self.maxVisual)
            let blockView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.bounds.height))
            blockView.backgroundColor = .clear
            blockView.layer.masksToBounds = true
            let insideview = UIView(frame: CGRect(x: 0, y: 0, width: contentWidth, height: self.bounds.height))
            insideview.backgroundColor = .clear
            self.createCell(insideview, edge: edge)
            self.blockView = insideview
            blockView.addSubview(insideview)
            scrollView.addSubview(blockView)
            self.moveView = blockView
            self.moveView(proportion: CGFloat(current))
            break
        }
        guard self.beforeCurrentIndex != -1 else { return }
        self.currentIndex = self.beforeCurrentIndex
        self.beforeCurrentIndex = -1
    }
    /// 建立Cell
    private func createCell(_ view: UIView, edge: UIEdgeInsets) {
        let cellWidth = self.cellWidth
        var orginX: CGFloat = edge.left
        var addWidth: CGFloat = 0
        // 剩餘
        let remain = self.bounds.width - self.totalWidth
        if remain > 0 {
            addWidth = remain / CGFloat(self.array.count)
        }
        for item in 0..<self.array.count {
            if let cell = Bundle.main.loadNibNamed("RSegmentCell", owner: nil, options: nil)?[0] as? RSegmentCell {
                let width: CGFloat = self.optional.maxVisual > 0 ? cellWidth : self.widthForComment(self.array[item].title, height: self.cellHeight) + addWidth
                let frame = CGRect(x: orginX, y: edge.top, width: width, height: self.cellHeight)
                orginX = edge.left + orginX + width + edge.right
                cell.update(frame: frame, option: self.optional, item: self.array[item], super: view)
                if view is UIScrollView {
                    cell.actionButton.addTarget(self, action: #selector(self.selectButton(_:)), for: .touchUpInside)
                    cell.change(select: self.currentIndex)
                } else {
                    cell.backgroundColor = self.optional.color.background.selected
                }
                view.addSubview(cell)
            }
        }
        
    }
    
    /// 變更選項時改變顏色
    private func changeSelect() {
        guard self.optional.mode.selectStyle != .Block else { return }
        self.scroll?.subviews.forEach({ (view) in
            if let cell = view as? RSegmentCell {
                cell.change(select: self.currentIndex)
            }
        })
    }
    /// 點擊選單時
    @objc private func selectButton(_ sender: UIButton) {
        guard let cell = sender.superview as? RSegmentCell else { return }
        guard let item = cell.item else { return }
        self.delegate?.Segment(segment: self, didSelect: item.row)
        self.currentIndex = item.row
    }
    /// 移動畫面
    private func scroll(to current: Int) {
        guard let scrollView = self.scroll else { return }
        guard scrollView.subviews.count > current else { return }
        let cell = scrollView.subviews[current]
        let halfWidth: CGFloat = (self.bounds.width / 2) - (cell.frame.width / 2)
        let center = cell.frame.origin.x - halfWidth
        // scroll 最後能移動到的 contentOffsetX
        let scrollFinalX = scrollView.contentSize.width - self.bounds.width
        var offsetX: CGFloat = 0
        if center < 0 {
            offsetX = 0
        } else if center > scrollFinalX {
            offsetX = scrollFinalX
        } else {
            offsetX = center
        }
        let point = CGPoint(x: offsetX, y: 0)
        self.scroll?.setContentOffset(point, animated: true)
        
        if self.optional.mode.selectStyle == .underLine {
            UIView.animate(withDuration: 0.1) {
                self.moveView?.frame = CGRect(x: cell.frame.origin.x, y: self.moveView?.frame.origin.y ?? 0, width: cell.width, height: 3)
            }
        }
    }
    
    /// 移動
    func moveView(proportion: CGFloat) {
        guard let scrollView = self.scroll else { return }
        let unit = scrollView.contentSize.width / CGFloat(self.array.count)
        let movePoint = unit * proportion
        let halfWidth: CGFloat = (self.bounds.width / 2) - (unit / 2)
        // 使選擇在正中間
        let moveCenter = movePoint - halfWidth
        // scroll 最後能移動到的 contentOffsetX
        let scrollFinalX = scrollView.contentSize.width - self.bounds.width
        
        self.moveView?.frame.origin = CGPoint(x: movePoint, y: self.moveView?.frame.origin.y ?? 0)
        self.blockView?.frame.origin = CGPoint(x: -movePoint, y: 0)
        
        guard movePoint > halfWidth && moveCenter < scrollFinalX else { return }
        scrollView.contentOffset = CGPoint(x: moveCenter, y: 0)
    }
    
    /// 高度固定計算寬度
    private func widthForComment(_ word: String, height: CGFloat) -> CGFloat {
        let rect = NSString(string: word).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: self.optional.mode.labelFont], context: nil)
        return ceil(rect.width) + 20
    }
}
