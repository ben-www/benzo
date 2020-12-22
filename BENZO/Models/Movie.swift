//
//  Movie.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import Foundation


struct Movie: Codable {
    
    var Title:String?
    var Year:Int?
    
    var Director:String?
    var Category1:String?
    var Category2:String?
    var Category3:String?

    var RogerEbert:Double?
    var MetaCritic:Double?
    var MetaUser:Double?
    var RTCritic:Int?
    var RTAudience:Int?
    var IMDB:Double?
    var Raw:Double?
    var REscore:Double?
    var MCscore:Double?
    var MUscore:Double?
    var RTCscore:Double?
    var RTAscore:Double?
    var IMDBscore:Double?
    var BENZO:Double?
    var jBENZO:Double?
    

}
