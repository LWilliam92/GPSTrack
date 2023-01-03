//
//  SideMenuViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 11/08/2022.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController {
    
    var currentLayer: Int = 1
    var currentActiveLayer: String = "Main"

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePinView: UIView!
    
    @IBOutlet weak var changePasswordOld: UITextField!
    @IBOutlet weak var changePasswordNew: UITextField!
    @IBOutlet weak var changePasswordConfirm: UITextField!
    
    @IBOutlet weak var changePinOld: UITextField!
    @IBOutlet weak var changePinNew: UITextField!
    @IBOutlet weak var changePinConfirm: UITextField!
    
    @IBOutlet weak var languageEnglishBackground: UIImageView!
    @IBOutlet weak var languageBahasaBackground: UIImageView!
    @IBOutlet weak var languageChineseBackground: UIImageView!
    
    @IBOutlet weak var sidemenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentLayer = 1
        currentActiveLayer = "Main"
    }
    
    func setupView() {
        let bundle = Bundle(for: SideMenuTableViewCell.self)
        let tableNib = UINib(nibName: "SideMenuTableViewCell", bundle: bundle)
        
        sidemenuTableView.register(tableNib, forCellReuseIdentifier: SideMenuTableViewCell.reuseIdentifier())
        sidemenuTableView.dataSource = self
        sidemenuTableView.delegate = self
        
        languageEnglishBackground.isHidden = true
        languageBahasaBackground.isHidden = true
        languageChineseBackground.isHidden = true
        if CoreSingletonData.shared.userInfo?.language == "en" {
            languageEnglishBackground.isHidden = false
        } else if CoreSingletonData.shared.userInfo?.language == "ms" {
            languageBahasaBackground.isHidden = false
        } else {
            languageChineseBackground.isHidden = false
        }
    }
    
    @IBAction func closeSideMenu(_ sender: Any) {
        if currentLayer == 1 {
            self.dismissSideMenu()
        } else {
            if currentActiveLayer == "ChangePin" {
                currentLayer-=1
                currentActiveLayer = "Main"
                changePinView.isHidden = true
            } else if currentActiveLayer == "ChangePassword" {
                currentLayer-=1
                currentActiveLayer = "Main"
                changePasswordView.isHidden = true
            } else if currentActiveLayer == "Language" {
                currentLayer-=1
                currentActiveLayer = "Main"
                languageView.isHidden = true
            }
        }
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.sidemenuTableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.reuseIdentifier()) as? SideMenuTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.setCell(title: "SideMenu.ChangePassword.text".localized(), icon: .settingChangePass!, detail: ">")
        case 1:
            cell.setCell(title: "SideMenu.ChangePin.text".localized(), icon: .settingChangePin!, detail: ">")
        case 2:
            cell.setCell(title: "SideMenu.Referrer.text".localized(), icon: .settingReferrer!, detail: CoreSingletonData.shared.userInfo?.referrer ?? ">")
        case 3:
            cell.setCell(title: "SideMenu.Username.text".localized(), icon: .settingUsername!, detail: CoreSingletonData.shared.userInfo?.user_name ?? ">")
        case 4:
            cell.setCell(title: "SideMenu.MobileNo.text".localized(), icon: .settingMobileNo!, detail: CoreSingletonData.shared.userInfo?.mobile_number ?? ">")
        case 5:
            cell.setCell(title: "SideMenu.Language.text".localized(), icon: .settingLanguage!, detail: ">")
        default:
            cell.setCell(title: "", icon: .settingUsername!, detail: ">")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            currentLayer+=1
            currentActiveLayer = "ChangePassword"
            changePasswordView.isHidden = false
        case 1:
            currentLayer+=1
            currentActiveLayer = "ChangePin"
            changePinView.isHidden = false
        case 5:
            currentLayer+=1
            currentActiveLayer = "Language"
            languageView.isHidden = false
            
        default:
            break
        }
    }
}

extension SideMenuViewController {
    @IBAction func changePassNextButtonClicked(_ sender: Any) {
        if (self.changePasswordNew.text == self.changePasswordConfirm.text) &&
            (self.changePasswordOld.text != self.changePasswordNew.text){
            view.showProgress()
            let params : [String:Any] = ["originalPassword":self.changePasswordOld.text ?? "",
                                         "newPassword":self.changePasswordNew.text ?? "",
                                         "confirmPassword":self.changePasswordConfirm.text ?? ""]
            AlamoFireNetworking().postChangeLoginPassword(params: params) { response, error in
                if error == nil {
                    self.view.dismissProgress()
                    self.dismissSideMenu()
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
}

extension SideMenuViewController {
    @IBAction func changePinNextButtonClicked(_ sender: Any) {
        if (self.changePinNew.text == self.changePinConfirm.text) &&
            (self.changePinOld.text != self.changePinNew.text){
            view.showProgress()
            let params : [String:Any] = ["oldPaymentPin":self.changePinOld.text ?? "",
                                         "newPaymentPin":self.changePinNew.text ?? ""]
            AlamoFireNetworking().postChangePaymentPin(params: params) { response, error in
                if error == nil {
                    self.view.dismissProgress()
                    self.dismissSideMenu()
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
}

extension SideMenuViewController {
    @IBAction func languageButtonClicked(_ sender: UIButton) {
        var locale = "en"
        switch sender.tag {
        case 0: // en
            locale = "en"
        case 1: // ms
            locale = "ms"
        case 2: // zh
            locale = "zh"
        default:
            break
        }
        changeLanguage(locale)
    }
    
    func changeLanguage(_ languageCode: String) {
        view.showProgress()
        let params : [String:Any] = ["locale": languageCode]
        AlamoFireNetworking().postChangeUserLanguage(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.dismissSideMenu()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    func dismissSideMenu() {
        NotificationCenter.default.post(name: Notification.Name("SideMenuDismissed"), object: nil)
        performSegue(withIdentifier: "sideMenuDismiss", sender: nil)
    }
}

extension SideMenuViewController {
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Attention.text".localized(), message: "ConfirmSignOut".localized(), preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK.text".localized(), style: .default) { _ in
            performLogout()
        }
        let noButton = UIAlertAction(title: "NoButton.text".localized(), style: .cancel)
        alert.addAction(okButton)
        alert.addAction(noButton)
        self.present(alert, animated: true)
    }
}
