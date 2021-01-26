//
//  GameData.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/26/21.
//

import Foundation
import FirebaseFirestore


struct GameData {
    
    var byId:String?
    var byUsername:String?
    
    // FriendId : Score as Fraction
    var gameScores:[String : String]?

    
    
    init(byId:String, byUsername: String) {
        self.byId = byId
        self.byUsername = byUsername
        self.gameScores = [String : String]()
        
    }
    
    
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        // Parse the data out
        let data = snapshot.data()

        let byId = data["byId"] as? String
        let byUsername = data["byUsername"] as? String
        let gameScores = data["gameScores"] as? [String : String]?

        // Check for missing data
        if byUsername == nil || byId == nil || gameScores == nil {
            return nil
        }
        
        // Set our properties
        self.byId = byId
        self.byUsername = byUsername
        self.gameScores = gameScores!

    }
    
}



extension GameData {
    init() {
    }
    
}
