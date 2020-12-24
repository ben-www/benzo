//
//  BenzoUser.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/21/20.
//

import Foundation
import FirebaseFirestore


struct BenzoUser {
    
    var userId:String?
    var username:String?
    var JBenzoData:JBenzoData?
    
    
    
    init(userId:String, username: String) {
        self.userId = userId
        self.username = username
        
    }
    
    
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        // Parse the data out
        let data = snapshot.data()

        let username = data["username"] as? String

        // Check for missing data
        if username == nil {
            return nil
        }
        
        // Set our properties
        self.username = username

    }
    
}



extension BenzoUser {
    init() {
    }
    
}

