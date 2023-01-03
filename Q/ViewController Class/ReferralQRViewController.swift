//
//  ReferralQRViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 29/08/2022.
//

import Foundation
import UIKit
import EFQRCode
import iProgressHUD

class ReferralQRViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        if let image = EFQRCode.generate(
            for: CoreSingletonData.shared.userInfo?.referral_full_link ?? ""
        ) {
            print("Create QRCode image success \(image)")
            qrImageView.image = UIImage(cgImage: image)
        } else {
            print("Create QRCode image failed!")
        }
        usernameLabel.text = CoreSingletonData.shared.userInfo?.user_name
    }
    
    @IBAction func qrImageClicked(_ sender: UIButton) {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: qrImageView.image ?? UIImage())
    }
    
    @IBAction func scanToTransferClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "activityTransfer", sender: nil)
    }
}
