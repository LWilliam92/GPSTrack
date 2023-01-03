//
//  VipDetailCollectionCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 04/12/2022.
//

import Foundation
import UIKit

class VipDetailCollectionCell: UICollectionViewCell {
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(title: String, rate: String) {
        titleLabel.text = title
        rateLabel.text = String(format: "vip.detail.rate.text".localized(), rate.asDouble())
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
}
