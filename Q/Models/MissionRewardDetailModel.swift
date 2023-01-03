//
//  MissionRewardDetailModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 27/08/2022.
//

import Foundation

struct MissionRewardDetailModel: Decodable {
    let status: Int?
    let announcement: String?
    let daily: [MissionDetailModel]?
    let weekly: [MissionDetailModel]?
    let monthly: [MissionDetailModel]?
    
    let daily_turnover: Int?
    let weekly_turnover: Int?
    let monthly_turnover: Int?
    let daily_deposit: Double?
    let weekly_deposit: Double?
    let monthly_deposit: Double?
}

struct MissionDetailModel: Decodable {
    let mission_title: String?
    let mission_description: String?
    let is_completed: Bool?
    let is_claimed: Bool?
    let game_id: Int?
    let game_name: String?
    let is_refer: Bool?
    let is_deposit: Bool?
    let curent_progress: Int?
    let game_image: String?
    let target_progress: Int?
    let reward_description: String?
    let game_details: GameCollectionModel?
    let mission_id: Int?
}
