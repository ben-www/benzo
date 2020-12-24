//
//  Constants.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import Foundation


struct Constants {
    
    struct Cell {
        static let movieCellId = "MovieCell1"
        static let movieInfoCellId = "MovieInfoCell1"
        static let searchTitleCellId = "SearchTitleCell1"
        static let directorMovieCellId = "DirectorMovieCell1"
    
    }
    
    struct Storyboard {
        
        static let loginVC = "LoginVC"
        static let loginSuccessful = "LoginSuccessful"

        static let homeVC = "HomeVC"
        
        static let movieInfoStoryboard2 = "MovieInfoStoryboard2"
        
    }
    
    
    struct LocalStorage {
        static let userIdKey = "storedUserId"
        static let usernameKey = "storedUsername"
    }
    
    struct Segue {
        static let profileSegue = "goToCreateProfile"
        static let genreCalculator = "GenreCalculator"
        static let jBenzoSwipe = "jBenzoSwipe"

    }
    
}
