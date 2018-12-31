//
//  HeartCurveViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/29.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class HeartCurveViewController: UIViewController {

    lazy private var shareButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_share"), for: .normal)
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var curveButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "main_trend"), for: .normal)
        button.addTarget(self, action: #selector(curve), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    lazy private var titleView: UIView = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        leftImage.center = CGPoint(x: 15, y: 15)
        leftImage.image = UIImage(named: "provios")
        leftButton.addSubview(leftImage)
        view.leftView = leftButton
        view.leftViewMode = .always
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        rightImage.center = CGPoint(x: 15, y: 15)
        rightImage.image = UIImage(named: "next")
        rightButton.addSubview(rightImage)
        view.rightView = rightButton
        view.rightViewMode = .always
        view.text = "12.25 週四"
        view.textAlignment = .center
        view.delegate = self
        return view
    }()
    
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
    // 曲線圖
    @objc private func curve() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "")
        self.navigationItem.titleView = self.titleView
        self.navigationItem.rightBarButtonItems = [self.shareButton, self.curveButton]
    }
}
extension HeartCurveViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let selectDate = textField.text?.date(withFormat: "yyyy-MM-dd") ?? Date()
        ActionSheetDatePicker.init(title: "",
                                   datePickerMode: .date,
                                   selectedDate: selectDate,
                                   doneBlock: { (picker, date, origin) in
                                    //textField.text = (date as? Date)?.dateString("yyyy-MM-dd")
        },
                                   cancel: { (picker) in
                                    
        },
                                   origin: textField).show()
        return false
    }
}
