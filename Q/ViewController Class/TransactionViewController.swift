//
//  TransactionViewController.swift
//  QPlus
//
//  Created by Kar Wai Ng on 07/07/2022.
//

import Foundation
import UIKit
import iProgressHUD

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    
    var transactionList: [TransactionRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTransactionHistory()
    }
    
    func setupView() {
        let bundle = Bundle(for: TransactionTableViewCell.self)
        let tableNib = UINib(nibName: "TransactionTableViewCell", bundle: bundle)
        transactionTableView.register(tableNib, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier())
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
    }
    
    func getTransactionHistory() {
        view.showProgress()
        AlamoFireNetworking().getTransferRecord(params: [:]) { response, error in
            if error == nil {
                self.view.dismissProgress()
                self.transactionList = response?.result
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
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = transactionList?[indexPath.row],
              let cell = self.transactionTableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier()) as? TransactionTableViewCell else { return UITableViewCell() }
        
        cell.setCell(item: item)
        
        return cell
    }
}

