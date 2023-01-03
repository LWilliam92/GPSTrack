//
//  SystemNotificationModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 29/09/2022.
//

import Foundation

struct SystemNotificationModel: Decodable {
    let status: Int?
    let content: [NotificationModel]?
}

struct NotificationModel: Decodable {
    let text: String?
    let date: String?
}
