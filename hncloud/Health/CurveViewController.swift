//
//  CurveViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/4.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit

class CurveViewController: RPagingViewController {

    lazy private var shareButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_share"), for: .normal)
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var titleView: UISegmentedControl = {
        let view = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        view.segmentTitles = ["周", "月"]
        view.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        view.layer.borderColor = UIColor.black.cgColor
        view.tintColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        view.addTarget(self, action: #selector(self.selected(_:)), for: .valueChanged)
        view.selectedSegmentIndex = 0
        return view
    }()
    
    @objc private func selected(_ sender: UISegmentedControl) {
        self.scroll(to: sender.selectedSegmentIndex)
    }
    
    // 分享
    @objc private func share(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        var shareItem: [Any] = []
        shareItem.append(window.asImage())
        let share = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        // 設定郵件的標題
        share.setValue(title, forKey: "subject")
        
        var shareType: [UIActivity.ActivityType] = [.addToReadingList, .airDrop, .assignToContact, .openInIBooks, .postToFlickr, .postToTencentWeibo, .postToVimeo, .print , .saveToCameraRoll]
        if #available(iOS 11.0, *) {
            shareType.append(.markupAsPDF)
        }
        
        share.popoverPresentationController?.sourceView = sender
        share.popoverPresentationController?.sourceRect = sender.bounds
        share.excludedActivityTypes = shareType
        share.completionWithItemsHandler = { (type, tage, array, error) in
            //
        }
        DispatchQueue.main.async {
            self.present(share, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = self.titleView
        self.setBackButton(title: "")
        self.navigationItem.rightBarButtonItems = [self.shareButton]
        self.dataSource = self
        
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }

}
extension CurveViewController: RPagingViewControllerDataSource {
    func numberOfViewController() -> Int {
        return 2
    }
    func RViewController(_ viewController: RPagingViewController, index: Int) -> UIViewController {
        let vc = CurveChildViewController.fromStoryboard()
        vc.index = index
        return vc
    }
}
