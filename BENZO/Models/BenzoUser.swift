//
//  BenzoUser.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/21/20.
//

import Foundation


class BenzoUser {
    
    var userId:String?
    var username:String?
    var hasJBenzo:Bool?
    var activeJBenzo:Bool?

    
    var rankedMovies:Array<String>?
    var unrankedMovies:Array<String>?
    var JBenzoScores = [JBenzoScore]()
    
    
    init(userId:String, username: String) {
        self.userId = userId
        self.username = username
        self.hasJBenzo = false
        self.activeJBenzo = false
        
    }
    

    
}

