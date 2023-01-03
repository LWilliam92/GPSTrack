//
//  WithdrawBankViewCollectionCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 08/09/2022.
//

import UIKit
import SnapKit
import SDWebImage

class WithdrawBankViewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgView: UIRoundedView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var selectedView: UIImageView!
    
    func setCell(title: String, image: UIImage, isSelected: Bool, usersBankAccountId: Int) {
        self.titleLbl.text = title
        self.imgView.image = image
        self.bgView.backgroundColor = isSelected == true ? .black : .clear
        self.deleteAccountButton.tag = usersBankAccountId
        
        self.selectedView.isHidden = isSelected == true ? false : true
    }
    
    @IBAction func deleteAccountClicked(_ sender: UIButton) {
        CoreSingletonData.shared.deleteWithdrawAccountNumber = sender.tag
        NotificationCenter.default.post(name: Notification.Name("DeleteWithdrawAccount"), object: nil)
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
}
