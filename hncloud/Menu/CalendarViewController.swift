//
//  CalendarViewController.swift
//  hncloud
//
//  Created by 辰 on 2019/1/4.
//  Copyright © 2019 HNCloud. All rights reserved.
//

import UIKit
import CVCalendar
import JMDropMenu

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    private var currentCalendar: Calendar?
    
    @IBAction func rightAction(_ sender: Any) {
        self.calendarView.loadPreviousView()
    }
    @IBAction func leftAction(_ sender: Any) {
        self.calendarView.loadNextView()
    }
    
    lazy private var useButton: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(UIImage(named: "menu_icon"), for: .normal)
        button.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }()
    lazy private var menuFrame: CGRect = {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        let navigationHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let height: CGFloat = statusHeight + navigationHeight
        let frame = CGRect(x: self.view.width - 128, y: height, width: 120, height: 95)
        return frame
    }()
    
    @objc private func add(_ sender: UIButton) {
        JMDropMenu.showFrame(self.menuFrame, arrowOffset: 90, titleArr: ["新增用藥".localized(), "管理用藥".localized()], imageArr: ["qr_icon", "medicine_manager_icon"], type: .QQ, layoutType: .normal, rowHeight: 45, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton(title: "用藥管理".localized())
        self.navigationItem.rightBarButtonItems = [self.useButton]
        self.currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: Locale.appLanguage)
        
        self.menuView.delegate = self
        self.calendarView.delegate = self
        self.calendarTitle.text = CVDate(date: Date()).convertedDate()?.string(withFormat: "yyyy / MM")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
}
extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode { return .monthView }
    
    func dayOfWeekFont() -> UIFont { return UIFont.systemFont(ofSize: 15) }
    
    func firstWeekday() -> Weekday { return .sunday }
    
    func calendar() -> Calendar? { return currentCalendar }
    
    func weekdaySymbolType() -> WeekdaySymbolType { return .veryShort }
    
    func shouldShowWeekdaysOut() -> Bool { return true }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool { return false }
    
    func presentedDateUpdated(_ date: CVDate) {
        if calendarTitle.text != date.convertedDate()?.string(withFormat: "yyyy / MM") {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = calendarTitle.textColor
            updatedMonthLabel.font = calendarTitle.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.convertedDate()?.string(withFormat: "yyyy / MM")
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.calendarTitle.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                //self.animationFinished = false
                self.calendarTitle.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.calendarTitle.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.calendarTitle.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                //self.animationFinished = true
                self.calendarTitle.frame = updatedMonthLabel.frame
                self.calendarTitle.text = updatedMonthLabel.text
                self.calendarTitle.transform = CGAffineTransform.identity
                self.calendarTitle.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.calendarTitle)
        }
    }
}
extension CalendarViewController: JMDropMenuDelegate {
    func didSelectRow(at index: Int, title: String!, image: String!) {
        if index == 0 {
            let vc = SearchMedicineViewController.fromStoryboard()
            self.push(vc: vc)
        } else {
            
        }
    }
}
