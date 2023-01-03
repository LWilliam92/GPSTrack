//
//  PaymentViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 07/07/2022.
//

import Foundation
import UIKit
import EFQRCode
import iProgressHUD
import DPOTPView

class PaymentViewController: UIViewController {
    
    var currentPaymentSection: Int = 1
    
    @IBOutlet weak var paymentGatewayView: UIView!
    @IBOutlet weak var paymentGatewayLabel: UILabel!
    @IBOutlet weak var paymentGatewayBackground: UIImageView!
    @IBOutlet weak var paymentGatewayIcon: UIImageView!
    
    @IBOutlet weak var bankTransferView: UIView!
    @IBOutlet weak var bankTransferLabel: UILabel!
    @IBOutlet weak var bankTransferBackground: UIImageView!
    @IBOutlet weak var bankTransferIcon: UIImageView!
    
    @IBOutlet weak var touchNGoView: UIView!
    @IBOutlet weak var touchNGoLabel: UILabel!
    @IBOutlet weak var touchNGoBackground: UIImageView!
    @IBOutlet weak var touchNGoIcon: UIImageView!
    
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var withdrawLabel: UILabel!
    @IBOutlet weak var withdrawBackground: UIImageView!
    @IBOutlet weak var withdrawIcon: UIImageView!
    
    @IBOutlet weak var pgBankCollectionView: UICollectionView!
    var pgSelectedBankId: Int = -1
    @IBOutlet weak var pgAmountTextField: UITextField!
    
    @IBOutlet weak var btBankName: UILabel!
    @IBOutlet weak var btBankCollectionView: UICollectionView!
    var btSelectedBankId: Int = -1
    
    @IBOutlet weak var tngImageView: UIImageView!
    @IBOutlet weak var tngAmountTextField: UITextField!
    
    @IBOutlet weak var withdrawBankCollectionView: UICollectionView!
    @IBOutlet weak var withdrawAmountTextField: UITextField!
    @IBOutlet weak var withdrawTermsLabel: UILabel!
    var withdrawSelectedBankId: Int = -1
    
    @IBOutlet weak var otpPinView: UIView!
    @IBOutlet weak var otpPinLabel: UILabel!
    @IBOutlet weak var otpPinTextView: DPOTPView!
    
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    var bankTransferDetailList: [DepositBankDetailModel]?
    var paymentGatewayDetailList: [DepositBankDetailModel]?
    var touchNGoDetail: DepositBankDetailModel?
    var withdrawBankList: [BankInfoModel]?
    var withdrawalRecord: WithdrawalModel?
    var isSetupPaymentPin: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupObserver()
        setupView()
        setupPaymentSection()
        pgAmountTextField.keyboardType = .numberPad
        withdrawAmountTextField.keyboardType = .numberPad
        tngAmountTextField.keyboardType = .numberPad
        pgAmountTextField.clearButtonMode = .whileEditing
        tngAmountTextField.clearButtonMode = .whileEditing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getDepositBankInList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDepositBankInList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDepositBankInList), name: Notification.Name("UserInfoReloaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteWithdrawAccount), name: Notification.Name("DeleteWithdrawAccount"), object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UserInfoReloaded"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DeleteWithdrawAccount"), object: nil)
    }
    
    func setupView() {
        let bundle = Bundle(for: DepositBankViewCollectionCell.self)
        let depositCollectionNib = UINib(nibName: "DepositBankViewCollectionCell", bundle: bundle)
        let withdrawCollectionNib = UINib(nibName: "WithdrawBankViewCollectionCell", bundle: bundle)
        pgBankCollectionView.register(depositCollectionNib, forCellWithReuseIdentifier: DepositBankViewCollectionCell.reuseIdentifier())
        pgBankCollectionView.dataSource = self
        pgBankCollectionView.delegate = self
        
        btBankCollectionView.register(depositCollectionNib, forCellWithReuseIdentifier: DepositBankViewCollectionCell.reuseIdentifier())
        btBankCollectionView.dataSource = self
        btBankCollectionView.delegate = self
        
        withdrawBankCollectionView.register(withdrawCollectionNib, forCellWithReuseIdentifier: WithdrawBankViewCollectionCell.reuseIdentifier())
        withdrawBankCollectionView.dataSource = self
        withdrawBankCollectionView.delegate = self
    }

    @IBAction func paymentSectionClicked(_ sender: UIButton) {
        currentPaymentSection = sender.tag
        setupPaymentSection()
    }
    
    @IBAction func refreshClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
    }
    
    func setupPaymentSection() {
        resetPaymentSectionView()
        switch currentPaymentSection {
        case 1:
            DispatchQueue.main.async {
                self.paymentGatewayLabel.textColor = .fontActive
                self.paymentGatewayIcon.image = .paymentGatewaySelected
                self.paymentGatewayBackground.image = .paymentTypeSelected
                self.paymentGatewayView.isHidden = false
            }
        case 2:
            DispatchQueue.main.async {
                self.bankTransferLabel.textColor = .fontActive
                self.bankTransferIcon.image = .bankTransferSelected
                self.bankTransferBackground.image = .paymentTypeSelected
                self.bankTransferView.isHidden = false
            }
        case 3:
            DispatchQueue.main.async {
                self.touchNGoLabel.textColor = .fontActive
                self.touchNGoIcon.image = .touchNGoSelected
                self.touchNGoBackground.image = .paymentTypeSelected
                self.touchNGoView.isHidden = false
            }
        case 4:
            DispatchQueue.main.async {
                self.withdrawLabel.textColor = .fontActive
                self.withdrawIcon.image = .withdrawSelected
                self.withdrawBackground.image = .paymentTypeSelected
                self.withdrawView.isHidden = false
            }
        default:
            break;
        }
    }
    
    func resetPaymentSectionView() {
        DispatchQueue.main.async {
            self.paymentGatewayLabel.textColor = .paymentFontInactive
            self.paymentGatewayIcon.image = .paymentGateway
            self.paymentGatewayBackground.image = .paymentType
            self.paymentGatewayView.isHidden = true
            self.pgAmountTextField.text = ""
        }
        if paymentGatewayDetailList?.count ?? 0 > 0 {
            pgSelectedBankId = paymentGatewayDetailList?.first?.bank_id ?? -1
        } else {
            pgSelectedBankId = -1
        }
        
        DispatchQueue.main.async {
            self.bankTransferLabel.textColor = .paymentFontInactive
            self.bankTransferIcon.image = .bankTransfer
            self.bankTransferBackground.image = .paymentType
            self.bankTransferView.isHidden = true
        }
        if bankTransferDetailList?.count ?? 0 > 0 {
            btSelectedBankId = bankTransferDetailList?.first?.bank_id ?? -1
        } else {
            btSelectedBankId = -1
        }
        
        DispatchQueue.main.async {
            self.touchNGoLabel.textColor = .paymentFontInactive
            self.touchNGoIcon.image = .touchNGo
            self.touchNGoBackground.image = .paymentType
            self.touchNGoView.isHidden = true
            self.tngAmountTextField.text = ""
        }
        
        DispatchQueue.main.async {
            self.withdrawLabel.textColor = .paymentFontInactive
            self.withdrawIcon.image = .withdraw
            self.withdrawBackground.image = .paymentType
            self.withdrawView.isHidden = true
            self.withdrawAmountTextField.text = ""
        }
        if withdrawBankList?.count ?? 0 > 0 {
            withdrawSelectedBankId = withdrawBankList?.first?.users_bank_account_id ?? -1
        } else {
            withdrawSelectedBankId = -1
        }
    }
    
    @objc func getDepositBankInList() {
        view.showProgress()
        AlamoFireNetworking().getDepositBankInList(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.bankTransferDetailList = response?.bank_transfer_list
                self.paymentGatewayDetailList = response?.payment_gateway_list
                self.touchNGoDetail = response?.touch_and_go_details
                self.withdrawBankList = CoreSingletonData.shared.userInfo?.bank_list
                self.getExistingWithdrawalRecord()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func getExistingWithdrawalRecord() {
        view.showProgress()
        AlamoFireNetworking().getExistingWithdrawalRecord(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.withdrawalRecord = response?.data
                self.setupData()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func setupData() {
        let withdrawAddModel = BankInfoModel(users_bank_account_id: -1, bank_id: -1, bank_name: "AddBank.text".localized(), bank_account_no: "", bank_account_holder: "")
        withdrawBankList?.append(withdrawAddModel)
        
        withdrawTermsLabel.text = String(format: "Terms.Withdrawal.text".localized(), withdrawalRecord?.free_withdraw_times?.asStringDigit() ?? "3", withdrawalRecord?.services_charge ?? "0.00")
        
        accountBalanceLabel.text = CoreSingletonData.shared.userInfo?.main_wallet_balance?.asCurrencyDecimal()
        if bankTransferDetailList?.count ?? 0 > 0 {
            btSelectedBankId = bankTransferDetailList?.first?.bank_id ?? -1
            btBankName.text = bankTransferDetailList?.first?.bank_name
        }
        if paymentGatewayDetailList?.count ?? 0 > 0 {
            pgSelectedBankId = paymentGatewayDetailList?.first?.bank_id ?? -1
        }
        if withdrawBankList?.count ?? 0 > 0 {
            withdrawSelectedBankId = withdrawBankList?.first?.users_bank_account_id ?? -1
        }
        btBankCollectionView.reloadData()
        pgBankCollectionView.reloadData()
        withdrawBankCollectionView.reloadData()
        if let image = EFQRCode.generate(
            for: touchNGoDetail?.qr_code_url ?? ""
        ) {
            print("Create QRCode image success \(image)")
            DispatchQueue.main.async {
                self.tngImageView.image = UIImage(cgImage: image)
            }
        } else {
            print("Create QRCode image failed!")
        }
        
        if CoreSingletonData.shared.userInfo?.is_payment_pin_already_setup == false {
            setupOTPPinView(true)
        }
    }
    
    func setupOTPPinView(_ isSetup: Bool) {
        self.otpPinTextView.text = ""
        otpPinView.isHidden = false
        if isSetup {
            isSetupPaymentPin = true
            otpPinLabel.text = "SetupPaymentPin.text".localized()
        } else {
            isSetupPaymentPin = false
            otpPinLabel.text = "EnterPaymentPin.text".localized()
        }
    }
    
    func setupPaymentPin() {
        guard let pin = self.otpPinTextView.text else {
            return
        }
        
        let params : [String:Any] = [
            "oldPaymentPin":"",
            "newPaymentPin":pin]
        self.view.showProgress()
        AlamoFireNetworking().postChangePaymentPin(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                //            self.checkAPIStatus(status: response.status)
                if response?.status == 1 {
                    NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
                } else {
                    showAlertView("Error".localized(), response?.message ?? "", controller: self, completion: nil)
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

extension PaymentViewController {
    @IBAction func paymentGatewayAmountButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            pgAmountTextField.text = "30.00"
            break
        case 1:
            pgAmountTextField.text = "50.00"
            break
        case 2:
            pgAmountTextField.text = "100.00"
            break
        default:
            break
        }
    }
    
    @IBAction func paymentGatewaySubmitButtonClicked(_ sender: UIButton) {
        generatePaymentGatewayUrl()
    }
    
    func generatePaymentGatewayUrl() {
        view.showProgress()
        let params : [String:Any] = ["bankId":pgSelectedBankId,
                                     "amount":self.pgAmountTextField.text ?? ""]
        AlamoFireNetworking().generatePaymentGatewayUrl(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    CoreSingletonData.shared.webViewType = .paymentUrl
                    CoreSingletonData.shared.toOpenUrl = response?.url
                    self.performSegue(withIdentifier: "openWebview", sender: nil)
                } else {
                    showAlertView("Error.text".localized(), response?.message ?? "TryAgainLater.text".localized(), controller: self, completion: nil)
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

extension PaymentViewController {
    @IBAction func bankTransferMoreButtonClicked(_ sender: UIButton) {
        let bankTransfer = self.bankTransferDetailList?.filter { $0.bank_id == btSelectedBankId }
        CoreSingletonData.shared.selectedBankTransfer = bankTransfer?.first
        performSegue(withIdentifier: "paymentBankTransfer", sender: nil)
    }
}

extension PaymentViewController {
    @IBAction func tngConfirmButtonClicked(_ sender: UIButton) {
        tngAmountTextField.resignFirstResponder()
        if tngAmountTextField.text.isEmptyOrNil == false {
            generateTnGPaymentGatewayUrl()
        } else {
            showAlertView("Error.text".localized(), "EmptyAmount.text".localized(), controller: self, completion: nil)
        }
    }
    
    @IBAction func tngClearButtonClicked(_ sender: UIButton) {
        tngAmountTextField.text = ""
    }
    
    func generateTnGPaymentGatewayUrl() {
        view.showProgress()
        let params : [String:Any] = ["bankId":self.touchNGoDetail?.bank_id ?? 0,
                                     "amount":self.tngAmountTextField.text ?? ""]
        AlamoFireNetworking().generatePaymentGatewayUrl(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    CoreSingletonData.shared.webViewType = .paymentUrl
                    CoreSingletonData.shared.toOpenUrl = response?.url
                    self.performSegue(withIdentifier: "openWebview", sender: nil)
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

extension PaymentViewController {
    @IBAction func withdrawConfirmButtonClicked(_ sender: UIButton) {
        withdrawAmountTextField.resignFirstResponder()
        if withdrawAmountTextField.text.isEmptyOrNil == false && withdrawSelectedBankId != -1 {
            setupOTPPinView(false)
        } else {
            showAlertView("Error.text".localized(), "EmptyAmount.text".localized(), controller: self, completion: nil)
        }
    }
    
    @IBAction func withdrawClearButtonClicked(_ sender: UIButton) {
        withdrawAmountTextField.text = ""
    }
    
    @objc func deleteWithdrawAccount() {
        view.showProgress()
        let params : [String:Any] = ["usersBankAccountId":CoreSingletonData.shared.deleteWithdrawAccountNumber!]
        AlamoFireNetworking().postRemoveBankAccount(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
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
    
    func withdrawFromAccount() {
        guard let withdrawAcc = self.withdrawBankList?.filter({ $0.users_bank_account_id == withdrawSelectedBankId }).first,
              let pin = self.otpPinTextView.text else {
            return
        }
        self.otpPinTextView.text = ""
        
        let params : [String:Any] = [
            "usersBankAccountId":withdrawAcc.users_bank_account_id!,
            "amount":withdrawAmountTextField.text!,
            "paymentPin":pin]
        self.view.showProgress()
        AlamoFireNetworking().postWithdrawFromBankAccount(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                //            self.checkAPIStatus(status: response.status)
                if response?.status == 1 {
                    NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
                } else {
                    showAlertView("Error".localized(), response?.message ?? "", controller: self, completion: nil)
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

extension PaymentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.btBankCollectionView {
            return bankTransferDetailList?.count ?? 0
        }
        if collectionView == self.pgBankCollectionView {
            return paymentGatewayDetailList?.count ?? 0
        }
        if collectionView == self.withdrawBankCollectionView {
            return withdrawBankList?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.btBankCollectionView {
                    guard let item = bankTransferDetailList?[indexPath.row],
                          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepositBankViewCollectionCell.reuseIdentifier(), for: indexPath) as? DepositBankViewCollectionCell else { return UICollectionViewCell() }
            DispatchQueue.main.async {
//                cell.setCell(image: .getBankLogo(item.bank_id ?? 0), isSelected: self.btSelectedBankId == item.bank_id ? true : false)
                cell.setCell(isSelected: self.btSelectedBankId == item.bank_id ? true : false, imageUrl: item.bank_image)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }
            return cell
        }
        if collectionView == self.pgBankCollectionView {
            guard let item = paymentGatewayDetailList?[indexPath.row],
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepositBankViewCollectionCell.reuseIdentifier(), for: indexPath) as? DepositBankViewCollectionCell else { return UICollectionViewCell() }
            DispatchQueue.main.async {
//                cell.setCell(image: .getBankLogo(item.bank_id ?? 0), isSelected: self.pgSelectedBankId == item.bank_id ? true : false)
                cell.setCell(isSelected: self.pgSelectedBankId == item.bank_id ? true : false, imageUrl: item.bank_image)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }
            return cell
        }
        
        if collectionView == self.withdrawBankCollectionView {
            guard let item = withdrawBankList?[indexPath.row],
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawBankViewCollectionCell.reuseIdentifier(), for: indexPath) as? WithdrawBankViewCollectionCell else { return UICollectionViewCell() }
            
            let title = item.bank_id == -1 ? item.bank_name ?? "" : String(format: "%@\n%@\n%@", item.bank_name ?? "", item.bank_account_no ?? "", item.bank_account_holder ?? "")
            guard let image = item.bank_id == -1 ? UIImage.paymentAdd : UIImage.getBankLogo(item.bank_id ?? 0) else { return UICollectionViewCell() }
            DispatchQueue.main.async {
                cell.setCell(title: title, image: image, isSelected: self.withdrawSelectedBankId == item.users_bank_account_id ? true : false, usersBankAccountId: item.users_bank_account_id ?? 0)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.btBankCollectionView {
            return CGSize(width: 80, height: 80)
        }
        if collectionView == self.pgBankCollectionView {
            return CGSize(width: 80, height: 80)
        }
        if collectionView == self.withdrawBankCollectionView {
            return CGSize(width: 116, height: 170)
        }
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.btBankCollectionView {
            guard let item = bankTransferDetailList?[indexPath.row] else { return }
            btSelectedBankId = item.bank_id ?? -1
            self.btBankName.text = item.bank_name ?? ""
            self.btBankCollectionView.reloadData()
        }
        if collectionView == self.pgBankCollectionView {
            guard let item = paymentGatewayDetailList?[indexPath.row] else { return }
            pgSelectedBankId = item.bank_id ?? -1
            self.pgBankCollectionView.reloadData()
        }
        if collectionView == self.withdrawBankCollectionView {
            guard let item = withdrawBankList?[indexPath.row] else { return }
            if item.bank_id == -1 {
                performSegue(withIdentifier: "paymentAddBank", sender: nil)
            } else {
                withdrawSelectedBankId = item.users_bank_account_id ?? -1
                self.withdrawBankCollectionView.reloadData()
            }
        }
    }
}

extension PaymentViewController : DPOTPViewDelegate {
   func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        otpPinTextView.resignFirstResponder()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        otpPinView.isHidden = true
        if isSetupPaymentPin! {
            setupPaymentPin()
        } else {
            withdrawFromAccount()
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        if isSetupPaymentPin! {
            NotificationCenter.default.post(name: Notification.Name("ShowDashboard"), object: nil)
        } else {
            otpPinView.isHidden = true
        }
    }
}
