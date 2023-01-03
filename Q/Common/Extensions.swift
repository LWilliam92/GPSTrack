//
//  Extensions.swift
//  QPlus
//
//  Created by Kar Wai Ng on 12/07/2022.
//

import Foundation
import UIKit

public extension UIView {
    func layoutAttachAll(to: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        to.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: to, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        to.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: to, attribute: .top, multiplier: 1.0, constant: 0.0))
        to.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: to, attribute: .leading, multiplier: 1.0, constant: 0.0))
        to.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: to, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}

extension UIColor {
    static let tint = UIColor(named: ConstantsImageAsset.Common.tint) ?? .systemBlue
    static let clear = UIColor.clear
    static let gameBackground = UIColor(named: ConstantsImageAsset.Common.gameBackground) ?? .gray
    static let gameCollectionBackground = UIColor(named: ConstantsImageAsset.Common.gameCollectionBackground) ?? .gray
    static let allGames = UIColor(named: ConstantsImageAsset.GameCollection.allGames) ?? .blue
    static let eSports = UIColor(named: ConstantsImageAsset.GameCollection.eSports) ?? .blue
    static let live = UIColor(named: ConstantsImageAsset.GameCollection.live) ?? .blue
    static let lottery = UIColor(named: ConstantsImageAsset.GameCollection.lottery) ?? .blue
    static let slots = UIColor(named: ConstantsImageAsset.GameCollection.slots) ??  .blue
    static let sports = UIColor(named: ConstantsImageAsset.GameCollection.sports) ?? .blue
    
    static let baseFontColor = UIColor(named: Constants.Common.baseFontColor) ?? .blue
    static let greyFontColor = UIColor(named: Constants.Common.greyfontColor) ?? .blue
    
    static let checkInBackgroundColor = UIColor(named: Constants.CheckIn.checkInBackgroundColor) ?? .blue
    static let checkInBackgroundActiveColor = UIColor(named: Constants.CheckIn.checkInBackgroundActiveColor) ?? .blue
    static let checkInDayFontColor = UIColor(named: Constants.CheckIn.checkInDayFontColor) ?? .blue
    static let checkInDayActiveFontColor = UIColor(named: Constants.CheckIn.checkInDayActiveFontColor) ?? .blue
    static let checkInButtonFontColor = UIColor(named: Constants.CheckIn.CheckInWeekFontColor) ?? .blue
    
    
    static let segmentActive = UIColor(named: Constants.Common.segmentActive) ?? .blue
    static let segmentInactive = UIColor(named: Constants.Common.segmentInactive) ?? .blue
    
    static let fontActive = UIColor(named: Constants.Common.fontActive) ?? .blue
    static let fontInactive = UIColor(named: Constants.Common.fontInactive) ?? .blue
    static let paymentFontInactive = UIColor(named: Constants.Common.paymentFontInactive) ?? .blue
    
    static let navTitle = UIColor(named: Constants.Common.navTitle) ?? .blue
    static let transferSuccess = UIColor(red: 139.0/255.0, green: 197.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    static let transferFail = UIColor(red: 236.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    
    static let vipProgressBar = UIColor(red: 58.0/255.0, green: 50.0/255.0, blue: 237.0/255.0, alpha: 1.0)
}

extension CAGradientLayer {
    convenience init(start: CGPoint.Point, end: CGPoint.Point, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}

extension CGPoint {
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
}
extension UIImage {
    static let navMenu = UIImage.init(named: "menu")
    static let navBackChevron = UIImage.init(named: "backChevron")
    static let navClose = UIImage.init(named: "close")
    
    static let home = UIImage.init(named: "home")
    static let homeSelected = UIImage.init(named: "homeSelected")
    
    static let activity = UIImage.init(named: "activity")
    static let activitySelected = UIImage.init(named: "activitySelected")
    
    static let transaction = UIImage.init(named: "transaction")
    static let transactionSelected = UIImage.init(named: "transactionSelected")
    
    static let payment = UIImage.init(named: "payment")
    static let paymentSelected = UIImage.init(named: "paymentSelected")
    
    static let allGames = UIImage.init(named: "allGames")
    static let liveGames = UIImage.init(named: "live")
    static let slotsGames = UIImage.init(named: "slots")
    static let sportsGames = UIImage.init(named: "sports")
    static let lotteryGames = UIImage.init(named: "lottery")
    static let eSportsGames = UIImage.init(named: "eSports")
    
    static let allGamesSelected = UIImage.init(named: "allGamesSelected")
    static let liveGamesSelected = UIImage.init(named: "liveSelected")
    static let slotsGamesSelected = UIImage.init(named: "slotsSelected")
    static let sportsGamesSelected = UIImage.init(named: "sportsSelected")
    static let lotteryGamesSelected = UIImage.init(named: "lotterySelected")
    static let eSportsGamesSelected = UIImage.init(named: "eSportsSelected")
    
    static let allGamesBackground = UIImage.init(named: "allGamesBackground")
    static let liveGamesBackground = UIImage.init(named: "liveBackground")
    static let slotsGamesBackground = UIImage.init(named: "slotsBackground")
    static let sportsGamesBackground = UIImage.init(named: "sportsBackground")
    static let lotteryGamesBackground = UIImage.init(named: "lotteryBackground")
    static let eSportsGamesBackground = UIImage.init(named: "eSportsBackground")
    
    static let activityNotification = UIImage.init(named: "notification")
    static let activityOrderHistory = UIImage.init(named: "orderHistory")
    static let activityRebate = UIImage.init(named: "rebate")
    static let activityTransfer = UIImage.init(named: "transfer")
    static let activityCheckIn = UIImage.init(named: "checkIn")
    static let activityMission = UIImage.init(named: "mission")
    
    static let checkInWeek1 = UIImage.init(named: "weekOne")
    static let checkInWeek1Active = UIImage.init(named: "weekOneHighlighted")
    static let checkInWeek2 = UIImage.init(named: "weekTwo")
    static let checkInWeek2Active = UIImage.init(named: "weekTwoHighlighted")
    static let checkInWeek3 = UIImage.init(named: "weekThree")
    static let checkInWeek3Active = UIImage.init(named: "weekThreeHighlighted")
    static let checkInWeek4 = UIImage.init(named: "weekFour")
    static let checkInWeek4Active = UIImage.init(named: "weekFourHighlighted")
    
    static let checkInDaily = UIImage.init(named: "dailyReward")
    static let checkInDailyDay7 = UIImage.init(named: "dailyRewardDaySeven")
    static let checkInDailyAchieved = UIImage.init(named: "dailyRewardDone")
    
    static let checkInBackground = UIImage.init(named: "checkInBackground")
    static let checkInBackgroundDone = UIImage.init(named: "checkInBackgroundClicked")
    
    static let paymentGateway = UIImage.init(named: "paymentGateway")
    static let bankTransfer = UIImage.init(named: "bankTransfer")
    static let touchNGo = UIImage.init(named: "touchNGo")
    static let withdraw = UIImage.init(named: "withdraw")
    
    static let paymentGatewaySelected = UIImage.init(named: "paymentGatewaySelected")
    static let bankTransferSelected = UIImage.init(named: "bankTransferSelected")
    static let touchNGoSelected = UIImage.init(named: "touchNGoSelected")
    static let withdrawSelected = UIImage.init(named: "withdrawSelected")
    
    static let paymentType = UIImage.init(named: "paymentType")
    static let paymentTypeSelected = UIImage.init(named: "paymentTypeSelected")
    static let paymentAdd = UIImage.init(named: "paymentAdd")
    
    static let bank00 = UIImage.init(named: "01Maybank")
    static let bank01 = UIImage.init(named: "02CIMB")
    static let bank02 = UIImage.init(named: "03HongLeong")
    static let bank03 = UIImage.init(named: "04PublicBank")
    static let bank04 = UIImage.init(named: "05RHB")
    static let bank05 = UIImage.init(named: "06AmBank")
    static let bank06 = UIImage.init(named: "07UOB")
    static let bank07 = UIImage.init(named: "08Affin")
    static let bank08 = UIImage.init(named: "09HSBC")
    static let bank09 = UIImage.init(named: "10OCBC")
    static let bank10 = UIImage.init(named: "11BSN")
    static let bank11 = UIImage.init(named: "12BankRakyat")
    static let bank12 = UIImage.init(named: "13BankIslam")
    static let bank13 = UIImage.init(named: "14DuitNow")
    static let bank14 = UIImage.init(named: "15TouchNGo")
    static let bank15 = UIImage.init(named: "16Agro")
    static let bank16 = UIImage.init(named: "17AlRajhi")
    
    
    static let settingChangePass = UIImage.init(named: "changePass")
    static let settingChangePin = UIImage.init(named: "changePin")
    static let settingReferrer = UIImage.init(named: "referrer")
    static let settingUsername = UIImage.init(named: "username")
    static let settingMobileNo = UIImage.init(named: "mobileNo")
    static let settingLanguage = UIImage.init(named: "language")

    
    static let rememberPass = UIImage.init(named: "rememberPass")
    static let rememberPassActive = UIImage.init(named: "rememberPassActive")
    
    static let transferSuccess = UIImage.init(named: "transferSuccess")
    static let transferFail = UIImage.init(named: "transferFail")

    static func getGradientImage(colors: [UIColor],
                                 locations: [Float],
                                 size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        gradientLayer.render(in: context)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    static func getBankLogo(_ bankId: Int) -> UIImage {
        switch bankId {
        case 0:
            return .bank00!
        case 1:
            return .bank01!
        case 2:
            return .bank02!
        case 3:
            return .bank03!
        case 4:
            return .bank04!
        case 5:
            return .bank05!
        case 6:
            return .bank06!
        case 7:
            return .bank07!
        case 8:
            return .bank08!
        case 9:
            return .bank09!
        case 10:
            return .bank10!
        case 11:
            return .bank11!
        case 12:
            return .bank12!
        case 13:
            return .bank13!
        case 14:
            return .bank14!
        case 15:
            return .bank15!
        case 16:
            return .bank16!
        default:
            return .bank00!
        }
    }
    
    func toBase64Png() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString()
    }
    
    func toBase64Jpeg (_ compression: CGFloat = 1.0) -> String? {
        guard let imageData = self.jpegData(compressionQuality: compression) else { return nil }
        return imageData.base64EncodedString()
    }
}

extension String {
    func getEncodingUrl() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    func asInt() -> Int {
        return Int(self) ?? 0
    }
    
    func asDouble() -> Double {
        return Double(self) ?? 0.00
    }
    
    func asCurrencyDecimalWithCurrency() -> String {
        return String(format: "Currency.Amount.text".localized(), self.asDouble())
    }
}

extension Double {
    func asCurrencyDecimal(_ withCurrencyLabel: Bool? = false) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        if !(withCurrencyLabel ?? false) {
            numberFormatter.currencySymbol = ""
        }
        return numberFormatter.string(from: self as NSNumber)!
    }
    
    func asPercentage() -> String {
        return String(format: "%d%%", self.asInt())
    }
    
    func asInt() -> Int {
        return Int(self)
    }
    
    func asFloat() -> Float {
        return Float(self)
    }
}

extension Int {
    func asStringDigit() -> String {
        return String(format: "%d", self)
    }
    
    func asCurrencyDecimal(_ withCurrencyLabel: Bool? = false) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        if !(withCurrencyLabel ?? false) {
            numberFormatter.currencySymbol = ""
        }
        return numberFormatter.string(from: self as NSNumber)!
        
//        return String(format: "%.2f", Float(self))
    }
}

extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.placeholderColor(newValue!)
        }
    }
    @IBInspectable var setDefaultPlaceHolderColor: String? {
        get {
            return nil
        }
        set {
            self.defaultPlaceholderColor()
        }
    }
    
    func defaultPlaceholderColor(){
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
    }
    
    func placeholderColor(_ color: UIColor){
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
