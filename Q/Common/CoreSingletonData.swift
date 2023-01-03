import Foundation

final class CoreSingletonData {
    enum WebviewType: Int {
        case game
        case paymentUrl
        case liveChat
        case mission
        case info
//        case openScheme
//        case start
//        case download
    }
    
    private init() { }
    
    static let shared: CoreSingletonData = CoreSingletonData()
    
    // Setup var to be used in all
    var isLoggedIn: Bool? = false
    var customerServiceUrl: String?
    var login: String?
    var token: String?
    var fcmToken: String?
    var userInfo: UserInfoModel?
    var payment_gateway_url: String?
    var selectedGame: Int?
    var gameList: GameListModel?
    var webViewType: WebviewType? = .none
    var toOpenUrl: String?
    var gameHost: String?
    var bank_list: [DepositBankDetailModel]?
    var selectedBankTransfer: DepositBankDetailModel?
    var deleteWithdrawAccountNumber: Int?
    var selectedMission: Int?
    var scannedQrForReferral: String?
    var qr: String?
    var scannedUsername: String?
}
