//
//  Constants.swift
//  QPlus
//
//  Created by Kar Wai Ng on 06/07/2022.
//

import Foundation

struct Constants {
    struct Common {
        static let number = "1234567890"
        static let baseFontColor = "BaseFont"
        static let greyfontColor = "GreyFont"
        
        static let navTitle = "Nav Title"
        static let segmentActive = "SegmentActive"
        static let segmentInactive = "SegmentInactive"
        static let fontActive = "FontActive"
        static let fontInactive = "FontInactive"
        static let paymentFontInactive = "PaymentFontInactive"
    }
    
    struct API {
        static let baseURL = "https://qpapi.qhuat888.com/"
        static let getAppSetting = "api/GetAppSetting"
        static let loginURL = "LoginAccountV2"
        static let getGameListURL = "GetGameListV2"
        static let getUserInfoURL = "GetUserInformation"
        static let getDailyRewardDetail = "GetDailyRewardDetails"
        static let postDailyManualCheckIn = "DailyManualCheckIn"
        static let postClaimDailyCheckIn = "ClaimDailyCheckIn"
        static let getBetRewardDetail = "GetBetRewardDetails"
        static let getDepositBankInList = "GetDepositBankInList"
        static let getExistPendingWithdrawalRecord = "GetExistPendingWithdrawalRecord"
        static let setPaymentPin = "SetPaymentPin"
        static let updatePassword = "UpdatePassword"
        static let updateUserLanguage = "UpdateUserLanguage"
        static let getTransferRecord = "GetTransferRecord"
        static let getDepositRecordList = "GetDepositRecordList"
        static let getBankInList = "GetBankInList"
        static let getGameUrl = "GetGameUrl"
        static let addBankAccount = "AddBankAccount"
        static let getRebatePercent = "GetRebatePercent"
        static let getNotification = "GetNotification"
        static let generatePaymentGatewayUrl = "GeneratePaymentGatewayUrl"
        static let postDepositMoneyWithReceipt = "DepositMoneyWithReceiptV2"
        static let removeBankAccount = "RemoveBankAccount"
        static let postClaimBetReward = "ClaimBetReward"
        
        static let postForgetUidGetTac = "ForgetUIDGetTac"
        static let postForgetUidVerifyTac = "VerifyForgetUID"
        static let postForgetPasswordGetTac = "ForgotPasswordRequestTAC"
        static let postForgetPasswordVerifyTac = "VerifyForgotPassword"
        static let postRegisterFireTac = "FireTAC"
        static let postRegisterVerifyTac = "VerifyTAC"
        static let postRegister = "RegisterUser"
        static let walletTransferIn = "WalletTransferIn"
        static let getLogoutGameBalance = "LogOutGetBalance"
        static let withdrawFromBankAccount = "PerformCashWithdrawal"
        static let getUsernameWithReferral = "GetUserNameWithReferral"
        static let postTransferCredit = "TransferCredit"
        static let getInfoUrl = "GetInfoUrl"
        static let getVIPDetails = "GetVIPDetails"
        static let getBankList = "GetBankList"
    }
    
    struct CheckIn {
        static let activeState = "Active"
        static let inactiveState = "Inactive"
        static let checkInBackgroundColor = "CheckInBackground"
        static let checkInBackgroundActiveColor = "CheckInBackgroundActive"
        static let checkInDayFontColor = "CheckInDayFont"
        static let checkInDayActiveFontColor = "CheckInDayActiveFont"
        static let CheckInWeekFontColor = "CheckInWeekFont"
    }
    
}
