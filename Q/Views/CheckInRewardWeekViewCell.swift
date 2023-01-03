//
//  CheckInRewardWeekViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 27/07/2022.
//

import Foundation
import UIKit
import SDWebImage

class CheckInRewardWeekViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var background: UIRoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
    
    func setCell(title: String, state: String) {
        self.titleLbl.text = title
        switch state {
        case Constants.CheckIn.activeState:
            break
        case Constants.CheckIn.inactiveState:
            break
        default:
            break
        }
//        guard let url = URL(string: item.images?.getEncodingUrl() ?? "") else { return }
//        self.imgView.sd_setImage(with: url)
    }
}
