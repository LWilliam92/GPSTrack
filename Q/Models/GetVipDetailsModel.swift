//
//  GetVipDetailsModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 03/11/2022.
//

import Foundation

struct GetVipDetailsModel: Decodable {
    let status: Int?
    let message: String?
    let contact_number: String?
    let user_name: String?
    let vip_level: Int?
    let percent_achieved: Double?
    
    let daily_withdraw_amount: Double?
    let daily_withdraw_times: Int?
    
    let reload_completed: Double?
    let reload_left: Double?
    let transfer_credit_times: Int?
    let turnover_completed: Double?
    let turnover_left: Double?
    let rebate: [VipRebateModel]?
}

struct VipRebateModel: Decodable {
    let daily_withdraw_amount: Int?
    let daily_withdraw_times: Int?
    let reload_completed: Int?
    let reload_left: Double?
    let transfer_credit_times: Int?
    let turnover_completed: Int?
    let turnover_left: Double?
    let vip_level: Int?
    let percent: [VipPercentModel]?
}

struct VipPercentModel: Decodable {
    let game_id: Int?
    let game_name: String?
    let rebate_percent: Double?
}
