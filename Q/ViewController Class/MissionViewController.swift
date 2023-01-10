//
//  MissionViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 26/08/2022.
//

import Foundation
import UIKit
import iProgressHUD

@objc class MissionViewController: UIViewController {
    
    @IBOutlet weak var missionTableView: UITableView!
    
    @IBOutlet weak var announcementLbl: UILabel!
    
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var depositAmtLabel: UILabel!
    @IBOutlet weak var turnoverLabel: UILabel!
    @IBOutlet weak var turnoverAmtLabel: UILabel!
    
    @IBOutlet weak var dailyBtnTitle: UILabel!
    @IBOutlet weak var weeklyBtnTitle: UILabel!
    @IBOutlet weak var monthlyBtnTitle: UILabel!
    
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var weeklyImageView: UIImageView!
    @IBOutlet weak var monthlyImageView: UIImageView!
    
    @IBOutlet weak var dailyPillView: UIView!
    @IBOutlet weak var weeklyPillView: UIView!
    @IBOutlet weak var monthlyPillView: UIView!
    
    @IBOutlet weak var loadingView: UIView!
    
    var currentViewSegment: Int = 0
    var missionDetail: MissionRewardDetailModel?
    var dailyMissionList: [MissionDetailModel]?
    var weeklyMissionList: [MissionDetailModel]?
    var monthlyMissionList: [MissionDetailModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
        getBetRewardDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.missionButtonClicked), name: Notification.Name("MissionButtonClicked"), object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MissionButtonClicked"), object: nil)
    }
    
    func setupView() {
        let bundle = Bundle(for: MissionTableViewCell.self)
        let tableNib = UINib(nibName: "MissionTableViewCell", bundle: bundle)
        
        missionTableView.register(tableNib, forCellReuseIdentifier: MissionTableViewCell.reuseIdentifier())
        missionTableView.dataSource = self
        missionTableView.delegate = self
        loadingView.isHidden = false
    }
    
    @IBAction func dailyBtnClicked(_ sender: Any) {
        currentViewSegment = 0
        updateSegment()
    }
    
    @IBAction func weeklyBtnClicked(_ sender: Any) {
        currentViewSegment = 1
        updateSegment()
    }
    
    @IBAction func monthlyBtnClicked(_ sender: Any) {
        currentViewSegment = 2
        updateSegment()
    }
    
    func updateSegment() {
        switch currentViewSegment {
        case 0:
            dailyPillView.backgroundColor = .clear
            weeklyPillView.backgroundColor = .white
            monthlyPillView.backgroundColor = .white
            
            dailyBtnTitle.textColor = .segmentActive
            weeklyBtnTitle.textColor = .segmentInactive
            monthlyBtnTitle.textColor = .segmentInactive
            
            dailyImageView.isHidden = false
            weeklyImageView.isHidden = true
            monthlyImageView.isHidden = true
            
            depositLabel.text = String(format: "Mission.deposit.text".localized(), "Mission.daily.text".localized())
            turnoverLabel.text = String(format: "Mission.turnover.text".localized(), "Mission.daily.text".localized())
            depositAmtLabel.text = missionDetail?.daily_deposit?.asCurrencyDecimal()
            turnoverAmtLabel.text = missionDetail?.daily_turnover?.asCurrencyDecimal(false)
        case 1:
            dailyPillView.backgroundColor = .white
            weeklyPillView.backgroundColor = .clear
            monthlyPillView.backgroundColor = .white
            
            dailyBtnTitle.textColor = .segmentInactive
            weeklyBtnTitle.textColor = .segmentActive
            monthlyBtnTitle.textColor = .segmentInactive
            
            dailyImageView.isHidden = true
            weeklyImageView.isHidden = false
            monthlyImageView.isHidden = true
            
            depositLabel.text = String(format: "Mission.deposit.text".localized(), "Mission.weekly.text".localized())
            turnoverLabel.text = String(format: "Mission.turnover.text".localized(), "Mission.weekly.text".localized())
            depositAmtLabel.text = missionDetail?.weekly_deposit?.asCurrencyDecimal()
            turnoverAmtLabel.text = missionDetail?.weekly_turnover?.asCurrencyDecimal()
        case 2:
            dailyPillView.backgroundColor = .white
            weeklyPillView.backgroundColor = .white
            monthlyPillView.backgroundColor = .clear
            
            dailyBtnTitle.textColor = .segmentInactive
            weeklyBtnTitle.textColor = .segmentInactive
            monthlyBtnTitle.textColor = .segmentActive
            
            dailyImageView.isHidden = true
            weeklyImageView.isHidden = true
            monthlyImageView.isHidden = false
            
            depositLabel.text = String(format: "Mission.deposit.text".localized(), "Mission.monthly.text".localized())
            turnoverLabel.text = String(format: "Mission.turnover.text".localized(), "Mission.monthly.text".localized())
            depositAmtLabel.text = missionDetail?.monthly_deposit?.asCurrencyDecimal()
            turnoverAmtLabel.text = missionDetail?.monthly_turnover?.asCurrencyDecimal()
        default:
            dailyPillView.backgroundColor = .clear
            weeklyPillView.backgroundColor = .white
            monthlyPillView.backgroundColor = .white
            
            dailyBtnTitle.textColor = .segmentActive
            weeklyBtnTitle.textColor = .segmentInactive
            monthlyBtnTitle.textColor = .segmentInactive
            
            dailyImageView.isHidden = false
            weeklyImageView.isHidden = true
            monthlyImageView.isHidden = true
            
            depositLabel.text = String(format: "Mission.deposit.text".localized(), "Mission.daily.text".localized())
            turnoverLabel.text = String(format: "Mission.turnover.text".localized(), "Mission.daily.text".localized())
            depositAmtLabel.text = missionDetail?.daily_deposit?.asCurrencyDecimal()
            turnoverAmtLabel.text = missionDetail?.daily_turnover?.asCurrencyDecimal()
        }
        self.missionTableView.reloadData()
        
        loadingView.isHidden = true
    }
    
    func getBetRewardDetail() {
        view.showProgress()
        AlamoFireNetworking().getBetRewardDetails(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.missionDetail = response
                self.announcementLbl.text = response?.announcement
                self.dailyMissionList = response?.daily
                self.weeklyMissionList = response?.weekly
                self.monthlyMissionList = response?.monthly
                self.updateSegment()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    @objc func missionButtonClicked() {
        if CoreSingletonData.shared.selectedMission != 0 {
            var missionList: [MissionDetailModel]?
            switch currentViewSegment {
            case 0:
                missionList = dailyMissionList
            case 1:
                missionList = weeklyMissionList
            case 2:
                missionList = monthlyMissionList
            default:
                missionList = dailyMissionList
            }
            
            let missionDetail = missionList?.filter { $0.mission_id == CoreSingletonData.shared.selectedMission }.first
            if missionDetail?.is_completed == true && missionDetail?.is_claimed == false {
                let params : [String:Any] = ["missionId":missionDetail?.mission_id ?? ""]
                view.showProgress()
                AlamoFireNetworking().postClaimBetReward(params: params) { response, error in
                    if error == nil {
                        self.view.dismissProgress()
                        if response?.status == 1 {
                            self.getBetRewardDetail()
                        }
                    } else {
                        self.view.dismissProgress()
                        showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                            guard self != nil else { return }
                            performLogout()
                        })
                    }
                }
            } else if missionDetail?.is_deposit == true {
                self.dismiss(animated: true)
                NotificationCenter.default.post(name: Notification.Name("ShowPaymentScreen"), object: nil)
            } else if missionDetail?.is_refer == true {
                self.performSegue(withIdentifier: "referralQR", sender: nil)
            } else if missionDetail?.game_details != nil {
                CoreSingletonData.shared.selectedGame = missionDetail?.game_id ?? 0
                performSegue(withIdentifier: "gamePopUp", sender: nil)

//                let params : [String:Any] = ["gameId":missionDetail?.game_details?.game_id ?? "",
//                                             "language":CoreSingletonData.shared.userInfo?.language ?? "en"]
//                view.showProgress()
//                AlamoFireNetworking().getGameUrl(params: params) { result in
//                    self.view.dismissProgress()
//                    if result.status == 1 {                CoreSingletonData.shared.webViewType = .mission
//                        CoreSingletonData.shared.toOpenUrl = result.url
//                        CoreSingletonData.shared.gameHost = missionDetail?.game_details?.game_name
//                        self.performSegue(withIdentifier: "openWebview", sender: nil)
//                    }
//                }
            }
        }
    }
}

extension MissionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentViewSegment {
        case 0:
            return dailyMissionList?.count ?? 0
        case 1:
            return weeklyMissionList?.count ?? 0
        case 2:
            return monthlyMissionList?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var missionDetail: MissionDetailModel?
        switch currentViewSegment {
        case 0:
            missionDetail = dailyMissionList?[indexPath.row]
        case 1:
            missionDetail = weeklyMissionList?[indexPath.row]
        case 2:
            missionDetail = monthlyMissionList?[indexPath.row]
        default:
            missionDetail = dailyMissionList?[indexPath.row]
        }
        
        guard let item = missionDetail,
              let cell = self.missionTableView.dequeueReusableCell(withIdentifier: MissionTableViewCell.reuseIdentifier()) as? MissionTableViewCell else { return UITableViewCell() }

        cell.setCell(item: item)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
