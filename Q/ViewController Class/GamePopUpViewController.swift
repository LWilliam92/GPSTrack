//
//  GamePopUpViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 23/07/2022.
//

import UIKit
import iProgressHUD

class GamePopUpViewController: UIViewController {
    enum ButtonType: Int {
        case open
        case openScheme
        case start
        case download
        case na
    }
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var currentBalanceValueLbl: UILabel!
    @IBOutlet weak var currentRebateLbl: UILabel!
    @IBOutlet weak var currentRebateValueLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UITextField!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var turnoverLbl: UILabel!
    @IBOutlet weak var rebateLbl: UILabel!
    @IBOutlet weak var lastTurnoverLbl: UILabel!
    
    @IBOutlet weak var topupBtnTitle: UILabel!
    @IBOutlet weak var startBtnTitle: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    var btnType: ButtonType = .open
    var selectedGameModel: GameCollectionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
        getLogout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupView), name: Notification.Name("UserInfoReloaded"), object: nil)
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main,
            using: { _ in
                self.getLogout()
            }
        )
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UserInfoReloaded"), object: nil)
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
        switch btnType {
        case .open, .start:
            setTransferIn()
        case .openScheme, .download:
            if let url = URL(string: btnType == .openScheme ? self.selectedGameModel?.scheme ?? "" : self.selectedGameModel?.scheme_download_url ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        case .na:
            break
        }
    }
    
    @IBAction func topUpBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("ShowPaymentScreen"), object: nil)
    }
    
    @objc func setupView() {
        guard let gameModel = CoreSingletonData.shared.gameList?.game_list?.filter({ $0.game_id == CoreSingletonData.shared.selectedGame }).first else { return }
        selectedGameModel = gameModel
        currentBalanceValueLbl.text = CoreSingletonData.shared.userInfo?.main_wallet_balance?.asCurrencyDecimal()
        currentRebateValueLbl.text = CoreSingletonData.shared.userInfo?.rolling_chip?.asCurrencyDecimal()
        
        let total = (CoreSingletonData.shared.gameList?.main_wallet_balance ?? 0) + (CoreSingletonData.shared.gameList?.rolling_chip ?? 0)
        amountLbl.text = total.asCurrencyDecimal()
        amountLbl.keyboardType = .numberPad
        amountLbl.clearButtonMode = .whileEditing
        totalLbl.text = String(format: "Total.text".localized(), total.asCurrencyDecimal())
        
        rateLbl.text = String(format: "Rate.text".localized(), selectedGameModel?.points ?? "1.00")
        rebateLbl.text = String(format: "Rebate.text".localized(), selectedGameModel?.rebate?.asDouble().asCurrencyDecimal() ?? 0.00)
        
        turnoverLbl.text = String(format: "TodayTurnover.text".localized(), selectedGameModel?.current_bet ?? "0.00")
        lastTurnoverLbl.text = String(format: "LastTurnover.text".localized(), selectedGameModel?.previous_bet ?? "0.00")
        
        if selectedGameModel?.open_ios_browser == true {
            startBtnTitle.text = "OpenButton.text".localized()
            btnType = .open
        } else {
            startBtnTitle.text = "StartButton.text".localized()
            btnType = .start
        }
        
        if selectedGameModel?.scheme?.isEmpty == false {
            if let url = URL(string: String(format: "%@://", selectedGameModel?.scheme ?? "")) {
                if UIApplication.shared.canOpenURL(url) {
                    startBtnTitle.text = "OpenButton.text".localized()
                    btnType = .openScheme
                } else {
                    startBtnTitle.text = "DownloadButton.text".localized()
                    btnType = .download
                }
            }
        }
        
        if selectedGameModel?.ios_enabled == false {
            startBtnTitle.text = "NotAvailableButton.text".localized()
            btnType = .na
        }
        
        var imageUrl = ""
        if selectedGameModel?.is_maintenance == true {
            imageUrl = selectedGameModel?.maintenance_images_v2 ?? ""
            startBtn.isEnabled = false
        } else {
            imageUrl = selectedGameModel?.image_right ?? ""
        }
        let titleImgUrl = selectedGameModel?.image_left ?? ""
        
        guard let url = URL(string: imageUrl.getEncodingUrl()),
            let titleUrl = URL(string: titleImgUrl.getEncodingUrl()) else { return }
        titleImgView.sd_setImage(with: titleUrl)
        imgView.sd_setImage(with: url)
    }
    
    func setTransferIn() {
        if let amount = amountLbl.text {
            let amountDouble = Double(amount) ?? 0
            if amountDouble > CoreSingletonData.shared.userInfo?.main_wallet_balance ?? 0 {
                showAlertView("Attention.text".localized(), "Wallet amount insufficient", controller: self, completion: nil)
            } else if amountDouble < 0 {
                showAlertView("Attention.text".localized(), "Amount cannot less than RM 0", controller: self, completion: nil)
            } else {
                view.showProgress()
                let params : [String:Any] = ["gameId":selectedGameModel?.game_id ?? "",
                                             "amount":self.amountLbl.text ?? "0"]
                AlamoFireNetworking().postWalletTransferIn(params: params) { response, error in
                    if error == nil {
                        self.view.dismissProgress()
                        if response?.status == 1 {
                            self.getGameUrl()
                        } else {
                            showAlertView("Error.text".localized(), response?.message ?? "", controller: self, completion: nil)
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
        }
    }
    
    func getGameUrl() {
        view.showProgress()
        let params : [String:Any] = ["gameId":selectedGameModel?.game_id ?? "",
                                     "language":CoreSingletonData.shared.userInfo?.language ?? "en"]
        AlamoFireNetworking().getGameUrl(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    if self.btnType == .open {
                        if let url = URL(string: response?.url ?? "") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:])
                            }
                        }
                    } else {
                        CoreSingletonData.shared.webViewType = .game
                        CoreSingletonData.shared.toOpenUrl = response?.url
                        CoreSingletonData.shared.gameHost = self.selectedGameModel?.game_name
                        self.performSegue(withIdentifier: "openWebview", sender: nil)
                    }
                } else {
                    showAlertView("Error.text".localized(), response?.message ?? "", controller: self, completion: nil)
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
    
    func getLogout() {
        view.showProgress()
        AlamoFireNetworking().getLogoutGameBalance(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                //            self.checkAPIStatus(status: response.status)
                NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
}
