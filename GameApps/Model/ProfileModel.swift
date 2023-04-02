//
//  ProfileModel.swift
//  GameApps
//
//  Created by PLWEP on 02/04/23.
//

import Foundation

struct ProfileModel {
    static let nameKey = "name"
    static let emailKey = "email"
    
    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? "Permana Langgeng WEP"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? "langgeng86@gmail.com"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }
    
    static func deteleAll() -> Bool {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            synchronize()
            return true
        } else { return false }
    }
    
    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
