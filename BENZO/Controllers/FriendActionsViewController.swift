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
    var friendMovieList:Array<(key: String, value: Double)>?

    
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
                self.friendMovieList = tempDict!.sorted(by: { $0.value > $1.value })

            }
        }
        
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
        

        
    }

    


}
