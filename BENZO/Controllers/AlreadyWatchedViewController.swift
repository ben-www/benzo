//
//  AlreadyWatchedViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/13/21.
//

import UIKit

class AlreadyWatchedViewController: UIViewController {
    
    var watchedData:WatchData?
    var data = [Movie]()
    
    var watchedMovieList = ""


    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Check if movie in Watchlist/Already Watched
        WatchDataService.retrieveWatchData(data: self.data) { (retrievedData) in
            
            // Get the Users WatchedData
            self.watchedData = retrievedData
            
            // If User doesn't have WatedData
            if self.watchedData == nil {
                self.watchedData = WatchDataService.createWatchDataEntry()
            }
            
            for mov in self.watchedData!.alreadyWatchedMovies! {
                self.watchedMovieList = self.watchedMovieList + mov + "\n"
            }
            
            self.textView.text = self.watchedMovieList

        }
    }
    
    
    



}
