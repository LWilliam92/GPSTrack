//
//  AppSetting.swift
//  QPlus
//
//  Created by William Loke on 19/09/2022.
//

struct AppSettingModel: Decodable {
    let status: Int?
    let update: Bool
    let ios_url: String?
    let required_masked : Bool?
    let public_live_chat_url: String?
}
