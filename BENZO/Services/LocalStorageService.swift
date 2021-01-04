//
//  LocalStorageService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/22/20.
//

import Foundation

class LocalStorageService {
    
    static func saveUser(userId:String?, username:String?) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(userId, forKey: Constants.LocalStorage.userIdKey)
        defaults.set(username, forKey: Constants.LocalStorage.usernameKey)

    }
    
    static func loadUser() -> BenzoUser? {
        
        let defaults = UserDefaults.standard

        let userId = defaults.value(forKey: Constants.LocalStorage.userIdKey) as? String
        let username = defaults.value(forKey: Constants.LocalStorage.usernameKey) as? String
        
        if userId != nil && username != nil {
            return BenzoUser(userId: userId!, username: username!)
        }
        else {
            return nil
        }
    }
    
    static func loadUserID() -> String? {
        
        let defaults = UserDefaults.standard

        let userId = defaults.value(forKey: Constants.LocalStorage.userIdKey) as? String
        
        if userId != nil {
            return userId
        }
        else {
            return nil
        }
    }
    
    
    static func clearUser() {
        // SIGN OUT
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: Constants.LocalStorage.userIdKey)
        defaults.set(nil, forKey: Constants.LocalStorage.usernameKey)
        
        
    }
    
    
    
    
}
