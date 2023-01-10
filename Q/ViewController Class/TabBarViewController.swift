//
//  TabBarViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 07/07/2022.
//

import UIKit
import iProgressHUD

@objc class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSideMenu), name: Notification.Name("ShowSideMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadUserInfo), name: Notification.Name("ReloadUserInfo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showPaymentScreen), name: Notification.Name("ShowPaymentScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDashboardScreen), name: Notification.Name("ShowDashboard"), object: nil)
    }
    
    @objc func showSideMenu() {
        performSegue(withIdentifier: "sideMenuPopUp", sender: nil)
    }
    
    @objc func reloadUserInfo() {
        view.showProgress()
        AlamoFireNetworking().getUserInfo(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                CoreSingletonData.shared.userInfo = response?.result
                CoreSingletonData.shared.payment_gateway_url = response?.payment_gateway_url
                
                NotificationCenter.default.post(name: Notification.Name("UserInfoReloaded"), object: nil)
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    @objc func showDashboardScreen() {
        self.selectedIndex = 0
    }
    
    @objc func showPaymentScreen() {
        self.selectedIndex = 3
    }
}
