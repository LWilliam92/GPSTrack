//
//  PaymentBankTransferDetailViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 17/09/2022.
//

import UIKit
import iProgressHUD
import Alamofire

class PaymentBankTransferDetailViewController: UIViewController {    
    @IBOutlet weak var bankAccountNameTf: UITextField!
    @IBOutlet weak var bankAccountNumberTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var receiptNameTf: UITextField!
    
    var btReceiptImage: String?
    var receiptImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        amountTf.keyboardType = .numberPad
        amountTf.clearButtonMode = .whileEditing
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bankAccountNameTf.text = CoreSingletonData.shared.selectedBankTransfer?.bank_account_holder
        self.bankAccountNumberTf.text = CoreSingletonData.shared.selectedBankTransfer?.bank_account_no
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismissView()
    }
    
    @IBAction func amountButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            amountTf.text = "30.00"
            break
        case 1:
            amountTf.text = "50.00"
            break
        case 2:
            amountTf.text = "100.00"
            break
        default:
            break
        }
    }
    
    @IBAction func copyBankNameButtonClicked(_ sender: Any) {
        UIPasteboard.general.string = bankAccountNameTf.text
    }
    
    @IBAction func copyBankNumberButtonClicked(_ sender: Any) {
        UIPasteboard.general.string = bankAccountNumberTf.text
    }
    
    @IBAction func amountClearButtonClicked(_ sender: Any) {
        amountTf.text = ""
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        if amountTf.text?.asDouble() ?? 0.00 > 0 {
            bankTransfer()
        } else {
            showAlertView("Error.text".localized(), "EmptyAmount.text".localized(), controller: self, completion: nil)
        }
    }
    
    @IBAction func bankTransferReceiptImageClicked(_ sender: UIButton) {
        self.amountTf.resignFirstResponder()
        ImagePickerManager().pickImage(self){ image in
            self.receiptImage = image
            guard let resizedImg = resizeImage(image: image, targetSize: CGSizeMake(500.0, 500.0)) else { return }

            self.btReceiptImage = resizedImg.toBase64Jpeg(1.0)
            let todayDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let todayDayStr = dateFormatter.string(from: todayDate)
            let fileName = String(format:"%@-%@.jpeg",todayDayStr, CoreSingletonData.shared.userInfo?.user_name ?? "")
            self.receiptNameTf.text = fileName
            self.receiptNameTf.resignFirstResponder()
        }
    }
    
    func bankTransfer() {
        //        let bankTransfer = self.bankTransferDetailList?.filter { $0.deposit_bank_account_id == btSelectedBankId }.first
        self.view.showProgress()
        if let receipt = self.receiptImage {
            let params : [String:Any] = ["depositBankAccountId": CoreSingletonData.shared.selectedBankTransfer?.deposit_bank_account_id ?? 0,
                                         "amount": self.amountTf.text ?? "0.00",
                                         "images": self.btReceiptImage?.getEncodingUrl() ?? "",
                                         "fileName": self.receiptNameTf.text?.getEncodingUrl() ?? ""]
            
            let url = Constants.API.baseURL + "\(Constants.API.postDepositMoneyWithReceipt)"
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "TOKEN": CoreSingletonData.shared.token ?? ""
            ]

            if let _ = NetworkReachabilityManager()?.isReachable {
                AF.upload(multipartFormData: { multipartFormData in
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: url, method: .post, headers: headers)
                .uploadProgress(queue: .main, closure: { progress in
                })
                .responseJSON { response in
                    print("response: \(response)")
                    switch response.result {
                    case .success(let value):
                        self.view.dismissProgress()
                        if let jsonString = value as? String, let data = jsonString.data(using: .utf8) {
                            do {
                                let responseModel = try JSONDecoder().decode(GenericEmptyResponseModel.self, from: data)
//                                self.checkAPIStatus(status: responseModel.status)
                                if responseModel.status == 1 {
                                    showAlertView("Success".localized(), "Bank Transfer is in progress.", controller: self, completion: { [weak self] in
                                        guard self != nil else { return }
                                        self?.dismissView()
                                    })
                                } else {
                                    showAlertView("Error".localized(), responseModel.message ?? "", controller: self, completion: nil)
                                }
                            } catch {}
                        }
                    case .failure(let error):
                        self.view.dismissProgress()
                        showAlertView("Error".localized(), "PleaseTryAgainLater".localized(), controller: self, completion: nil)
                    }
                }
            }
        }
    }
    
    func dismissView() {
        CoreSingletonData.shared.selectedBankTransfer = nil

        NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
        self.dismiss(animated: true)
    }
}

