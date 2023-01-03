//
//  VipViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 02/11/2022.
//

import UIKit
import iProgressHUD
import iCarousel
import GradientProgress
import SNCollectionViewLayout

class VipViewController: UIViewController {
    
    @IBOutlet var vipCarousel: iCarousel!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    
    @IBOutlet weak var vipProgress: GradientProgressBar!
    
    @IBOutlet weak var vipCurrentLevelLbl: UILabel!
    @IBOutlet weak var vipNextLevelLbl: UILabel!
    
    @IBOutlet weak var dailyWithdrawLimit: UILabel!
    @IBOutlet weak var dailyWithdrawAmount: UILabel!
    @IBOutlet weak var dailyTransferLimit: UILabel!
    
    @IBOutlet weak var vipDetailsCV: UICollectionView!
    @IBOutlet weak var vipDetailHeightContraint: NSLayoutConstraint!
    
    var vipDetailModel: GetVipDetailsModel?
    var collectionItemHeight: CGFloat = 0.0
    var vipRebateModel: VipRebateModel?
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupCV()
        getVipDetails()
    }
    
    func setupCV() {
        vipCarousel.type = .linear
        vipCarousel.isPagingEnabled = true
        vipCarousel.bounces = false
        vipCarousel.delegate = self
        vipCarousel.dataSource = self
        
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
    }

    func setupView() {
        guard let vipModel = vipDetailModel else { return }
        DispatchQueue.main.async {
            self.vipRebateModel = vipModel.rebate?[self.currentIndex]
            
            self.username.text = vipModel.user_name
            self.mobileNo.text = vipModel.contact_number
            let currentViewVipLevel = self.vipRebateModel?.vip_level ?? 0
            let currentVipLevel = vipModel.vip_level ?? 0
            let nextVipLevel = currentViewVipLevel + 1
            self.vipCurrentLevelLbl.text = String(format: "vip.progress.level.text".localized(), currentViewVipLevel)
            self.vipNextLevelLbl.text = String(format: "vip.progress.level.text".localized(), nextVipLevel)
            
            var currentProgress: Float = 0.0
            if currentVipLevel > currentViewVipLevel {
                currentProgress = 100.0
            } else if currentVipLevel == currentViewVipLevel {
                currentProgress = vipModel.percent_achieved?.asFloat() == 0 ? 0.0 : Float((vipModel.percent_achieved?.asFloat() ?? 0.0)/100)
            } else {
                currentProgress = 0.0
            }
            self.vipProgress.setProgress(currentProgress, animated: true)
            self.vipProgress.gradientColors = [UIColor.vipProgressBar.cgColor,UIColor.vipProgressBar.cgColor]
            self.vipProgress.trackTintColor = .clear
            
            self.dailyWithdrawLimit.text = self.vipRebateModel?.daily_withdraw_times?.asStringDigit()
            self.dailyWithdrawAmount.text = self.vipRebateModel?.daily_withdraw_amount?.asCurrencyDecimal(false)
            self.dailyTransferLimit.text = self.vipRebateModel?.transfer_credit_times?.asStringDigit()
            
            self.vipDetailsCV.reloadData()
            
            let rebateCount = self.vipRebateModel?.percent?.count ?? 0
            let numberOfRows = CGFloat(rebateCount) / 3
            let totalHeight = numberOfRows * self.collectionItemHeight
            self.vipDetailHeightContraint.constant = totalHeight + (10 * numberOfRows)
        }
    }
    
    @IBAction func closePopUpClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func getVipDetails() {
        view.showProgress()
        AlamoFireNetworking().getVipDetails(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    self.vipDetailModel = response
                    
                    self.currentIndex = (self.vipDetailModel?.vip_level ?? 1) - 1
                    self.setupView()
                    self.vipCarousel.reloadData()
                    self.vipCarousel.scrollToItem(at: self.currentIndex, animated: false)
                } else {
                    
                }
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
}

extension VipViewController: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return vipDetailModel?.rebate?.count ?? 0
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = Bundle.main.loadNibNamed("VipCardDetailCarouselView", owner: self, options: nil)![0] as! VipCardDetailCarouselView
        view.frame.size = CGSize(width: vipCarousel.frame.size.width, height: vipCarousel.frame.size.height)

        DispatchQueue.main.async {
            view.setView(vipRebateModel: self.vipDetailModel?.rebate?[index])
        }
        return view
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .wrap {
            return 0.0;
        }
        return value;
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        currentIndex = carousel.currentItemIndex
        self.setupView()
    }
}

extension VipViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SNCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vipRebateModel?.percent?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = vipRebateModel?.percent?[indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VipDetailCollectionCell.reuseIdentifier(), for: indexPath) as? VipDetailCollectionCell else { return UICollectionViewCell() }
        
//        DispatchQueue.main.async {
            cell.setCell(title: item.game_name ?? "", rate: item.rebate_percent?.asCurrencyDecimal() ?? "")
//        }
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
