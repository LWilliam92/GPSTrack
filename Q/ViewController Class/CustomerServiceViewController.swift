//
//  CustomerServiceViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 11/09/2022.
//

import UIKit
import iProgressHUD

class CustomerServiceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setupNavBar(false)
    }
    
    func setupView() {
        setupNavBar(true)
    }
    
    func setupNavBar(_ change: Bool) {
        if change == true {
            if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
                textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
                navigationController?.navigationBar.titleTextAttributes = textAttributes
                self.navigationController?.navigationBar.tintColor = UIColor.white;
            }
        } else {
            if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
                textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.navTitle
                navigationController?.navigationBar.titleTextAttributes = textAttributes
                self.navigationController?.navigationBar.tintColor = UIColor.systemBlue;
            }
        }
    }
    
    @IBAction func helpClicked(_ sender: Any) {
        if CoreSingletonData.shared.gameList?.live_chat_url.isEmptyOrNil == false {
            CoreSingletonData.shared.webViewType = .liveChat
            CoreSingletonData.shared.toOpenUrl = CoreSingletonData.shared.gameList?.live_chat_url
            self.performSegue(withIdentifier: "openWebview", sender: nil)
        }
    }
}
