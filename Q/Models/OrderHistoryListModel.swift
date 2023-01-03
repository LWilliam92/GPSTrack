//
//  OrderHistoryListModel.swift
//  VTB_iOS
//
//  Created by Kar Wai Ng on 22/10/2022.
//

import Foundation

struct OrderHistoryListModel: Decodable {
    let status: Int?
    let deposit_list: [OrderHistoryModel]?
}

struct OrderHistoryModel: Decodable {
    let amount: String?
    let created_date: String?
    let account_no: String?
    let bank_account_holder: String?
    let receipt_url: String?
    let status: String?
    let reject_reason: String?
    let type: String?
}

