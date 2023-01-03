//
//  LocalizationManager.swift
//  QPlus
//
//  Created by William Loke on 14/10/2022.
//

import Foundation

enum LocalizedFile: String {
    case `default` = "Localizable"
    case main = "Main"
}

extension Notification.Name {
    static let userLanguage = Notification.Name.init("userLanguage")
    static let deviceLanguageSettings = Notification.Name.init("deviceLanguageSettings")
}

class LocalizationManager {
    
    static let shared = LocalizationManager.init()
    
    private(set) var bundle = Bundle.init(path: Bundle.main.path(forResource: LocalizationManager.userLang(), ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")!)!
    
    static func userLang() -> String {
        var result = "en"
        if let userLang = UserDefaults.standard.string(forKey: Notification.Name.userLanguage.rawValue) {
            result = userLang
        } else {
            let current = Locale.preferredLanguages.first!
            if current.hasPrefix("zh-Hans") {
                result = "zh-Hans"
            } else if current.hasPrefix("zh-Hant") {
                result = "zh-Hant"
            } else {
                result = current
            }
        }
        return result
    }
    
    static func serverLang() -> String {
        let langs = ["en" : "en_US", "zh-Hans" : "zh_CN", "ms": "ms_MY"]
        return langs[self.userLang()] ?? "en_US"
    }
    
    static func setUserLang(_ lang: String) {
        UserDefaults.standard.set(lang, forKey: Notification.Name.userLanguage.rawValue)
        UserDefaults.standard.set([lang], forKey: Notification.Name.deviceLanguageSettings.rawValue)
        UserDefaults.standard.synchronize()
        
        LocalizationManager.shared.bundle = Bundle.init(path: Bundle.main.path(forResource: lang, ofType: "lproj")!)!
        
        NotificationCenter.default.performSelector(onMainThread: #selector(NotificationCenter.post(_:)), with: Notification.init(name: Notification.Name.deviceLanguageSettings, object: nil, userInfo: ["lang" : lang]), waitUntilDone: true)
    }
}

func LocalizedString(_ key: String, tableName: String? = "Localizable", bundle: Bundle = LocalizationManager.shared.bundle, value: String = "", comment: String) -> String {
    return bundle.localizedString(forKey: key, value: value, table: tableName)
}

extension String {
    func localized(tableName: String? = LocalizedFile.default.rawValue, bundle: Bundle = LocalizationManager.shared.bundle, value: String = "", comment: String? = nil) -> String {
        return LocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment ?? self)
    }
}
