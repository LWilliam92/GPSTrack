//
//  MissionTableViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 27/08/2022.
//

import Foundation
import SDWebImage
import UIKit
import GradientProgress

class MissionTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var missionRewardTitleLbl: UILabel!
    @IBOutlet weak var missionLbl: UILabel!
    @IBOutlet weak var missionProgressLbl: UILabel!
    
    @IBOutlet weak var actionBtnTitleLbl: UILabel!
    @IBOutlet weak var actionBtnView: UIView!
    @IBOutlet weak var actionBtnBackgroundImageView: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!
    
    @IBOutlet weak var progressView: GradientProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
    
    func setCell(item: MissionDetailModel) {
        self.missionRewardTitleLbl.text = item.mission_title
        self.missionLbl.text = item.mission_description
        
        let currentPercent: Double = (Double(item.curent_progress ?? 0) / Double(item.target_progress ?? 0)) * 100
        self.missionProgressLbl.text = currentPercent.asPercentage()
        let currentProgress: Float = currentPercent == 0 ? 0.0 : Float(currentPercent/100)
        self.progressView.setProgress(currentProgress, animated: true)
        self.progressView.gradientColors = [UIColor.tint.cgColor,UIColor.tint.cgColor]
        self.progressView.layer.borderWidth = 1.0
        self.progressView.layer.borderColor = .black()
        self.progressView.trackTintColor = .clear
        
        self.actionBtnBackgroundImageView.isHidden = true
        self.actionBtnView.backgroundColor = .white
        self.actionBtnTitleLbl.textColor = .fontInactive
        if item.is_refer == true {
            self.actionBtnTitleLbl.text = "ReferButton.text".localized()
        } else if item.is_deposit == true {
            self.actionBtnTitleLbl.text = "DepositButton.text".localized()
        } else if item.is_completed == true && item.is_claimed == false {
            self.actionBtnTitleLbl.text = "ClaimNowButton.text".localized()
            self.actionBtnBackgroundImageView.isHidden = false
            self.actionBtnView.backgroundColor = .clear
            self.actionBtnTitleLbl.textColor = .fontActive
        } else if item.is_claimed == true {
            self.actionBtnTitleLbl.text = "ClaimedButton.text".localized()
        } else {
            self.actionBtnTitleLbl.text = "PlayNowButton.text".localized()
        }
        self.actionBtn.tag = item.mission_id ?? 0
        
        var image: String = ""
        if item.game_details != nil {
            image = item.game_details?.image_right ?? ""
        } else {
            image = item.game_image ?? ""
        }
        
        guard let url = URL(string: image.getEncodingUrl()) else { return }
        self.imgView.sd_setImage(with: url)
    }
    
    @IBAction func missionButtonClicked(_ sender: UIButton) {
        CoreSingletonData.shared.selectedMission = sender.tag
        NotificationCenter.default.post(name: Notification.Name("MissionButtonClicked"), object: nil)
    }
}
