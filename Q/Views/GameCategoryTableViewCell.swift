//
//  GameCategoryTableViewCell.swift
//  QPlus
//
//  Created by Kar Wai Ng on 08/07/2022.
//

import Foundation
import UIKit
import SDWebImage

class GameCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var background: UIRoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func reuseIdentifier() -> String {
        let className: String = String(describing: self)
        return className
    }
    
    func setCell(item: GameCategoryModel) {
        self.titleLbl.text = item.item.title ?? ""
        self.backgroundImg.image = UIImage.init(named: "")
        self.titleLbl.textColor = .baseFontColor
        switch item.item.categoryId {
        case 99:
            DispatchQueue.main.async {
                self.imgView.image = .allGames
            }
        case 0:
            DispatchQueue.main.async {
                self.imgView.image = .liveGames
            }
        case 1:
            DispatchQueue.main.async {
                self.imgView.image = .slotsGames
            }
        case 2:
            DispatchQueue.main.async {
                self.imgView.image = .sportsGames
            }
        case 3:
            DispatchQueue.main.async {
                self.imgView.image = .lotteryGames
            }
        case 4:
            DispatchQueue.main.async {
                self.imgView.image = .eSportsGames
            }
        default:
            DispatchQueue.main.async {
                self.imgView.image = .eSportsGames
            }
        }
        
        if item.isActive == true {
            switch item.item.categoryId {
            case 99:
                DispatchQueue.main.async {
                    self.imgView.image = .allGamesSelected
                    self.backgroundImg.image = .allGamesBackground
                }
            case 0:
                DispatchQueue.main.async {
                    self.imgView.image = .liveGamesSelected
                    self.backgroundImg.image = .liveGamesBackground
                }
            case 1:
                DispatchQueue.main.async {
                    self.imgView.image = .slotsGamesSelected
                    self.backgroundImg.image = .slotsGamesBackground
                }
            case 2:
                DispatchQueue.main.async {
                    self.imgView.image = .sportsGamesSelected
                    self.backgroundImg.image = .sportsGamesBackground
                }
            case 3:
                DispatchQueue.main.async {
                    self.imgView.image = .lotteryGamesSelected
                    self.backgroundImg.image = .lotteryGamesBackground
                }
            case 4:
                DispatchQueue.main.async {
                    self.imgView.image = .eSportsGamesSelected
                    self.backgroundImg.image = .eSportsGamesBackground
                }
            default:
                DispatchQueue.main.async {
                    self.imgView.image = .allGamesSelected
                    self.backgroundImg.image = .allGamesBackground
                }
            }
            self.titleLbl.textColor = .white
        }
    }
}
