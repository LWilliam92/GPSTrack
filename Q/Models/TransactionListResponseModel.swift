//
//  TransactionListResponseModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 10/08/2022.
//

import Foundation

struct TransactionListResponseModel: Decodable {
    let status: Int?
    let result: [TransactionRecord]?
}

struct TransactionRecord: Decodable {
    let game_id: Int?
    let game_name: String?
    let game_image: String?
    let image_left: String?
    let image_right: String?
    let amount: String?
    let type: String?
    let main_wallet_balance: String?
    let created_date: String?
}
