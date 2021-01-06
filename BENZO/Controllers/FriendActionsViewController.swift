//
//  FriendActionsViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/5/21.
//

import UIKit

class FriendActionsViewController: UIViewController {
    
    
    @IBOutlet weak var jBenzoButton: UIButton!
    
    var friend:String?
    var friendId:String?
    
    var friendJBenzoData:JBenzoData?
    var userJBenzoData:JBenzoData?
    
    var userMovieList:Array<(key: String, value: Double)>?
    var finalMovieList:Array<(key: String, value: Double)>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = friend
        
        
        let userId = LocalStorageService.loadUserID()
        JBenzoService.retrieveFriendJBenzoData(friendId: userId!) { (retrievedData) in

            self.userJBenzoData = retrievedData

            if self.userJBenzoData == nil {
                self.jBenzoButton.isEnabled = false
            }
            else {
                let tempDict = self.userJBenzoData?.JBenzoScores
                self.userMovieList = tempDict!.sorted(by: { $0.value > $1.value })

            }
        }
        
        JBenzoService.retrieveFriendJBenzoData(friendId: friendId!) { (retrievedData) in
            
            self.friendJBenzoData = retrievedData
            
            if self.friendJBenzoData == nil {
                self.jBenzoButton.isEnabled = false
            }
            else {
                let tempDict = self.friendJBenzoData?.JBenzoScores
                self.finalMovieList = tempDict!.sorted(by: { $0.value > $1.value })

            }
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.friendJBenzoScoreList {

            let friendScoreVC = segue.destination as! FriendJBenzoScoreListViewController

            var scoreList = ""
            for (index,mov) in self.finalMovieList!.enumerated() {
                
                let finalScore = round(10000.0 * mov.1) / 10000.0
                
                scoreList = scoreList + (String(index+1) + ") " + (mov.0 + ": " + String(finalScore)) + "\n")
            }
            
            var userScoreList = ""
            for (index,mov) in self.userMovieList!.enumerated() {
                
                let finalScore = round(10000.0 * mov.1) / 10000.0

                userScoreList = userScoreList + (String(index+1) + ") " + (mov.0 + ": " + String(finalScore)) + "\n")
            }
            
            
            friendScoreVC.scoreList = scoreList
            friendScoreVC.userScoreList = userScoreList
            friendScoreVC.friend = self.friend

        }
        

        
    }

    


}
