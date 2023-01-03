//
//  DashboardViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 07/07/2022.
//

import Foundation
import UIKit
import iCarousel
import iProgressHUD
import SNCollectionViewLayout

class DashboardViewController: UIViewController {
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet var carouselBanner: iCarousel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var vipLevel: UILabel!
    @IBOutlet weak var mainWalletBalance: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var announcementLbl: UILabel!
    
    var gameCollectionModel: [GameCollectionData]?
    var filteredCollectionModel: [GameCollectionData]?
    var gameCategory: [GameCategoryModel]?
    var carouselBannerArr: [String]?
    var currentCategoryId: Int = 99
    var currentGameCategoryIndex: Int = 0
    var isSideMenuTriggered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
        
        NotificationCenter.default.post(name: Notification.Name("ReloadUserInfo"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getGameList), name: Notification.Name("UserInfoReloaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sideMenuDismiss), name: Notification.Name("SideMenuDismissed"), object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UserInfoReloaded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("SideMenuDismissed"), object: nil)
    }
    
    func setupView() {
        let bundle = Bundle(for: GameCategoryTableViewCell.self)
        let tableNib = UINib(nibName: "GameCategoryTableViewCell", bundle: bundle)
        let collectionNib = UINib(nibName: "GameCollectionViewCell", bundle: bundle)
        gameCollectionView.register(collectionNib, forCellWithReuseIdentifier: GameCategoryTableViewCell.reuseIdentifier())
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        let snCollectionViewLayout = SNCollectionViewLayout()
           snCollectionViewLayout.fixedDivisionCount = 2 // Columns for .vertical, rows for .horizontal
           snCollectionViewLayout.delegate = self
           gameCollectionView.collectionViewLayout = snCollectionViewLayout
        
        categoryTableView.register(tableNib, forCellReuseIdentifier: GameCategoryTableViewCell.reuseIdentifier())
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        carouselBanner.type = .linear
        carouselBanner.isPagingEnabled = true
        carouselBanner.delegate = self
        carouselBanner.dataSource = self
        
        let menuItem = UIBarButtonItem(image: .navMenu, style: .plain, target: self, action: #selector(showSideMenu))
        self.navigationItem.leftBarButtonItem = menuItem
        
        loadingView.isHidden = false
    }
    
    @objc func getGameList() {
        view.showProgress()
        AlamoFireNetworking().getGameList(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.userName.text = String(format: "Welcome.text".localized(), CoreSingletonData.shared.userInfo?.user_name ?? "")
                self.vipLevel.text = String(format: "Vip.Level.text".localized(), CoreSingletonData.shared.userInfo?.vip_level?.asStringDigit() ?? "0")
                self.mainWalletBalance.text = CoreSingletonData.shared.userInfo?.main_wallet_balance?.asCurrencyDecimal()
                self.announcementLbl.text = response?.announcement
                self.carouselBannerArr = response?.game_banner
                self.carouselBanner.reloadData()

                CoreSingletonData.shared.gameList = response
                self.loadingView.isHidden = true
                self.setupCollectionView(comingSoon: response?.coming_soon_image ?? [])
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func setupData() {
        gameCategory = []
        let allGamesRespModel = GameCategoryResponseModel.init(title: "AllGames.text".localized(), categoryId: 99)
        let allGamesModel = GameCategoryModel.init(item: allGamesRespModel, isActive: true)
        gameCategory?.append(allGamesModel)
        let liveRespModel = GameCategoryResponseModel.init(title: "Live.text".localized(), categoryId: 0)
        let liveModel = GameCategoryModel.init(item: liveRespModel, isActive: false)
        gameCategory?.append(liveModel)
        let slotsRespModel = GameCategoryResponseModel.init(title: "Slots".localized(), categoryId: 1)
        let slotsModel = GameCategoryModel.init(item: slotsRespModel, isActive: false)
        gameCategory?.append(slotsModel)
        let sportsRespModel = GameCategoryResponseModel.init(title: "Sports".localized(), categoryId: 2)
        let sportsModel = GameCategoryModel.init(item: sportsRespModel, isActive: false)
        gameCategory?.append(sportsModel)
        let lotteryRespModel = GameCategoryResponseModel.init(title: "Lottery".localized(), categoryId: 3)
        let lotteryModel = GameCategoryModel.init(item: lotteryRespModel, isActive: false)
        gameCategory?.append(lotteryModel)
        let eSportsRespModel = GameCategoryResponseModel.init(title: "ESport".localized(), categoryId: 4)
        let eSportsModel = GameCategoryModel.init(item: eSportsRespModel, isActive: false)
        gameCategory?.append(eSportsModel)
        categoryTableView.reloadData()
    }
    
    @objc func sideMenuDismiss() {
        isSideMenuTriggered = false
    }
    
    func setupCollectionView(comingSoon: [ComingSoonModel]) {
        var gameListArray: [GameCollectionData] = []
        guard let gameListResponse = CoreSingletonData.shared.gameList?.game_list else { return }
        if gameListResponse.count > 0 {
            for gameList in gameListResponse {
                var gameObj: GameCollectionData
                gameObj = GameCollectionData(game: gameList)
                gameListArray.append(gameObj)
            }
        }
        
        if comingSoon.count > 0 {
            for comingSoonItem in comingSoon {
                var comingSoonObj: GameCollectionData
                comingSoonObj = GameCollectionData(comingSoonGame: comingSoonItem)
                gameListArray.append(comingSoonObj)
            }
        }
        
        self.gameCollectionModel = gameListArray
        if currentCategoryId != 99 {
            self.filteredCollectionModel = []
            self.filteredCollectionModel = self.gameCollectionModel?.filter { $0.category.asInt() == currentCategoryId }
        } else {
            self.filteredCollectionModel = []
            self.filteredCollectionModel = self.gameCollectionModel
        }
        self.gameCollectionView.reloadData()
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SNCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentCategoryId == 99 {
            return gameCollectionModel?.count ?? 0
        } else {
            return filteredCollectionModel?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = gameCollectionModel?[indexPath.row],
              let filteredItem = filteredCollectionModel?[indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCategoryTableViewCell.reuseIdentifier(), for: indexPath) as? GameCollectionViewCell else { return UICollectionViewCell() }
        
        if currentCategoryId == 99 {
            cell.setCell(item: item)
        } else {
            cell.setCell(item: filteredItem)
        }
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showGamePopUp(index: indexPath.row)
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
        let height: CGFloat = width / 1.5
        return height
    }
    
    // header height
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 0
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameCategory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = gameCategory?[indexPath.row],
              let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: GameCategoryTableViewCell.reuseIdentifier()) as? GameCategoryTableViewCell else { return UITableViewCell() }
        
        cell.setCell(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gameCategory?.forEach { (game) in
            game.refresh()
        }
        
        guard let item = gameCategory?[indexPath.row] else { return }
        item.isActive = true
        currentCategoryId = item.item.categoryId ?? 99
        gameCategory?[indexPath.row] = item
        
        self.categoryTableView.reloadData()
        
        if currentCategoryId != 99 {
            self.filteredCollectionModel = []
            self.filteredCollectionModel = self.gameCollectionModel?.filter { $0.category.asInt() == currentCategoryId }
        } else {
            self.filteredCollectionModel = []
            self.filteredCollectionModel = self.gameCollectionModel
        }
        
        self.gameCollectionView.reloadData()
    }
}

extension DashboardViewController: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return carouselBannerArr?.count ?? 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIImageView
        if (view == nil)
        {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:carouselBanner.frame.size.width, height:carouselBanner.frame.size.height))
            itemView.contentMode = .scaleAspectFit
        }
        else
        {
            itemView = view as! UIImageView;
        }
        guard let url = URL(string: carouselBannerArr?[index].getEncodingUrl() ?? "") else { return itemView }
        DispatchQueue.main.async {
            itemView.sd_setImage(with: url)
        }
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .wrap {
            return 1.0;
        }
        return value;
    }
}

extension DashboardViewController {
    func showGamePopUp(index: Int) {
        if currentCategoryId == 99 {
            CoreSingletonData.shared.selectedGame = gameCollectionModel?[index].game_id
        } else {
            CoreSingletonData.shared.selectedGame = filteredCollectionModel?[index].game_id
        }
        performSegue(withIdentifier: "gamePopUp", sender: nil)
    }
    
    @objc func showSideMenu() {
        if isSideMenuTriggered == false {
            isSideMenuTriggered = true
            NotificationCenter.default.post(name: Notification.Name("ShowSideMenu"), object: nil)
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        getInfo()
    }
    
    @IBAction func helpClicked(_ sender: Any) {
        performSegue(withIdentifier: "customerService", sender: nil)

    }
    
    @IBAction func qrClicked(_ sender: Any) {
        performSegue(withIdentifier: "referralQR", sender: nil)
    }
    
    @IBAction func vipClicked(_ sender: Any) {
        performSegue(withIdentifier: "showVip", sender: nil)
    }
    
    func getInfo() {
        view.showProgress()
        AlamoFireNetworking().getInfoUrl(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    CoreSingletonData.shared.webViewType = .info
                    CoreSingletonData.shared.toOpenUrl = response?.url
                    self.performSegue(withIdentifier: "openWebview", sender: nil)
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
