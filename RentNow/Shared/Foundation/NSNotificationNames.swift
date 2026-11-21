//
//  NSNotificationNames.swift
//  App
//
//  Created by MGAbouarab on 30/12/2023.
//

import Foundation

extension NSNotification.Name {
    
    /*
     Enum for Holding all strings keys as rawValues to avoid using Strings
     */
    private enum Names: String {
        case isLoginChanged
    }
    
    
    /*
     All Notification cases
     */
    static let isLoginChanged = Notification.Name(rawValue: Names.isLoginChanged.rawValue)
    static let orderStatusChanged = Notification.Name("orderStatusChanged")
    static let advertisementStatusChanged = Notification.Name("advertisementStatusChanged")

}
