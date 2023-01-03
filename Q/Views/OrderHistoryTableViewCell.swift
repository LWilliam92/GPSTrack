//
//  OrderHistoryTableViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 10/08/2022.
//

import Foundation
import UIKit
import SDWebImage

class OrderHistoryTableViewCell: UITableViewCell {
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
    
    func setCell(item: OrderHistoryModel) {
        self.transferLbl.text = item.reject_reason
        self.transferDateTimeLbl.text = item.created_date
        self.currencyLbl.text = "Currency.text".localized()
        self.amountLbl.text = item.amount

//        guard let url = URL(string: item.image_right?.getEncodingUrl() ?? ""),
//        let titleUrl = URL(string: item.image_left?.getEncodingUrl() ?? "") else { return }
//        self.imgView.sd_setImage(with: url)
//        self.titleImgView.sd_setImage(with: titleUrl)
    }
}
