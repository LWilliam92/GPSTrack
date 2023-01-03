//
//  ActivityOrderHistoryViewController.swift
//  VTB_iOS
//
//  Created by Kar Wai Ng on 22/10/2022.
//

import UIKit
import iProgressHUD

class ActivityOrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    
    var transactionList: [OrderHistoryModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTransactionHistory()
    }
    
    func setupView() {
        self.navigationItem.title = "Activity".localized()
        let bundle = Bundle(for: OrderHistoryTableViewCell.self)
        let tableNib = UINib(nibName: "OrderHistoryTableViewCell", bundle: bundle)
        transactionTableView.register(tableNib, forCellReuseIdentifier: OrderHistoryTableViewCell.reuseIdentifier())
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
    }
    
    func getTransactionHistory() {
        view.showProgress()
        AlamoFireNetworking().getDepositRecordList(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.transactionList = response?.deposit_list
                self.transactionTableView.reloadData()
            } else {
                self.view.dismissProgress()
                showAlertView("Service Temporary Unavailable", "", controller: self, completion: { [weak self] in
                    guard self != nil else { return }
                    performLogout()
                })
            }
        }
    }
    
    @IBAction func refreshTransactionList(_ sender: UIButton) {
        getTransactionHistory()
    }
}

extension ActivityOrderHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = transactionList?[indexPath.row],
              let cell = self.transactionTableView.dequeueReusableCell(withIdentifier: OrderHistoryTableViewCell.reuseIdentifier()) as? OrderHistoryTableViewCell else { return UITableViewCell() }
        
        cell.setCell(item: item)
        
        return cell
    }
}

