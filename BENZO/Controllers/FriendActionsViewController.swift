//
//  FriendActionsViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/5/21.
//

import UIKit

class FriendActionsViewController: UIViewController {
    
    
    @IBOutlet weak var watchPartyButton: UIButton!
    @IBOutlet weak var jBenzoButton: UIButton!
    @IBOutlet weak var gamesButton: UIButton!
    
    var friend:String?
    var friendId:String?
    
    var data = [Movie]()

    var friendJBenzoData:JBenzoData?
    var userJBenzoData:JBenzoData?
    
    var userGameData:GameData?
    
    var userMovieList:Array<(key: String, value: Double)>?
    var friendMovieList:Array<(key: String, value: Double)>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = friend
        
        GameService.retrieveGameData { (retrievedData) in
            
            self.userGameData = retrievedData
            
            DispatchQueue.main.async {
                if self.userGameData == nil {
                    self.userGameData = GameService.createGameDataEntry()
                }
            }
            
        }
        
        // USERid
        let userId = LocalStorageService.loadUserID()
        JBenzoService.retrieveFriendJBenzoData(friendId: userId!) { (retrievedData) in

            self.userJBenzoData = retrievedData

            DispatchQueue.main.async {
                if self.userJBenzoData == nil {
                    self.jBenzoButton.isEnabled = false
                    self.watchPartyButton.isEnabled = false
                    self.watchPartyButton.alpha = 0.5

                }
                
                else {
                    let tempDict = self.userJBenzoData?.JBenzoScores
                    self.userMovieList = tempDict!.sorted(by: { $0.value > $1.value })

                }
            }
            
        }
        
        
        // FRIENDid
        JBenzoService.retrieveFriendJBenzoData(friendId: friendId!) { (retrievedData) in
            
            self.friendJBenzoData = retrievedData
            
            DispatchQueue.main.async {
                if self.friendJBenzoData != nil  {
                    if let count = self.friendJBenzoData?.swipedMovies?.count {
                        if count < 5 {
                            self.gamesButton.isEnabled = false
                            self.gamesButton.alpha = 0.5
                        }
                    } else {
                        // Count is nil
                        self.gamesButton.isEnabled = false
                        self.gamesButton.alpha = 0.5
                    }

                }
                
                
                if self.friendJBenzoData == nil {
                    self.jBenzoButton.isEnabled = false
                    self.gamesButton.isEnabled = false
                    self.watchPartyButton.isEnabled = false
                    
                    self.gamesButton.alpha = 0.5
                    self.jBenzoButton.alpha = 0.5
                    self.watchPartyButton.alpha = 0.5

                }

                else {
                    let tempDict = self.friendJBenzoData?.JBenzoScores
                    self.friendMovieList = tempDict!.sorted(by: { $0.value > $1.value })

                }
            }
            
        }
        
    }
    
    
    
    
    // MARK: Alert
    func showGameIntroAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let startAction = UIAlertAction(title: "Start", style: .default) { (action) in
            self.performSegue(withIdentifier: Constants.Segue.guessingGame, sender: nil)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        alert.addAction(startAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.friendJBenzoScoreList {

            let friendScoreVC = segue.destination as! FriendJBenzoScoreListViewController

            friendScoreVC.friend = self.friend
            friendScoreVC.userMovieList = self.userMovieList
            friendScoreVC.friendMovieList = self.friendMovieList
            friendScoreVC.userJBenzoData = self.userJBenzoData
            friendScoreVC.friendJBenzoData = self.friendJBenzoData

        }
        
        if segue.identifier == Constants.Segue.guessingGame {
            
            let gameVC = segue.destination as! GuessingGameViewController
            gameVC.friendJBenzoData = self.friendJBenzoData

            
        }

        if segue.identifier == Constants.Segue.alreadyWatchFriend {
            
            let watchHistoryVC = segue.destination as! FriendWatchHistoryViewController
            watchHistoryVC.data = self.data
            watchHistoryVC.friend = self.friend
            watchHistoryVC.friendId = self.friendId

            
        }
        
        if segue.identifier == Constants.Segue.watchPartyView {
            
            let watchPartyVC = segue.destination as! WatchPartyViewController

            watchPartyVC.friend = self.friend
            watchPartyVC.userMovieList = self.userMovieList
            watchPartyVC.friendMovieList = self.friendMovieList
            watchPartyVC.userJBenzoData = self.userJBenzoData
            watchPartyVC.friendJBenzoData = self.friendJBenzoData

            
        }

        
    }

    
    @IBAction func watchHistoryTapped(_ sender: Any) {
    }
    
    @IBAction func gamesTapped(_ sender: Any) {
        
        // Show Alert Explaining the Game
        self.showGameIntroAlert(title: "What did '\(self.friend!)' like?", message: "In this guessing game you will be given a random list of 5 movies that were swiped on by '\(self.friend!)', see how well you know your friend.")
        
    }
    

}
