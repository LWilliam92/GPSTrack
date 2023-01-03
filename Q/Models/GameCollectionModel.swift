//
//  GameCollectionModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 08/07/2022.
//

import Foundation

struct GameListModel: Decodable {
    let status: Int?
    let version: Int?
    let logged_in: Bool?
    let game_banner: [String]?
    let game_list: [GameCollectionModel]?
    let others_list: [GameCollectionModel]?
    let live_chat_url: String?
    let main_wallet_balance: Double?
    let rolling_chip: Double?
    let auto_pop_up_check_in: Bool?
    let announcement: String?
    let coming_soon: [String]?
    let coming_soon_image: [ComingSoonModel]?
}

struct GameCollectionModel: Decodable {
    let game_id: Int?
    let game_name: String?
    let images: String?
    let image_left: String?
    let image_right: String?
    let maintenance_images: String?
    let maintenance_images_v2: String?
    let category: String
    let open_browser: Bool?
    let open_ios_browser: Bool?
    let open_android_browser: Bool?
    let ios_enabled: Bool?
    let agree_checkbox: Bool?
    let warning_message: String?
    let is_maintenance: Bool?
    let rebate: String?
    let previous_bet: String?
    let current_bet: String?
    let points: String?
    let scheme: String?
    let scheme_download_url: String?
}

struct ComingSoonModel: Decodable {
    let game_name: String?
    let image_left: String?
    let image_right: String?
}
