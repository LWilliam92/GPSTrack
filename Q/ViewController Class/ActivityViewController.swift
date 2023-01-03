//
//  ActivityViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 07/07/2022.
//

import Foundation
import UIKit
import iProgressHUD
import SNCollectionViewLayout

class ActivityViewController: UIViewController {

    @IBOutlet weak var activityCV: UICollectionView!
    
    var activityCollectionModel: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupView()
        setupCollectionData()
    }
    
    func setupCollectionData() {
        activityCollectionModel = [
            "Activity.SystemNotification.text".localized(),
            "Activity.OrderHistory.text".localized(),
            "Activity.Rebate.text".localized(),
            "Activity.Transfer.text".localized(),
            "Activity.CheckIn.text".localized(),
            "Activity.Mission.text".localized()
        ]
        activityCV.reloadData()
    }
    
    func setupView() {
        let bundle = Bundle(for: ActivityCollectionViewCell.self)
        let collectionNib = UINib(nibName: "ActivityCollectionViewCell", bundle: bundle)
        activityCV.register(collectionNib, forCellWithReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier())
        activityCV.dataSource = self
        activityCV.delegate = self
        
        let snCollectionViewLayout = SNCollectionViewLayout()
           snCollectionViewLayout.fixedDivisionCount = 2 // Columns for .vertical, rows for .horizontal
           snCollectionViewLayout.delegate = self
        activityCV.collectionViewLayout = snCollectionViewLayout
    }
}

extension ActivityViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SNCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityCollectionModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = activityCollectionModel?[indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier(), for: indexPath) as? ActivityCollectionViewCell else { return UICollectionViewCell() }
        
        let imageName: UIImage
        switch indexPath.row {
        case 0:
            imageName = UIImage.activityNotification!
        case 1:
            imageName = UIImage.activityOrderHistory!
        case 2:
            imageName = UIImage.activityRebate!
        case 3:
            imageName = UIImage.activityTransfer!
        case 4:
            imageName = UIImage.activityCheckIn!
        case 5:
            imageName = UIImage.activityMission!
        default:
            imageName = UIImage.activityMission!
        }
        cell.setCell(title: item, image: imageName)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "activitySystemNotification", sender: nil)
        case 1:
            performSegue(withIdentifier: "activityOrderHistory", sender: nil)
        case 2:
            performSegue(withIdentifier: "activityRebate", sender: nil)
        case 3:
            performSegue(withIdentifier: "activityTransfer", sender: nil)
        case 4:
            performSegue(withIdentifier: "activityCheckIn", sender: nil)
        case 5:
            performSegue(withIdentifier: "activityMission", sender: nil)
        default:
            break
        }
    }
    
    // scale for items based number of columns
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        return 1
    }
    // height for item if set fixedDimension  height equal width
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        
        let columns: CGFloat = 2
        let collectionViewWidth = collectionView.bounds.width
        let width: CGFloat = floor(collectionViewWidth / columns)
        let height: CGFloat = width * 1.1
        return height
    }
    
    // header height
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 0
    }
}
