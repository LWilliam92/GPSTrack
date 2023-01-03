//
//  ActivityTransferScanViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 01/11/2022.
//

import Foundation
import UIKit
import iProgressHUD
import MercariQRScanner
import AVFoundation

class ActivityTransferScanViewController: UIViewController {
    @IBOutlet weak var scannerView: QRScannerView!
    
    var code: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        
        setupQRScanner()
    }

    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert("QR.Camera.permission.text".localized())
        }
    }

    private func setupQRScannerView() {
        scannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        scannerView.startRunning()
    }

    private func showAlert(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error.text".localized(), message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK.text".localized(), style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @IBAction func detailBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "activityTransferDetail", sender: nil)
    }
    
    func getUsername() {
        view.showProgress()
        let params : [String:Any] = ["referralCode":code ?? ""]
        AlamoFireNetworking().getUsernameWithReferralCode(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                //            self.checkAPIStatus(status: response.status ?? 0)
                if response?.status == 1 {
                    CoreSingletonData.shared.scannedUsername = response?.user_name
                    self.performSegue(withIdentifier: "activityTransferDetail", sender: nil)
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

extension ActivityTransferScanViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        showAlert("QR.Camera.ScanFail.text".localized())
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        if code.contains("referral=") == true {
            let qrContent = code.components(separatedBy: "referral=")
            self.code = qrContent.last
            getUsername()
        } else {
            showAlert("QR.Camera.Invalid.text".localized())
        }
    }
}
