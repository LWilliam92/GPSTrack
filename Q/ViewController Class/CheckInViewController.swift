//
//  CheckInViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 21/08/2022.
//

import Foundation
import UIKit
import iProgressHUD

class CheckInViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var checkInMessage: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    
    @IBOutlet weak var dayView1: UIView!
    @IBOutlet weak var dayLabel1: UILabel!
    @IBOutlet weak var dayImageView1: UIImageView!
    @IBOutlet weak var dayView2: UIView!
    @IBOutlet weak var dayLabel2: UILabel!
    @IBOutlet weak var dayImageView2: UIImageView!
    @IBOutlet weak var dayView3: UIView!
    @IBOutlet weak var dayLabel3: UILabel!
    @IBOutlet weak var dayImageView3: UIImageView!
    @IBOutlet weak var dayView4: UIView!
    @IBOutlet weak var dayLabel4: UILabel!
    @IBOutlet weak var dayImageView4: UIImageView!
    @IBOutlet weak var dayView5: UIView!
    @IBOutlet weak var dayLabel5: UILabel!
    @IBOutlet weak var dayImageView5: UIImageView!
    @IBOutlet weak var dayView6: UIView!
    @IBOutlet weak var dayLabel6: UILabel!
    @IBOutlet weak var dayImageView6: UIImageView!
    @IBOutlet weak var dayView7: UIView!
    @IBOutlet weak var dayLabel7: UILabel!
    @IBOutlet weak var dayImageView7: UIImageView!
    
    @IBOutlet weak var week1CheckinImageView: UIImageView!
    @IBOutlet weak var week2CheckinImageView: UIImageView!
    @IBOutlet weak var week3CheckinImageView: UIImageView!
    @IBOutlet weak var week4CheckinImageView: UIImageView!
    
    @IBOutlet weak var checkInButtonImageView: UIImageView!
    @IBOutlet weak var checkInButtonLabel: UILabel!
    
    @IBOutlet weak var checkInAchieveView: UIView!
    @IBOutlet weak var checkInAchieveTitleLbl: UILabel!
    @IBOutlet weak var checkInAchieveAmountLbl: UILabel!
    
    var dailyReward: DailyRewardDetailModel?
    var isTodayCheckedIn: Bool?
    var currentWeek: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCheckInInfo()
    }

    func getCheckInInfo() {
        view.showProgress()
        AlamoFireNetworking().getDailyReward(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.dailyReward = response
                self.setupCheckInView()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func postDailyManualCheckIn() {
        view.showProgress()
        AlamoFireNetworking().postDailyManualCheckIn(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.postClaimDailyCheckIn()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func postClaimDailyCheckIn() {
        view.showProgress()
        let currentDay = self.currentDayLabel.text?.asInt() ?? 0
        let params : [String:Any] = ["dailyCheckInDays":(currentDay + 1)]
        AlamoFireNetworking().postClaimDailyCheckIn(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    self.showCheckInAchievedView()
                } else {
                    self.getCheckInInfo()
                }
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func setupCheckInView() {
        guard let dailyReward = self.dailyReward else { return }
        if dailyReward.claimed_for_7_days == true {
            week1CheckinImageView.image = .checkInWeek1Active
        }
        if dailyReward.claimed_for_14_days == true {
            week2CheckinImageView.image = .checkInWeek2Active
        }
        if dailyReward.claimed_for_21_days == true {
            week3CheckinImageView.image = .checkInWeek3Active
        }
        if dailyReward.claimed_for_28_days == true {
            week4CheckinImageView.image = .checkInWeek4Active
        }
        
        let currentLoginDays = dailyReward.current_login_days ?? 0
        currentWeek = 1
        var day1 = "1"
        var day2 = "7"
        if currentLoginDays > 21 {
            currentWeek = 4
            day1 = "22"
            day2 = "28"
        } else if currentLoginDays > 14 {
            currentWeek = 3
            day1 = "15"
            day2 = "21"
        } else if currentLoginDays > 7 {
            currentWeek = 2
            day1 = "8"
            day2 = "14"
        }
        
        var extraDay = 0
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let todayDayStr = dateFormatter.string(from: todayDate)
        if todayDayStr != dailyReward.last_day {
            extraDay = 1
            isTodayCheckedIn = false
        } else {
            isTodayCheckedIn = true
            checkInButtonLabel.textColor = .checkInButtonFontColor
            checkInButtonImageView.image = .checkInBackgroundDone
        }
        
        currentDayLabel.text = String(format: "%02d", currentLoginDays + extraDay)
        weekLabel.text = String(format: "CheckIn.week.text".localized(), currentWeek?.asStringDigit() ?? 1)
        checkInMessage.text = String(format: "CheckIn.week.description".localized(), day1, day2)
        
        let dayLabel = 7 * ((currentWeek ?? 1) - 1)
        let day1Label = 1 + dayLabel
        let day2Label = 2 + dayLabel
        let day3Label = 3 + dayLabel
        let day4Label = 4 + dayLabel
        let day5Label = 5 + dayLabel
        let day6Label = 6 + dayLabel
        let day7Label = 7 + dayLabel
        
        dayLabel1.text = String(format: "CheckIn.Day.text".localized(), day1Label.asStringDigit())
        dayLabel2.text = String(format: "CheckIn.Day.text".localized(), day2Label.asStringDigit())
        dayLabel3.text = String(format: "CheckIn.Day.text".localized(), day3Label.asStringDigit())
        dayLabel4.text = String(format: "CheckIn.Day.text".localized(), day4Label.asStringDigit())
        dayLabel5.text = String(format: "CheckIn.Day.text".localized(), day5Label.asStringDigit())
        dayLabel6.text = String(format: "CheckIn.Day.text".localized(), day6Label.asStringDigit())
        dayLabel7.text = String(format: "CheckIn.Day.text".localized(), day7Label.asStringDigit())
        
        if day1Label <= currentLoginDays {
            dayImageView1.image = .checkInDailyAchieved
            dayView1.backgroundColor = .checkInBackgroundActiveColor
            dayLabel1.textColor = .checkInDayActiveFontColor
        }
        if day2Label <= currentLoginDays {
            dayImageView2.image = .checkInDailyAchieved
            dayView2.backgroundColor = .checkInBackgroundActiveColor
            dayLabel2.textColor = .checkInDayActiveFontColor
        }
        if day3Label <= currentLoginDays {
            dayImageView3.image = .checkInDailyAchieved
            dayView3.backgroundColor = .checkInBackgroundActiveColor
            dayLabel3.textColor = .checkInDayActiveFontColor
        }
        if day4Label <= currentLoginDays {
            dayImageView4.image = .checkInDailyAchieved
            dayView4.backgroundColor = .checkInBackgroundActiveColor
            dayLabel4.textColor = .checkInDayActiveFontColor
        }
        if day5Label <= currentLoginDays {
            dayImageView5.image = .checkInDailyAchieved
            dayView5.backgroundColor = .checkInBackgroundActiveColor
            dayLabel5.textColor = .checkInDayActiveFontColor
        }
        if day6Label <= currentLoginDays {
            dayImageView6.image = .checkInDailyAchieved
            dayView6.backgroundColor = .checkInBackgroundActiveColor
            dayLabel6.textColor = .checkInDayActiveFontColor
        }
        if day7Label <= currentLoginDays {
            dayImageView7.image = .checkInDailyDay7
            dayView7.backgroundColor = .checkInBackgroundActiveColor
            dayLabel7.textColor = .checkInDayActiveFontColor
        }
        loadingView.isHidden = true
    }
    
    @IBAction func checkInClicked(_ sender: Any) {
        if isTodayCheckedIn == false {
            self.postDailyManualCheckIn()
        }
    }
    
    @IBAction func checkInAchievedCloseBtnClicked(_ sender: Any) {
        checkInAchieveView.isHidden = true
        self.getCheckInInfo()
    }
    
    func showCheckInAchievedView() {
        guard let dailyReward = dailyReward else {
            return
        }

        checkInAchieveView.isHidden = false
        checkInAchieveTitleLbl.text = String(format: "CheckIn.Achieve.text".localized(), weekLabel.text!)
        var checkInAchieveAmount = 0
        switch currentWeek {
        case 1:
            checkInAchieveAmount = dailyReward.reward_for_7_days ?? 0
        case 2:
            checkInAchieveAmount = dailyReward.reward_for_14_days ?? 0
        case 3:
            checkInAchieveAmount = dailyReward.reward_for_21_days ?? 0
        case 4:
            checkInAchieveAmount = dailyReward.reward_for_28_days ?? 0
        default:
            checkInAchieveAmount = dailyReward.reward_for_7_days ?? 0
        }
        
        checkInAchieveAmountLbl.text = String(format: "Currency.Amount.text".localized(), checkInAchieveAmount)
    }
}
