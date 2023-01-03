//
//  NotificationTableViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 29/09/2022.
//

import Foundation
import UIKit
import SDWebImage

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var transferLbl: UILabel!
    @IBOutlet weak var transferDateTimeLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
    
    func setCell(item: NotificationModel) {
//        self.titleLbl.text = item.text
        self.transferLbl.text = item.text
        self.transferDateTimeLbl.text = item.date
//        self.currencyLbl.text = "Currency.text".localized()
//        self.amountLbl.text = item.amount
//
//        guard let url = URL(string: item.game_image?.getEncodingUrl() ?? "") else { return }
//        self.imgView.sd_setImage(with: url)
    }
}
