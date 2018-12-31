//
//  UserInfoViewController.swift
//  hncloud
//
//  Created by 辰 on 2018/12/25.
//  Copyright © 2018 HNCloud. All rights reserved.
//

import UIKit
import SwifterSwift
import KRProgressHUD
import ActionSheetPicker_3_0

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
    @IBOutlet weak var sysTextField: UITextField!
    @IBOutlet weak var diaTextField: UITextField!
    
    lazy private var finishedButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "完成".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishedEdit))
    }()
    lazy private var editButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        let image = UIImage(named: "edit_info")?.scaled(toHeight: 25)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    
    var isEdit: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton(title: "個人資料".localized())
        self.navigationItem.hidesBackButton = !UserInfo.share.isLogin
        self.navigationItem.rightBarButtonItem = self.isEdit ? self.finishedButton : self.editButton
        self.accountLabel.text = UserInfo.share.account
        self.accountLabel.isHidden = self.isEdit
        self.addImage.isHidden = !self.isEdit
        
        self.pictureButton.isEnabled = self.isEdit
        self.nickNameTextField.isEnabled = self.isEdit
        self.sexSegment.isEnabled = self.isEdit
        self.sexSegment.selectedSegmentIndex = UserInfo.share.gender == .male ? 0 : 1
        self.unitSegment.isEnabled = self.isEdit
        self.unitSegment.selectedSegmentIndex = UserInfo.share.unit == "0" ? 0 : 1
        self.birthdayTextField.isEnabled = self.isEdit
        self.birthdayTextField.delegate = self
        self.heightTextField.isEnabled = self.isEdit
        self.weightTextField.isEnabled = self.isEdit
        self.sysTextField.isEnabled = self.isEdit
        self.diaTextField.isEnabled = self.isEdit
        self.sysTextField.delegate = self
        self.diaTextField.delegate = self
        
        let imageFrame: CGRect = CGRect(x: 0, y: 0, width: 45, height: 25)
        let nickImage = UIImageView(frame: imageFrame)
        nickImage.contentMode = .scaleAspectFit
        nickImage.image = UIImage(named: "head_icon_small")
        self.nickNameTextField.leftView = nickImage
        self.nickNameTextField.leftViewMode = .always
        self.nickNameTextField.text = UserInfo.share.nickName
        
        let birthdayImage = UIImageView(frame: imageFrame)
        birthdayImage.image = UIImage(named: "birthday_icon")
        birthdayImage.contentMode = .scaleAspectFit
        self.birthdayTextField.leftView = birthdayImage
        self.birthdayTextField.leftViewMode = .always
        self.birthdayTextField.text = UserInfo.share.birthday
        
        let heightImage = UIImageView(frame: imageFrame)
        heightImage.image = UIImage(named: "height_icon")
        heightImage.contentMode = .scaleAspectFit
        self.heightTextField.leftView = heightImage
        self.heightTextField.leftViewMode = .always
        self.heightTextField.text = UserInfo.share.height
        
        let weightImage = UIImageView(frame: imageFrame)
        weightImage.image = UIImage(named: "weight_icon")
        weightImage.contentMode = .scaleAspectFit
        self.weightTextField.leftView = weightImage
        self.weightTextField.leftViewMode = .always
        self.weightTextField.text = UserInfo.share.weight
        /*
        guard !self.isEdit else { return }
        DispatchQueue.main.async {
            let vc = UserInfoViewController.fromStoryboard()
            self.push(vc: vc)
        }
        */
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sexSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.unitSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.sexSegment.layer.borderColor = UIColor.black.cgColor
        self.unitSegment.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc private func finishedEdit() {
        guard let name = self.nickNameTextField.text, let birthday = self.birthdayTextField.text,
            let width = self.weightTextField.text, let height = self.heightTextField.text else { return }
        KRProgressHUD.show()
        UserInfoAPI.update(nickName: name, gender: sexSegment.selectedSegmentIndex == 0 ? .male : .women, birthday: birthday, height: Int(height) ?? 0, width: Int(width) ?? 0, unit: unitSegment.selectedSegmentIndex == 0 ? "0" : "1") { (json) in
            KRProgressHUD.dismiss()
            UserInfo.share.update(json: json)
            let vc = BMIInfoViewController.fromStoryboard()
            self.push(vc: vc)
        }
    }
    @objc private func edit() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(title: "修改資料".localized(), style: .default, isEnabled: true, handler: { [weak self] (sheet) in
            guard let `self` = self else { return }
            let vc = UserInfoViewController.fromStoryboard()
            self.push(vc: vc)
        })
        sheet.addAction(title: "修改密碼".localized(), style: .default, isEnabled: true) { (sheet) in
            let vc = ModifyPasswordViewController.fromStoryboard()
            self.push(vc: vc)
        }
        sheet.addAction(title: "取消".localized(), style: .cancel, isEnabled: true, handler: { (sheet) in
            print("cancel")
        })
        self.present(sheet, animated: true, completion: nil)
    }
}
extension UserInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case sysTextField, diaTextField:
            textField.resignFirstResponder()
            let vc = BloodPressureViewController.fromStoryboard()
            self.present(vc, animated: false, completion: nil)
            return false
        case birthdayTextField:
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
        default:
            return true
        }
    }
}
