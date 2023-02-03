//
//  LoginViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 24/07/2022.
//

import UIKit
import AVKit
import AVFoundation
import iProgressHUD

@objc class LoginViewController: UIViewController {
    enum LoginLayer {
        case login
        case register1
        case register2
        case forgot
        case forgotUid1
        case forgotUid2
        case forgotPassword1
        case forgotPassword2
    }
    
    @IBOutlet weak var videoView: UIView!

    var player: AVPlayer?
    var currentLayer: LoginLayer?
    var shouldSavePass: Bool = true
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var tfLoginUsername: UITextField!
    @IBOutlet weak var tfLoginPassword: UITextField!
    @IBOutlet weak var imgViewSavePass: UIImageView!
    
    @IBOutlet weak var registerView1: UIView!
    @IBOutlet weak var tfRegisterUsername: UITextField!
    @IBOutlet weak var tfRegisterPassword: UITextField!
    @IBOutlet weak var tfRegisterConfirmPassword: UITextField!
    @IBOutlet weak var tfRegisterMobile: UITextField!
    @IBOutlet weak var tfRegisterReferral: UITextField!
    
    @IBOutlet weak var registerView2: UIView!
    @IBOutlet weak var tfRegister2Mobile: UITextField!
    @IBOutlet weak var tfRegister2Tac: UITextField!
    
    @IBOutlet weak var forgotView: UIView!
    
    @IBOutlet weak var forgotUIDView1: UIView!
    @IBOutlet weak var tfForgotUidMobile: UITextField!
    
    @IBOutlet weak var forgotUIDView2: UIView!
    @IBOutlet weak var tfForgotUid2Mobile: UITextField!
    @IBOutlet weak var tfForgotUid2Tac: UITextField!
    
    @IBOutlet weak var forgotPasswordView1: UIView!
    @IBOutlet weak var tfForgotPasswordUsername: UITextField!
    @IBOutlet weak var tfForgotPasswordMobile: UITextField!
    
    @IBOutlet weak var forgotPasswordView2: UIView!
    @IBOutlet weak var tfForgotPassword2Mobile: UITextField!
    @IBOutlet weak var tfForgotPassword2Password: UITextField!
    @IBOutlet weak var tfForgotPassword2Tac: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        UIFont.overrideInitialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
        setCurrentLayer(.login)
        setupView()
        
        if UIDevice.current.isSimulator {
            self.tfLoginUsername.text = "testingalohagg"
            self.tfLoginPassword.text = "abc12345"
        }
        
        checkAppSetting()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let username = UserDefaults.standard.object(forKey: "username") as? String,
              let password = UserDefaults.standard.object(forKey: "password") as? String else {
            return
        }
        self.tfLoginUsername.text = username
        self.tfLoginPassword.text = password
        shouldSavePass = self.tfLoginUsername.text.isEmptyOrNil ? false : true
        setSavePassImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setReferralCode), name: Notification.Name("ScannedQR"), object: nil)
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main,
            using: { _ in
                self.checkAppSetting()
            }
        )
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ScannedQR"), object: nil)
    }
    
    func setupView() {
        if let videoUrl = Bundle.main.url(forResource: "login", withExtension: "mp4") {
            
            self.player = AVPlayer(url: videoUrl)
            self.player?.isMuted = true
            self.player?.actionAtItemEnd = .none
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.frame = view.frame
            
            self.videoView.layer.addSublayer(playerLayer)
            
            self.player?.play()
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    @objc func checkAppSetting() {
        if UIDevice.current.isSimulator == false {
            view.showProgress()
            let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            let params : [String:Any] = ["version": version ?? "1"]
            AlamoFireNetworking.sharedClient.getSettings(params: params) { response, error in
                if error == nil {
                    self.view.dismissProgress()
                    CoreSingletonData.shared.customerServiceUrl = response?.public_live_chat_url
                    if let url = response?.ios_url,
                       url != "",
                       response?.update == true {
                        showAlertView("Update required", "Please update your apps to continue.", controller: self, completion: { [weak self] in
                            guard self != nil else { return }
                            if let url = URL(string: url) {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:])
                                }
                            }
                        })
                    }
                    
                    
                } else {
                    self.view.dismissProgress()
                    showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                        guard self != nil else { return }
                    })
                }
            }
        }
    }
    
//    func checkAppMasked(completionHandler: (Bool) -> Void) {
//        view.showProgress()
//        let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
//        let params : [String:Any] = ["version": version ?? "1"]
//        AlamoFireNetworking.sharedClient.getSettings(params: params, completed: @escaping () -> ()) {
//            if error == nil {
//                self.view.dismissProgress()
//                if response?.required_masked == true {
//                    completionHandler(false)
//                } else {
//                    completionHandler(true)
//                }
//            } else {
//                self.view.dismissProgress()
//                completionHandler(false)
//            }
//        }
//    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
    func setCurrentLayer(_ layer: LoginLayer) {
        resetView()
        currentLayer = layer
        switch currentLayer {
        case .login:
            self.tfLoginUsername.text = ""
            self.tfLoginPassword.text = ""
            loginView.isHidden = false
        case .register1:
            registerView1.isHidden = false
        case .register2:
            registerView2.isHidden = false
        case .forgot:
            forgotView.isHidden = false
        case .forgotUid1:
            forgotUIDView1.isHidden = false
        case .forgotUid2:
            forgotUIDView2.isHidden = false
        case .forgotPassword1:
            forgotPasswordView1.isHidden = false
        case .forgotPassword2:
            forgotPasswordView2.isHidden = false
        default:
            resetView()
        }
    }
    
    func resetView() {
        loginView.isHidden = true
        registerView1.isHidden = true
        registerView2.isHidden = true
        forgotView.isHidden = true
        forgotUIDView1.isHidden = true
        forgotUIDView2.isHidden = true
        forgotPasswordView1.isHidden = true
        forgotPasswordView2.isHidden = true
        setSavePassImage()
    }
    
    func setSavePassImage() {
        if shouldSavePass == true {
            imgViewSavePass.image = .rememberPassActive
        } else {
            imgViewSavePass.image = .rememberPass
        }
    }
    
    @IBAction func customerServiceClicked(_ sender: Any) {
        CoreSingletonData.shared.webViewType = .liveChat
        CoreSingletonData.shared.toOpenUrl = CoreSingletonData.shared.customerServiceUrl
        self.performSegue(withIdentifier: "openWebview", sender: nil)
    }
}

extension LoginViewController {
    @IBAction func forgotClicked(_ sender: Any) {
        self.setCurrentLayer(.forgot)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        self.setCurrentLayer(.register1)
    }
    
    @IBAction func rememberPassClicked(_ sender: Any) {
        shouldSavePass = !shouldSavePass
        setSavePassImage()
    }
    
    @IBAction func startLogin(_ sender: Any) {
        guard let username = tfLoginUsername.text, let password = tfLoginPassword.text, username != "", password != "" else {
            let alert = UIAlertController(title: "Attention!", message: "Please Enter Username and Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        let params : [String:Any] = ["username": username,
                                     "password": password,
                                     "deviceToken": CoreSingletonData.shared.fcmToken ?? "123456"]
        view.showProgress()
        AlamoFireNetworking().postLogin(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                if response?.status == 1 {
                    if self.shouldSavePass == true {
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.synchronize()
                    } else {
                        UserDefaults.standard.set(nil, forKey: "username")
                        UserDefaults.standard.set(nil, forKey: "password")
                        UserDefaults.standard.synchronize()
                    }
                    CoreSingletonData.shared.token = response?.token
                    let main = UIStoryboard(name: "Q", bundle: nil)
                    let dashboardController = main.instantiateViewController(withIdentifier: "TabBarController") as! TabbarViewController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window!!.rootViewController = UINavigationController(rootViewController: dashboardController)
                    appDelegate?.window!!.makeKeyAndVisible()
                } else {
                    let alert = UIAlertController(title: "Error", message: response?.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
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

// Forgot
extension LoginViewController {
    @IBAction func forgotBackClicked(_ sender: Any) {
        self.setCurrentLayer(.login)
    }
    
    @IBAction func forgotUidClicked(_ sender: Any) {
        self.setCurrentLayer(.forgotUid1)
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        self.setCurrentLayer(.forgotPassword1)
    }
}

// Forgot UID
extension LoginViewController {
    @IBAction func forgotUidBackClicked(_ sender: Any) {
        self.setCurrentLayer(.forgot)
    }
    
    @IBAction func forgotUidNextClicked(_ sender: Any) {
        self.tfForgotUid2Mobile.text = self.tfForgotUidMobile.text
        self.setCurrentLayer(.forgotUid2)
    }
}

// Forgot UID 2
extension LoginViewController {
    @IBAction func forgotUid2BackClicked(_ sender: Any) {
        self.setCurrentLayer(.forgotUid1)
    }
    
    @IBAction func forgotUidTacClicked(_ sender: Any) {
        view.showProgress()
        let params : [String:Any] = ["mobileNumber":self.tfForgotUid2Mobile.text ?? ""]
        AlamoFireNetworking().postForgotUidGetTac(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                })
            }
        }
    }
    
    @IBAction func forgotUidSubmitClicked(_ sender: Any) {
        view.showProgress()
        let params : [String:Any] = ["mobileNumber":self.tfForgotUid2Mobile.text ?? "",
                                     "TAC":self.tfForgotUid2Tac.text ?? ""]
        AlamoFireNetworking().postForgotUidVerifyTac(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.tfForgotUid2Mobile.text = ""
                self.tfForgotUid2Tac.text = ""
                self.tfForgotUidMobile.text = ""
                self.setCurrentLayer(.login)
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                })
            }
        }
    }
}

// Forgot Password
extension LoginViewController {
    @IBAction func forgotPasswordBackClicked(_ sender: Any) {
        self.setCurrentLayer(.forgot)
    }
    
    @IBAction func forgotPasswordNextClicked(_ sender: Any) {
        self.tfForgotPassword2Mobile.text = self.tfForgotPasswordMobile.text
        self.setCurrentLayer(.forgotPassword2)
    }
}

// Forgot Password 2
extension LoginViewController {
    @IBAction func forgotPassword2BackClicked(_ sender: Any) {
        self.setCurrentLayer(.forgotPassword1)
    }
    
    @IBAction func forgotPasswordTacClicked(_ sender: Any) {
        view.showProgress()
        let params : [String:Any] = ["mobileNumber":self.tfForgotPassword2Mobile.text ?? "",
                                     "userName":self.tfForgotPasswordUsername.text ?? ""]
        AlamoFireNetworking().postForgotPasswordGetTac(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                })
            }
        }
    }
    
    @IBAction func forgotPasswordSubmitClicked(_ sender: Any) {
        view.showProgress()
        let params : [String:Any] = ["userName":self.tfForgotPasswordUsername.text ?? "",
                                     "password":self.tfForgotPassword2Password.text ?? "",
                                     "TAC":self.tfForgotPassword2Tac.text ?? ""]
        AlamoFireNetworking().postForgotPasswordVerifyTac(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.tfForgotPasswordUsername.text = ""
                self.tfForgotPassword2Password.text = ""
                self.tfForgotPassword2Mobile.text = ""
                self.tfForgotPasswordMobile.text = ""
                self.tfForgotPassword2Tac.text = ""
                self.setCurrentLayer(.login)
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                })
            }

        }
    }
}

// Register
extension LoginViewController {
    @IBAction func register1BackClicked(_ sender: Any) {
        self.setCurrentLayer(.login)
    }
    
    @IBAction func registerReferralCameraClicked(_ sender: Any) {
        performSegue(withIdentifier: "qrScan", sender: nil)
    }
    
    @IBAction func registerNextClicked(_ sender: Any) {
        view.showProgress()
        if self.tfRegisterPassword.text == self.tfRegisterConfirmPassword.text {
            let params : [String:Any] = ["username":self.tfRegisterUsername.text ?? "",
                                         "password":self.tfRegisterPassword.text ?? "",
                                         "mobileNumber":self.tfRegisterMobile.text ?? "",
                                         "referralCode":self.tfRegisterReferral.text ?? ""]
            AlamoFireNetworking().postRegisterUser(params: params) { response, error in
                if error == nil {
                    self.view.dismissProgress()
                    if response?.status == 1 {
                        self.tfRegister2Mobile.text = self.tfRegisterMobile.text
                        self.setCurrentLayer(.register2)
                    }
                } else {
                    self.view.dismissProgress()
                    showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                        guard self != nil else { return }
                    })
                }
            }
        }
    }
    
    @objc func setReferralCode() {
        guard let qrCode = CoreSingletonData.shared.scannedQrForReferral else { return }
        
        let qrContent = qrCode.components(separatedBy: "referral=")
        self.tfRegisterReferral.text = qrContent.last
    }
}

// Register 2
extension LoginViewController {
    @IBAction func register2BackClicked(_ sender: Any) {
        self.setCurrentLayer(.register1)
    }
    
    @IBAction func registerTacClicked(_ sender: Any) {
        view.showProgress()
        let params : [String:Any] = ["userName":self.tfRegisterUsername.text ?? ""]
        AlamoFireNetworking().postRegisterFireTac(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                })
            }
        }
    }
    
    @IBAction func registerSubmitClicked(_ sender: Any) {
        view.showProgress()
        let params : [String:Any] = ["userName":self.tfRegisterUsername.text ?? "",
                                     "tacNumber":self.tfRegister2Tac.text ?? ""]
        AlamoFireNetworking().postRegisterVerifyTac(params: params) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.tfRegisterUsername.text = ""
                self.tfRegister2Tac.text = ""
                self.tfRegisterPassword.text = ""
                self.tfRegisterMobile.text = ""
                self.tfRegisterReferral.text = ""
                self.setCurrentLayer(.login)
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                })
            }
        }
    }
}
