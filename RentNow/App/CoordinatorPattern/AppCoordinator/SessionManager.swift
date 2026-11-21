//
//  SessionManager.swift
//  Holool
//
//  Created by Elshamy on 23/11/2025.
//

import Foundation
import Combine

// MARK: - Session Manager
final class SessionManager {
    
    // MARK: - Shared Instance
    static let shared = SessionManager()
    
    // MARK: - Publishers
    let sessionExpired = PassthroughSubject<Void, Never>()
    
    private init() {}
    
    // MARK: - Methods
    func handleSessionExpired() {
        DispatchQueue.main.async { [weak self] in
            UserDefaults.isLogin = false
            UserDefaults.user = nil
            UserDefaults.accessToken = nil
     
            self?.sessionExpired.send()
        }
    }
}
