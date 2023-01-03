//
//  RebateInfoModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 28/09/2022.
//

import Foundation

struct RebateInfoModel: Decodable {
    let status: Int?
    let new_register: Int?
    let active_player: Int?
    let total_player: Int?
    let downline_total_turnover: Int?
    let direct_referrer_count: Int?
    let direct_referrer_rebate: Double?
    let user_own_rebate: Double?
    let user_total_rebate: Double?
}
