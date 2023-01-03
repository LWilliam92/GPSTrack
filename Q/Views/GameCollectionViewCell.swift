//
//  GameCollectionViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 07/07/2022.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var comingSoonImgView: UIImageView!
    
    func setCell(item: GameCollectionData) {
        guard let titleUrl = URL(string: item.image_left?.getEncodingUrl() ?? ""),
              let gameUrl = URL(string: item.image_right?.getEncodingUrl() ?? ""),
              let maintenanceUrl = URL(string: item.maintenance_images_v2?.getEncodingUrl() ?? "") else { return }
        if item.game_id != -1 {
            comingSoonImgView.isHidden = true
            titleImgView.sd_setImage(with: titleUrl)
            if item.is_maintenance == true {
                imgView.sd_setImage(with: maintenanceUrl)
            } else {
                imgView.sd_setImage(with: gameUrl)
            }
        } else {
            comingSoonImgView.isHidden = false
            titleImgView.sd_setImage(with: titleUrl)
            imgView.sd_setImage(with: gameUrl)
        }
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
}
