//
//  RebateInfoViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 28/09/2022.
//

import UIKit
import iProgressHUD

class RebateInfoViewController: UIViewController {
    
    @IBOutlet weak var newRegisterLbl: UILabel!
    @IBOutlet weak var activePlayerLbl: UILabel!
    @IBOutlet weak var totalPlayerLbl: UILabel!
    @IBOutlet weak var downlineTurnoverLbl: UILabel!
    @IBOutlet weak var downlineRebateLbl: UILabel!
    @IBOutlet weak var userOwnRebateLbl: UILabel!
    @IBOutlet weak var userTotalRebateLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRebateInfo()
    }
    
    func getRebateInfo() {
        view.showProgress()
        AlamoFireNetworking().getRebateInfo(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.newRegisterLbl.text = response?.new_register?.asStringDigit()
                self.activePlayerLbl.text = response?.active_player?.asStringDigit()
                self.totalPlayerLbl.text = response?.total_player?.asStringDigit()
                self.downlineTurnoverLbl.text = response?.downline_total_turnover?.asStringDigit()
                self.downlineRebateLbl.text = response?.direct_referrer_rebate?.asCurrencyDecimal()
                self.userOwnRebateLbl.text = response?.user_own_rebate?.asCurrencyDecimal()
                self.userTotalRebateLbl.text = response?.user_total_rebate?.asCurrencyDecimal()
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
