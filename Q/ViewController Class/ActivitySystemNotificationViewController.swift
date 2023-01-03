//
//  ActivitySystemNotificationViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 29/09/2022.
//

import Foundation
import UIKit
import iProgressHUD

class ActivitySystemNotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationList: [NotificationModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotificationList()
    }
    
    func setupView() {
        let bundle = Bundle(for: NotificationTableViewCell.self)
        let tableNib = UINib(nibName: "NotificationTableViewCell", bundle: bundle)
        notificationTableView.register(tableNib, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier())
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
    }
    
    func getNotificationList() {
        view.showProgress()
        AlamoFireNetworking().getNotification(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.notificationList = response?.content
                if self.notificationList?.count ?? 0 > 0 {
                    self.notificationTableView.reloadData()
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

extension ActivitySystemNotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = notificationList?[indexPath.row],
              let cell = self.notificationTableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier()) as? NotificationTableViewCell else { return UITableViewCell() }
        
        cell.setCell(item: item)
        
        return cell
    }
}


