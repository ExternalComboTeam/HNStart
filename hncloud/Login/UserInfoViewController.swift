//
//  UserInfoViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var addImage: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountStackView: UIStackView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    lazy private var finishedButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "完成".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishedEdit))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "個人資料".localized())
        self.navigationItem.rightBarButtonItem = self.finishedButton
        self.navigationController?.navigationItem.rightBarButtonItems = [self.finishedButton]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sexSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.unitSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.sexSegment.layer.borderColor = UIColor.black.cgColor
        self.unitSegment.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc private func finishedEdit() {
        let vc = BMIInfoViewController.fromStoryboard()
        self.push(vc: vc)
    }
}
