//
//  LoginModel.swift
//  QPlus
//
//  Created by William Loke on 31/07/2022.
//

struct LoginModel: Decodable {
    let status: Int
    let token: String?
    let message: String?
    let language: String?
}
