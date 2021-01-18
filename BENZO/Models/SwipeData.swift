//
//  SwipeData.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/18/21.
//

import Foundation
import FirebaseFirestore


struct SwipeData {
    
    var byId:String?
    var byUsername:String?
    var genrePercentages:[String : Double]?

    
    
    init(byId:String, byUsername: String) {
        self.byId = byId
        self.byUsername = byUsername
        
    }
    
    
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        // Parse the data out
        let data = snapshot.data()

        let byId = data["byId"] as? String
        let byUsername = data["byUsername"] as? String
        let genrePercentages = data["genrePercentages"] as? [String : Double]?

        // Check for missing data
        if byUsername == nil || byId == nil || genrePercentages == nil {
            return nil
        }
        
        // Set our properties
        self.byId = byId
        self.byUsername = byUsername
        self.genrePercentages = genrePercentages!

    }
    
}



extension SwipeData {
    init() {
    }
    
}
