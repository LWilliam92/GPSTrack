//
//  SideMenuTableViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 11/09/2022.
//

import Foundation
import UIKit
import SDWebImage

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
    
    func setCell(title: String, icon: UIImage, detail: String) {
        self.titleLbl.text = title
        self.icon.image = icon
        self.detailLbl.text = detail
    }
}
