//
//  GetInfoUrlModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 02/11/2022.
//

import Foundation

struct GetInfoUrlModel: Decodable {
    let status: Int?
    let message: String?
    let url: String?
}
