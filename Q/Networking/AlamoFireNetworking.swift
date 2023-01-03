//
//  AlamoFireNetworking.swift
//  QPlus
//
//  Created by Kar Wai Ng on 06/07/2022.
//
import Foundation
import Alamofire

public class AlamoFireNetworking: NSObject {
    
    static let sharedClient: AlamoFireNetworking = AlamoFireNetworking()

    func alamofire(_ endpoint: String, method: HTTPMethod, token: Bool = false, params: Parameters? = nil, completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let headers: HTTPHeaders = !token ? [
            "Content-Type": "application/json; charset=utf-8"
            ] : [
                "Content-Type": "application/json",
                "TOKEN": CoreSingletonData.shared.token ?? ""
        ]
        
        if method == .post || method == .put {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params ?? [:])
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
        print("endpoint: [\(method.rawValue)]\(endpoint)")
        
        if let _ = NetworkReachabilityManager()?.isReachable {
            AF.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                print("response: \(response)")
                switch response.result {
                case .success(let value):
                    completion(value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}

// MARK: GET METHOD
extension AlamoFireNetworking {

    func getSettings(params: [String: Any], completion: @escaping (AppSettingModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getAppSetting)?version=\(params["version"] ?? "1")"
        
        alamofire(url, method: .get, token: false, params: [:]) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(AppSettingModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else {
                completion(nil,error)
            }
        }
    }
    
    
    func getGameList(params: [String: Any], completion: @escaping (GameListModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getGameListURL)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GameListModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getUserInfo(params: [String: Any], completion: @escaping (GetUserInfoModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getUserInfoURL)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GetUserInfoModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getDailyReward(params: [String: Any], completion: @escaping (DailyRewardDetailModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getDailyRewardDetail)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(DailyRewardDetailModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getBetRewardDetails(params: [String: Any], completion: @escaping (MissionRewardDetailModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getBetRewardDetail)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(MissionRewardDetailModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getDepositBankInList(params: [String: Any], completion: @escaping (DepositBankInListModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getDepositBankInList)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(DepositBankInListModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getExistingWithdrawalRecord(params: [String: Any], completion: @escaping (ExistingPendingWithdrawalModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getExistPendingWithdrawalRecord)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(ExistingPendingWithdrawalModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getDepositRecordList(params: [String: Any], completion: @escaping (OrderHistoryListModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getDepositRecordList)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(OrderHistoryListModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getTransferRecord(params: [String: Any], completion: @escaping (TransactionListResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getTransferRecord)"

        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(TransactionListResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getBankInList(params: [String: Any], completion: @escaping (DepositBankInListModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getBankInList)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(DepositBankInListModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getGameUrl(params: [String: Any], completion: @escaping (GameUrlResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getGameUrl)?gameId=\(params["gameId"] ?? "")&language=\(params["language"] ?? "")"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GameUrlResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getRebateInfo(params: [String: Any], completion: @escaping (RebateInfoModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getRebatePercent)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(RebateInfoModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getNotification(params: [String: Any], completion: @escaping (SystemNotificationModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getNotification)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(SystemNotificationModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func generatePaymentGatewayUrl(params: [String: Any], completion: @escaping (GeneratePaymentUrlModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.generatePaymentGatewayUrl)?bankId=\(params["bankId"] ?? "")&amount=\(params["amount"] ?? "")"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GeneratePaymentUrlModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getLogoutGameBalance(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getLogoutGameBalance)"

        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getUsernameWithReferralCode(params: [String: Any], completion: @escaping (GetUsernameWithReferralModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getUsernameWithReferral)?referralCode=\(params["referralCode"] ?? "")"

        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GetUsernameWithReferralModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getInfoUrl(params: [String: Any], completion: @escaping (GetInfoUrlModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getInfoUrl)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GetInfoUrlModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getVipDetails(params: [String: Any], completion: @escaping (GetVipDetailsModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getVIPDetails)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GetVipDetailsModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func getBankList(params: [String: Any], completion: @escaping (BankListResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.getBankList)"
        
        alamofire(url, method: .get, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(BankListResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
}

// MARK: POST METHOD
extension AlamoFireNetworking {
    func postLogin(params: [String: Any], completion: @escaping (LoginModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.loginURL)?username=\(params["username"] ?? "")&password=\(params["password"] ?? "")&deviceToken=\(params["deviceToken"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(LoginModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postDailyManualCheckIn(params: [String: Any], completion: @escaping (DailyManualCheckInModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postDailyManualCheckIn)"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(DailyManualCheckInModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postClaimDailyCheckIn(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postClaimDailyCheckIn)?dailyCheckInDays=\(params["dailyCheckInDays"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postChangePaymentPin(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.setPaymentPin)?oldPaymentPin=\(params["oldPaymentPin"] ?? "")&newPaymentPin=\(params["newPaymentPin"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postChangeLoginPassword(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.updatePassword)?originalPassword=\(params["originalPassword"] ?? "")&newPassword=\(params["newPassword"] ?? "")&confirmPassword=\(params["confirmPassword"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postChangeUserLanguage(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.updateUserLanguage)?locale=\(params["locale"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postAddBankAccount(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.addBankAccount)?bankId=\(params["bankId"] ?? "")&accountNumber=\(params["accountNumber"] ?? "")&accountName=\(params["accountName"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postBankTransfer(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postDepositMoneyWithReceipt)?amount=\(params["amount"] ?? "")&depositBankAccountId=\(params["depositBankAccountId"] ?? "")&fileName=\(params["fileName"] ?? "")&images=\(params["images"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postRemoveBankAccount(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.removeBankAccount)?usersBankAccountId=\(params["usersBankAccountId"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postClaimBetReward(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postClaimBetReward)?missionId=\(params["missionId"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postForgotUidGetTac(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postForgetUidGetTac)?mobileNumber=\(params["mobileNumber"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postForgotUidVerifyTac(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postForgetUidVerifyTac)?mobileNumber=\(params["mobileNumber"] ?? "")&TAC=\(params["TAC"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postForgotPasswordGetTac(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postForgetPasswordGetTac)?mobileNumber=\(params["mobileNumber"] ?? "")&userName=\(params["userName"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postForgotPasswordVerifyTac(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postForgetPasswordVerifyTac)?password=\(params["password"] ?? "")&userName=\(params["userName"] ?? "")&TAC=\(params["TAC"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postRegisterFireTac(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postRegisterFireTac)?userName=\(params["userName"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postRegisterVerifyTac(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postRegisterFireTac)?userName=\(params["userName"] ?? "")&tacNumber=\(params["tacNumber"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postRegisterUser(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postRegister)?username=\(params["username"] ?? "")&password=\(params["password"] ?? "")&mobileNumber=\(params["mobileNumber"] ?? "")&referralCode=\(params["referralCode"] ?? "")"
        alamofire(url, method: .post, token: false, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postWalletTransferIn(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.walletTransferIn)?gameId=\(params["gameId"] ?? "")&amount=\(params["amount"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postWithdrawFromBankAccount(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.withdrawFromBankAccount)?usersBankAccountId=\(params["usersBankAccountId"] ?? "")&amount=\(params["amount"] ?? "")&paymentPin=\(params["paymentPin"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
    
    func postTransferCredit(params: [String: Any], completion: @escaping (GenericEmptyResponseModel?, Error?) -> Void) {
        let url = Constants.API.baseURL + "\(Constants.API.postTransferCredit)?userName=\(params["userName"] ?? "")&amount=\(params["amount"] ?? "")"
        alamofire(url, method: .post, token: true, params: params) { result,error in
            if let response = result as? [String: Any] {
                do {
                    let decoder = JSONDecoder()
                    let values = try JSONSerialization.data(withJSONObject: response, options: [])
                    let object = try decoder.decode(GenericEmptyResponseModel.self, from: values)
                    completion(object,nil)
                } catch {
                    print("Error in model")
                }
            } else{
                completion(nil,error)
            }
        }
    }
}
