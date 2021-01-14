//
//  FriendWatchHistoryViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/13/21.
//

import UIKit

class FriendWatchHistoryViewController: UIViewController {
    
    
    var watchedData:WatchData?
    var data = [Movie]()
    var watchedMovieList = ""
    
    var friend:String?
    var friendId:String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = "\(friend!)'s Watch History"
        
        WatchDataService.retrieveFriendWatchData(data: self.data, userId: self.friendId!) { (retrievedData) in
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

            if self.watchedMovieList == "" {
                self.textView.text = "'\(self.friend!)' has no watch history."
            }

        }


    }
    



}
