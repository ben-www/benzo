//
//  LocalBenzoService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/28/20.
//

import Foundation

class LocalBenzoService {
    
    static func getDirectorMovies(data: [Movie], directorName: String) -> [Movie] {
        var dirMovies = [Movie]()
        
        for mov in data {
            let dir = String(mov.Director!)
                    
            if dir == directorName {
                dirMovies.append(mov)
            }
        }
        
        return dirMovies
    }

    static func getYearMovies(data: [Movie], year: String) -> [Movie] {
        var yrMovies = [Movie]()
        
        for mov in data {
            let yr = String(mov.Year!)
                    
            if yr == year {
                yrMovies.append(mov)
            }
        }
        
        return yrMovies
    }
    
}
