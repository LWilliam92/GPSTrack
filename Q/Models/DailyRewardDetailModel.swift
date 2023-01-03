//
//  DailyRewardDetailModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 23/08/2022.
//

import Foundation
struct DailyRewardDetailModel: Decodable {
    let status: Int?
    let last_day: String?
    let current_login_days: Int?
    let reward_for_0_days: Int?
    let reward_for_7_days: Int?
    let reward_for_14_days: Int?
    let reward_for_21_days: Int?
    let reward_for_28_days: Int?
    let claimed_for_0_days: Bool?
    let claimed_for_7_days: Bool?
    let claimed_for_14_days: Bool?
    let claimed_for_21_days: Bool?
    let claimed_for_28_days: Bool?
}
