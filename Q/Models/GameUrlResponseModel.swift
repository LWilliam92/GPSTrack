//
//  GameUrlResponseModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 17/09/2022.
//

import Foundation

struct GameUrlResponseModel: Decodable {
    let status: Int?
    let message: String?
    let hide_back_button: Bool?
    let url: String?
}
