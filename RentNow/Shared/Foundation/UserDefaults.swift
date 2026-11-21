//
//  UserDefaults.swift
//  App
//
//  Created by MGAbouarab on 30/12/2023.
//

import Foundation

@propertyWrapper
struct ValueDefault<Value> {
    
    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.value(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct ModelsDefault<Model: Codable> {
    
    let key: String
    let defaultValue: Model
    let container: UserDefaults = .standard
    
    var wrappedValue: Model {
        get {
            let decoder = JSONDecoder()
            guard let decoded = container.object(forKey: key) as? Data else {return defaultValue}
            let loadedValue = try? decoder.decode(Model.self, from: decoded)
            return loadedValue ?? defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                container.set(encoded, forKey: key)
                container.synchronize()
            }
        }
    }
}

extension UserDefaults {
    
    private enum Keys: String {
        case googleMapKey
        case accessToken
        case pushNotificationToken
        case isFirstTime
        case isLogin
        case user
        case isVisitor
        case cartCount
        case didRecive
        case isLocationSelected
        case savedLanguage
        case selectedAirportName
    }
    
    @ModelsDefault(key: Keys.user.rawValue, defaultValue: nil)
    static var user: User?
    
  
    @ValueDefault(key: Keys.isVisitor.rawValue, defaultValue: true)
    static var isVisitor: Bool
    
    @ValueDefault(key: Keys.googleMapKey.rawValue, defaultValue: "AIzaSyBCtrxqozj9xLkL58Frh0Gl4fiQZ_oATZI")
    static var googleMapKey: String
    
    @ModelsDefault(key: Keys.accessToken.rawValue, defaultValue: nil)
    static var accessToken: String?
    
    
    @ModelsDefault(key: Keys.didRecive.rawValue, defaultValue: false)
    static var didRecive: Bool?
    
    @ValueDefault(key: Keys.pushNotificationToken.rawValue, defaultValue: nil)
    static var pushNotificationToken: String?
    
    @ValueDefault(key: Keys.cartCount.rawValue, defaultValue: "0")
    static var cartCount: String?
    
    @ValueDefault(key: Keys.isFirstTime.rawValue, defaultValue: true)
    static var isFirstTime: Bool

    @ValueDefault(key: Keys.savedLanguage.rawValue, defaultValue: "")
    static var savedLanguage: String

    @ValueDefault(key: Keys.selectedAirportName.rawValue, defaultValue: "")
    static var selectedAirportName: String
    
    @ValueDefault(key: Keys.isLogin.rawValue, defaultValue: false)
    static var isLogin: Bool {
        didSet {
            NotificationCenter.default.post(name: .isLoginChanged, object: nil)
        }
    }
    
}
