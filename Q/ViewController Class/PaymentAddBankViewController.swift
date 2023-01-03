//
//  PaymentAddBankViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 17/09/2022.
//

import UIKit
import iProgressHUD

class PaymentAddBankViewController: UIViewController {
    
    @IBOutlet weak var tfBankAccountName: UITextField!
    @IBOutlet weak var tfBankAccountNumber: UITextField!
    
    @IBOutlet weak var bankCollectionView: UICollectionView!
    var selectedBankId: Int = -1
    
    var bankList: [BankListModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
        setupView()
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        addBankAccount()
    }
    
    func addBankAccount() {
        if self.tfBankAccountNumber.text?.isEmpty == false && self.tfBankAccountName.text?.isEmpty == false {
            view.showProgress()
            let params : [String:Any] = ["bankId":selectedBankId,
                                         "accountNumber":self.tfBankAccountNumber.text ?? "",
                                         "accountName": self.tfBankAccountName.text ?? ""]
            AlamoFireNetworking().postAddBankAccount(params: params) { response, error in
                if error == nil {
                    self.view.dismissProgress()
                    NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
                    self.dismiss(animated: true)
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
    
    func getBankList() {
        view.showProgress()
        AlamoFireNetworking().getBankList(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    self.bankList = response?.bank
                    
                    if self.bankList?.count ?? 0 > 0 {
                        self.selectedBankId = self.bankList?.first?.bank_id ?? -1
                    }
                    self.bankCollectionView.reloadData()
                } else {
                    
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
    
    func setupView() {
        let bundle = Bundle(for: DepositBankViewCollectionCell.self)
        let depositCollectionNib = UINib(nibName: "DepositBankViewCollectionCell", bundle: bundle)
        bankCollectionView.register(depositCollectionNib, forCellWithReuseIdentifier: DepositBankViewCollectionCell.reuseIdentifier())
        bankCollectionView.dataSource = self
        bankCollectionView.delegate = self
        
        getBankList()
    }
}

extension PaymentAddBankViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bankList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = bankList?[indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepositBankViewCollectionCell.reuseIdentifier(), for: indexPath) as? DepositBankViewCollectionCell else { return UICollectionViewCell() }
        cell.setCell(isSelected: selectedBankId == item.bank_id ? true : false, imageUrl: item.bank_image ?? "")

//        cell.setCell(image: .getBankLogo(item.bank_id ?? 0), isSelected: selectedBankId == item.bank_id ? true : false)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = bankList?[indexPath.row] else { return }
        selectedBankId = item.bank_id ?? -1
        self.bankCollectionView.reloadData()
    }
}
