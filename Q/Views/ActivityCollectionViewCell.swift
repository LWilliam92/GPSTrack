//
//  ActivityCollectionViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 15/08/2022.
//

import Foundation

import UIKit
import SnapKit
import SDWebImage

class ActivityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(title: String, image: UIImage) {
        titleLabel.text = title
        imgView.image = image
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
}
