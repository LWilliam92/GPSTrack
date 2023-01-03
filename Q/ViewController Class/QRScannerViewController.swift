//
//  QRScannerViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 09/10/2022.
//

import Foundation
import UIKit
import MercariQRScanner
import AVFoundation
import iProgressHUD

class QRScannerViewController: UIViewController {
    
    @IBOutlet weak var qrScannerView: QRScannerView!
    
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
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }

    private func showAlert(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error.text".localized(), message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK.text".localized(), style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension QRScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        showAlert("QR.Camera.ScanFail.text".localized())
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        if code.contains("referral=") == true {
            CoreSingletonData.shared.scannedQrForReferral = code
            NotificationCenter.default.post(name: Notification.Name("ScannedQR"), object: nil)
            self.dismiss(animated: true)
        } else {
            showAlert("QR.Camera.Invalid.text".localized())
        }
    }
}
