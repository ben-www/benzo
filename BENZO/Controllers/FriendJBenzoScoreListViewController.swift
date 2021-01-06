//
//  FriendJBenzoScoreListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/6/21.
//

import UIKit

class FriendJBenzoScoreListViewController: UIViewController {

    
    
    @IBOutlet weak var myScoresButton: UIButton!
    @IBOutlet weak var scoreListText: UITextView!
    
    var friend:String?

    var scoreList:String?
    var userScoreList:String?
    
    var isComparing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scoreListText.text = scoreList
        myScoresButton.setTitle("\(self.friend!)'s Scores ", for: .normal)

    }
    

    
    @IBAction func myScoresTapped(_ sender: Any) {
        if isComparing {
            self.scoreListText.text = scoreList
            self.isComparing = false
            myScoresButton.setTitle("\(self.friend!)'s Scores ", for: .normal)

        }
        else {
            self.scoreListText.text = userScoreList
            self.isComparing = true
            
            myScoresButton.setTitle("My Scores ", for: .normal)

        }
        
    }
    

}
