//
//  ExistingPendingWithdrawalModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 11/09/2022.
//

import Foundation

struct ExistingPendingWithdrawalModel: Decodable {
    let status: Int?
    let data: WithdrawalModel?
}

struct WithdrawalModel: Decodable {
    let free_withdraw_times: Int?
    let services_charge: String?
}
