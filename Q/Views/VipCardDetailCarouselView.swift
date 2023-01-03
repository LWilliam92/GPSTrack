//
//  VipCardDetailCarouselView.swift
//  QPlus
//
//  Created by Kar Wai Ng on 25/12/2022.
//

import UIKit

class VipCardDetailCarouselView: UIView {
    @IBOutlet weak var statusAwardVipLevel: UILabel!
    @IBOutlet weak var statusVipLevel: UILabel!
    @IBOutlet weak var statusNextTerms: UILabel!
    @IBOutlet weak var statusCompletedTerms: UILabel!
    
    func setView(vipRebateModel: VipRebateModel?) {
        let currentViewVipLevel = vipRebateModel?.vip_level ?? 0
        let nextVipLevel = currentViewVipLevel + 1
        
        statusAwardVipLevel.text = String(format: "vip.award.level.text".localized(), currentViewVipLevel)
        statusVipLevel.text = String(format: "Vip.Level.text".localized(), currentViewVipLevel.asStringDigit())
        statusNextTerms.text = String(format: "vip.nextLevel.term".localized(), nextVipLevel, (vipRebateModel?.reload_completed?.asCurrencyDecimal() ?? "0.00"), (vipRebateModel?.turnover_completed?.asCurrencyDecimal() ?? "0.00"))
        statusCompletedTerms.text = String(format: "vip.status.completed.text".localized(), (vipRebateModel?.reload_left?.asCurrencyDecimal() ?? "0.00"), (vipRebateModel?.turnover_left?.asCurrencyDecimal() ?? "0.00"))
    }
}
