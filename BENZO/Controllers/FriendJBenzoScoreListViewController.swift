//
//  FriendJBenzoScoreListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/6/21.
//

import UIKit

class FriendJBenzoScoreListViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myScoresButton: UIButton!
    
    var friend:String?
    
    var friendJBenzoData:JBenzoData?
    var userJBenzoData:JBenzoData?
    
    var userMovieList:Array<(key: String, value: Double)>?
    var friendMovieList:Array<(key: String, value: Double)>?
    
    var isComparing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        myScoresButton.setTitle("\(self.friend!)'s Scores ", for: .normal)

    }
    
    
    
    func showComparisonAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var okAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    

    
    @IBAction func myScoresTapped(_ sender: Any) {
        if isComparing {
            self.isComparing = false
            myScoresButton.setTitle("\(self.friend!)'s Scores ", for: .normal)

        }
        else {
            self.isComparing = true
            myScoresButton.setTitle("My Scores ", for: .normal)

        }
        
        tableView.reloadData()
        
    }
    

}


extension FriendJBenzoScoreListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userMovieList!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.friendScoreCell , for: indexPath) as? FriendScoreCell
        
        var movie = self.friendMovieList![indexPath.row]
        
        if isComparing {
            movie = self.userMovieList![indexPath.row]
        }

        let finalScore = round(10000.0 * movie.1) / 10000.0

        cell?.displayUsername(title: String(indexPath.row+1) + ". " + movie.0, score: String(finalScore))

        return cell!
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = String((LocalStorageService.loadUser()?.username)!)


        // Create Message
        var fMovie = self.friendMovieList![indexPath.row]
        var friendRank = indexPath.row
        var friendScore = fMovie.1
        
        // use fMovie.0 as KEY to get
        var userScore = self.userJBenzoData?.JBenzoScores![fMovie.0]

        var userRank = 0
        
        for (index,mov) in self.userMovieList!.enumerated() {
            if mov.0 == fMovie.0 {
                userRank = index
            }
        }
        
        
        
        if self.isComparing {
            // Create Message
            fMovie = self.userMovieList![indexPath.row]
            userRank = indexPath.row
            userScore = fMovie.1
            
            // use fMovie.0 as KEY to get
            friendScore = (self.friendJBenzoData?.JBenzoScores![fMovie.0])!

            friendRank = 0
            
            for (index,mov) in self.friendMovieList!.enumerated() {
                if mov.0 == fMovie.0 {
                    friendRank = index
                }
            }
            
            
        }
        


        userScore = round(10000.0 * userScore!) / 10000.0
        friendScore = round(10000.0 * friendScore) / 10000.0

        
        
        self.tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        
        
        showComparisonAlert(title: fMovie.0, message: "\(username): #\(String(userRank+1)), \(String(userScore!))\nmiggy: #\(String(friendRank+1)), \(String(friendScore))")

    
    }
    
}
