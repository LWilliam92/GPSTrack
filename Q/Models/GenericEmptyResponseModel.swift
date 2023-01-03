//
//  GenericEmptyResponseModel.swift
//  VTB_iOS
//
//  Created by William Loke on 09/10/2022.
//

struct GenericEmptyResponseModel: Decodable {
    let status: Int
    let message: String?
}
