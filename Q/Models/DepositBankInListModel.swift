//
//  DepositBankInListModel.swift
//  QPlus
//
//  Created by Kar Wai Ng on 08/09/2022.
//

import Foundation

struct DepositBankInListModel: Decodable {
    let status: Int?
    
    let bank_transfer_list: [DepositBankDetailModel]?
    let payment_gateway_list: [DepositBankDetailModel]?
    let touch_and_go_details: DepositBankDetailModel?
}

struct DepositBankDetailModel: Decodable {
    let bank_id: Int?
    let bank_name: String?
    let bank_image: String?
    let bank_account_no: String?
    let bank_account_holder: String?
    let qr_code_url: String?
    let deposit_bank_account_id: Int?
}

struct BankListResponseModel: Decodable {
    let status: Int?
    let message: String?
    let bank: [BankListModel]
}

struct BankListModel: Decodable {
    let bank_id: Int?
    let bank_name: String?
    let bank_image: String?
}
