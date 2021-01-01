//
//  WatchData.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/30/20.
//

import Foundation
import FirebaseFirestore


struct WatchData {
    
    var byId:String?
    var byUsername:String?
    
    var watchlist:Array<String>?
    var alreadyWatchedMovies:Array<String>?

    
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        let data = snapshot.data()
        
        let byId = data["byId"] as? String
        let byUsername = data["byUsername"] as? String
        let watchlist = data["watchlist"] as? Array<String>?
        let alreadyWatchedMovies = data["alreadyWatchedMovies"] as? Array<String>?

        
        
        if byId == nil || byUsername == nil || watchlist == nil || alreadyWatchedMovies == nil {
            return nil
        }
        
        self.byId = byId
        self.byUsername = byUsername
        
        self.watchlist = watchlist!
        self.alreadyWatchedMovies = alreadyWatchedMovies!
    }
}

extension WatchData {
    init() {
        
    }
}

