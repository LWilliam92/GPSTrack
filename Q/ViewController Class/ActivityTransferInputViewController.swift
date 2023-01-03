//
//  ActivityTransferInputViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 02/11/2022.
//

import Foundation
import UIKit
import iProgressHUD

class ActivityTransferInputViewController: UIViewController {
    
    @IBOutlet weak var ownBalance: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var popUpTitleLabel: UILabel!
    @IBOutlet weak var popUpDescLabel: UILabel!
    @IBOutlet weak var popUpAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupView()
    }
    
    func setupView() {
        self.ownBalance.text = CoreSingletonData.shared.userInfo?.main_wallet_balance?.asCurrencyDecimal()
        self.ownBalance.isUserInteractionEnabled = false
        if CoreSingletonData.shared.scannedUsername.isEmptyOrNil == false {
            self.username.text = CoreSingletonData.shared.scannedUsername
            self.username.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.username.resignFirstResponder()
        self.amount.resignFirstResponder()
        if self.username.text.isEmptyOrNil == false &&
            self.amount.text.isEmptyOrNil == false {
            transfer()
        }
    }
    
    @IBAction func closePopUpClicked(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func transfer() {
        guard let username = self.username.text, let amount = self.amount.text else {
            return
        }
        view.showProgress()
        let params : [String:Any] = ["userName":username,
                                     "amount": amount]
        AlamoFireNetworking().postTransferCredit(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                //            self.checkAPIStatus(status: response.status)
                if response?.status == 1 {
                    self.popUpView.isHidden = false
                    self.popUpImage.image = .transferSuccess
                    self.popUpTitleLabel.text = "Transfer.success.title".localized()
                    self.popUpTitleLabel.textColor = .transferSuccess
                    self.popUpDescLabel.text = String(format: "Transfer.success.text".localized(), username)
                    self.popUpAmountLabel.text = amount.asDouble().asCurrencyDecimal()
                } else {
                    self.popUpView.isHidden = false
                    self.popUpImage.image = .transferFail
                    self.popUpTitleLabel.text = "Transfer.fail.text".localized()
                    self.popUpTitleLabel.textColor = .transferFail
                    self.popUpDescLabel.text = String(format: "Transfer.fail.text".localized(), username)
                    self.popUpAmountLabel.text = amount.asDouble().asCurrencyDecimal()
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
