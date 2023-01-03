//
//  GetUserInfoModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 22/08/2022.
//

import Foundation
struct GetUserInfoModel: Decodable {
    let status: Int?
    let result: UserInfoModel?
    let payment_gateway_url: String?
}

struct UserInfoModel: Decodable {
    let user_name: String?
    let created_date: String?
    let main_wallet_balance: Double?
    let rolling_chip: Double?
    let is_payment_pin_already_setup: Bool?
    let vip_level: Int?
    let total_deposit_amount: Double?
    let referrer: String?
    let language: String?
    let referral_code: String?
    let referral_full_link: String?
    let mobile_number: String?
    let bank_list: [BankInfoModel]?
}

struct BankInfoModel: Decodable {
    let users_bank_account_id: Int?
    let bank_id: Int?
    let bank_name: String?
    let bank_account_no: String?
    let bank_account_holder: String?
}
