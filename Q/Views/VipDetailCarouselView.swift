//
//  VipDetailCarouselView.swift
//  QPlus
//
//  Created by Kar Wai Ng on 15/12/2022.
//

import UIKit
import GradientProgress
import SNCollectionViewLayout

class VipDetailCarouselView: UIView {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    
    @IBOutlet weak var vipProgress: GradientProgressBar!
    
    @IBOutlet weak var vipCurrentLevelLbl: UILabel!
    @IBOutlet weak var vipNextLevelLbl: UILabel!
    
    @IBOutlet weak var statusAwardVipLevel: UILabel!
    @IBOutlet weak var statusVipLevel: UILabel!
    @IBOutlet weak var statusNextTerms: UILabel!
    @IBOutlet weak var statusCompletedTerms: UILabel!
    
    @IBOutlet weak var dailyWithdrawLimit: UILabel!
    @IBOutlet weak var dailyWithdrawAmount: UILabel!
    @IBOutlet weak var dailyTransferLimit: UILabel!
    
    @IBOutlet weak var vipDetailsCV: UICollectionView!
    @IBOutlet weak var vipDetailHeightContraint: NSLayoutConstraint!
    
    var vipDetailModel: GetVipDetailsModel?
    var collectionItemHeight: CGFloat = 0.0
    var vipRebateModel: VipRebateModel?
    
    func setView(vipDetailModel: GetVipDetailsModel?, index: Int) {
        let bundle = Bundle(for: VipDetailCollectionCell.self)
        let collectionNib = UINib(nibName: "VipDetailCollectionCell", bundle: bundle)
        vipDetailsCV.register(collectionNib, forCellWithReuseIdentifier: VipDetailCollectionCell.reuseIdentifier())
        vipDetailsCV.dataSource = self
        vipDetailsCV.delegate = self
        
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 3 // Columns for .vertical, rows for .horizontal
        snCollectionViewLayout.delegate = self
        vipDetailsCV.collectionViewLayout = snCollectionViewLayout
        
        let columns: CGFloat = 2
        let collectionViewWidth = vipDetailsCV.bounds.width
        let width: CGFloat = floor(collectionViewWidth / columns)
        collectionItemHeight = width * 0.5
        
        guard let vipModel = vipDetailModel,
              let vipDetail = vipDetailModel?.rebate?[index] else { return }
        self.vipDetailModel = vipModel
        self.vipRebateModel = vipModel.rebate?[index]
        
        username.text = vipModel.user_name
        mobileNo.text = vipModel.contact_number
        let currentVipLevel = vipModel.vip_level ?? 0
        let currentViewVipLevel = vipDetail.vip_level ?? 0
        let nextVipLevel = currentViewVipLevel + 1
        vipCurrentLevelLbl.text = String(format: "vip.progress.level.text".localized(), currentViewVipLevel)
        vipNextLevelLbl.text = String(format: "vip.progress.level.text".localized(), nextVipLevel)
        
        var currentProgress: Float = 0.0
        if currentVipLevel > currentViewVipLevel {
            currentProgress = 100.0
        } else if currentVipLevel == currentViewVipLevel {
            currentProgress = vipModel.percent_achieved?.asFloat() == 0 ? 0.0 : Float((vipModel.percent_achieved?.asFloat() ?? 0.0)/100)
        } else {
            currentProgress = 0.0
        }
        vipProgress.setProgress(currentProgress, animated: true)
        vipProgress.gradientColors = [UIColor.vipProgressBar.cgColor,UIColor.vipProgressBar.cgColor]
        vipProgress.trackTintColor = .clear
        
        statusAwardVipLevel.text = String(format: "vip.award.level.text".localized(), currentViewVipLevel)
        statusVipLevel.text = String(format: "Vip.Level.text".localized(), currentViewVipLevel.asStringDigit())
        statusNextTerms.text = String(format: "vip.nextLevel.term".localized(), nextVipLevel, (vipDetail.reload_completed?.asCurrencyDecimal() ?? "0.00"), (vipDetail.turnover_completed?.asCurrencyDecimal() ?? "0.00"))
        statusCompletedTerms.text = String(format: "vip.status.completed.text".localized(), (vipDetail.reload_left?.asCurrencyDecimal() ?? "0.00"), (vipDetail.turnover_left?.asCurrencyDecimal() ?? "0.00"))
        
        dailyWithdrawLimit.text = vipDetail.daily_withdraw_times?.asStringDigit()
        dailyWithdrawAmount.text = vipDetail.daily_withdraw_amount?.asCurrencyDecimal(false)
        dailyTransferLimit.text = vipDetail.transfer_credit_times?.asStringDigit()
        
        vipDetailsCV.reloadData()
        
        let rebateCount = vipDetail.percent?.count ?? 0
        let numberOfRows = CGFloat(rebateCount) / 3
        let totalHeight = numberOfRows * collectionItemHeight
        vipDetailHeightContraint.constant = totalHeight + (10 * numberOfRows)
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
}

extension VipDetailCarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SNCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vipRebateModel?.percent?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = vipRebateModel?.percent?[indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VipDetailCollectionCell.reuseIdentifier(), for: indexPath) as? VipDetailCollectionCell else { return UICollectionViewCell() }
        
        cell.setCell(title: item.game_name ?? "", rate: item.rebate_percent?.asCurrencyDecimal() ?? "")
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    // scale for items based number of columns
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        return 1
    }
    
    // height for item if set fixedDimension  height equal width
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        
        return collectionItemHeight
    }
    
    // header height
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 0
    }
}
