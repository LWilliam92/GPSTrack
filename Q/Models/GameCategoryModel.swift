//
//  GameCategoryModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 09/08/2022.
//

import Foundation

class GameCategoryModel {
    public let item: GameCategoryResponseModel
    public var isActive: Bool
    
    public init(item: GameCategoryResponseModel, isActive: Bool) {
        self.item = item
        self.isActive = isActive
    }
    
    func refresh() {
        self.isActive = false
    }
}
