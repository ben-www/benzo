//
//  JBenzoScore.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/21/20.
//

import Foundation
import FirebaseFirestore


struct JBenzoData {
    
    var byId:String?
    var byUsername:String?
    var hasJBenzo:Bool?
    var showJBenzo:Bool?
    var isGenreLocked:Bool?
    var numOfMoviesRated:Int?

    // Keep Track of Movie titles & JBenzo calculated scores
    var JBenzoScores:[String : Double]?
    
    // Keep Track of Input
    var unswipedMovies:Array<String>?
    
    var genrePercentages:[String : Double]?
    var swipedMovies:[String : String]?


    
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        let data = snapshot.data()
        
        let byId = data["byId"] as? String
        let byUsername = data["byUsername"] as? String

        let hasJBenzo = data["hasJBenzo"] as? Bool
        let showJBenzo = data["showJBenzo"] as? Bool
        let isGenreLocked = data["isGenreLocked"] as? Bool
        let numOfMoviesRated = data["numOfMoviesRated"] as? Int

        
        let upswipedMovies = data["unswipedMovies"] as? Array<String>?
        
        let swipedMovies = data["swipedMovies"] as? [String : String]?

        let genrePercentages = data["genrePercentages"] as? [String : Double]?
        let JBenzoScores = data["JBenzoScores"] as? [String : Double]?
        
        if byId == nil || byUsername == nil || hasJBenzo == nil || showJBenzo == nil || isGenreLocked == nil || swipedMovies == nil || upswipedMovies == nil || genrePercentages == nil || JBenzoScores == nil || numOfMoviesRated == nil{
            return nil
        }
        
        self.byId = byId
        self.byUsername = byUsername
        
        self.numOfMoviesRated = numOfMoviesRated
        self.hasJBenzo = hasJBenzo
        self.showJBenzo = showJBenzo
        self.isGenreLocked = isGenreLocked
        
        self.swipedMovies = swipedMovies!
        self.unswipedMovies = upswipedMovies!
        self.genrePercentages = genrePercentages!
        self.JBenzoScores = JBenzoScores!
        
    }
    
}


extension JBenzoData {
    init() {
        
    }
}
