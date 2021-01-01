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
        static let yearMovieCellId = "YearMovieCell1"
        static let watchlistCell = "WatchlistCell"

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
        static let profileSettings = "ProfileSettings"
        static let searchCelltoMovieInfo = "SearchCelltoMovieInfo"
        static let movieDirectorInfo = "MovieDirectorInfo"
        static let yearMovieList = "YearMovieList"
        static let watchlist = "Watchlist"
    }
    
}
