//
//  GameCollectionData.swift
//  QPlus
//
//  Created by Kar Wai Ng on 29/12/2022.
//

import Foundation
class GameCollectionData {
    var game_id: Int?
    var game_name: String?
    var images: String?
    var image_left: String?
    var image_right: String?
    var maintenance_images: String?
    var maintenance_images_v2: String?
    var category: String
    var open_browser: Bool?
    var open_ios_browser: Bool?
    var open_android_browser: Bool?
    var ios_enabled: Bool?
    var agree_checkbox: Bool?
    var warning_message: String?
    var is_maintenance: Bool?
    var rebate: String?
    var previous_bet: String?
    var current_bet: String?
    var points: String?
    var scheme: String?
    var scheme_download_url: String?
    
    // Initializing property
    init(game: GameCollectionModel) {
        self.game_id = game.game_id
        self.game_name = game.game_name
        self.images = game.images
        self.image_left = game.image_left
        self.image_right = game.image_right
        self.maintenance_images = game.maintenance_images
        self.maintenance_images_v2 = game.maintenance_images_v2
        self.category = game.category
        self.open_browser = game.open_browser
        self.open_ios_browser = game.open_ios_browser
        self.open_android_browser = game.open_android_browser
        self.ios_enabled = game.ios_enabled
        self.agree_checkbox = game.agree_checkbox
        self.warning_message = game.warning_message
        self.is_maintenance = game.is_maintenance
        self.rebate = game.rebate
        self.previous_bet = game.previous_bet
        self.current_bet = game.current_bet
        self.points = game.points
        self.scheme = game.scheme
        self.scheme_download_url = game.scheme_download_url
    }
    
    init(comingSoonGame: ComingSoonModel) {
        self.game_id = -1
        self.game_name = comingSoonGame.game_name
        self.images = ""
        self.image_left = comingSoonGame.image_left
        self.image_right = comingSoonGame.image_right
        self.maintenance_images = ""
        self.maintenance_images_v2 = ""
        self.category = "99"
        self.open_browser = false
        self.open_ios_browser = false
        self.open_android_browser = false
        self.ios_enabled = false
        self.agree_checkbox = false
        self.warning_message = ""
        self.is_maintenance = false
        self.rebate = ""
        self.previous_bet = ""
        self.current_bet = ""
        self.points = ""
        self.scheme = ""
        self.scheme_download_url = ""
    }
    
}
