//
//  DepositBankViewCollectionCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 08/09/2022.
//

import UIKit
import SnapKit
import SDWebImage

class DepositBankViewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIRoundedView!
    @IBOutlet weak var selectedView: UIImageView!
    
    func setCell(image: UIImage? = nil, isSelected: Bool, imageUrl: String? = "") {
        if image != nil {
            self.imgView.image = image
        }
        self.bgView.backgroundColor = isSelected == true ? .tint : .clear
        self.selectedView.isHidden = isSelected == true ? false : true
        if imageUrl != "" {
            guard let url = URL(string: imageUrl?.getEncodingUrl() ?? "") else { return }
            self.imgView.sd_setImage(with: url)
        }
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
}
