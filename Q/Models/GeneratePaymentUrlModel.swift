//
//  GeneratePaymentUrlModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 01/10/2022.
//

import Foundation

struct GeneratePaymentUrlModel: Decodable {
    let status: Int?
    let message: String?
    let url: String?
}
