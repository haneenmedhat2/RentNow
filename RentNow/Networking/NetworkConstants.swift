//
//  NetworkConstants.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation
import UIKit

struct NetworkConstants {
    private init() {}
    static let domain = "https://dashboard.rentnow-app.com/"
    static let port = "4898"
    static var server: String {
        return domain + "API/"
    }
    static var socket: String {
        "https://dashboard.rentnow-app.com:4898"
    }
}


let deviceId = UserDefaults.pushNotificationToken ?? "no device id for firebase for this device and this is an ios device"

let myUuid = UIDevice.current.identifierForVendor?.uuidString ?? String()
let ِappStoreUrl = "https://dashboard.rentnow-app.com/id1605447505"

let defaultLat = "23.8859"
let defaultLong = "45.0792"




//var appName = {
//    return "Shop Zone".coreLocalizable
//}()

var appCurrency = {
    return "SAR".localized
}()

//var appDistance = {
//    return "Km".coreLocalizable
//}()

var appDateFormate = {
    return "yyyy-MM-dd"
}()

var listLimit = {
   return 500
}()
