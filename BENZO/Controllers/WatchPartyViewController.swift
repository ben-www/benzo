//
//  WatchPartyViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/26/21.
//

import UIKit

class WatchPartyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var friend:String?
    
    var friendJBenzoData:JBenzoData?
    var userJBenzoData:JBenzoData?
    
    var userMovieList:Array<(key: String, value: Double)>?
    var friendMovieList:Array<(key: String, value: Double)>?
    
    var tableMovieList:[Dictionary<String, Int>.Element]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        if self.friendMovieList != nil {
            // Create Table
            createTable()

        }
        else {
            //  ERROR: NO DATA
        }
        
    }
    
    func createTable() {
        
        let userTopMovies = self.userMovieList![0...50]
        let friendTopMovies = self.friendMovieList![0...50]
        
        var userRanks = [String:Int]()
        var friendRanks = [String:Int]()

        
        for (index,mov) in userTopMovies.enumerated() {
            
            userRanks[mov.0] = index
        }
        
        for (index,mov) in friendTopMovies.enumerated() {
            
            friendRanks[mov.0] = index
        }
        
        
        var deltaDict = [String:Int]()
        
        for (k,v) in userRanks {
            
            if let friendMovieRank = friendRanks[k] {
                
                let delta = abs(v - friendMovieRank)
                deltaDict[k] = delta
            }
        
            
        }
        
        let deltaArray = deltaDict.sorted(by: {$0.value < $1.value})
        self.tableMovieList = deltaArray
        
    }
    
    
    
    
    func getRanks(title:String) -> String {
        
        var userRanks = [String:Int]()
        var friendRanks = [String:Int]()

        
        for (index,mov) in self.userMovieList!.enumerated() {
            
            userRanks[mov.0] = index
        }
        
        for (index,mov) in self.friendMovieList!.enumerated() {
            
            friendRanks[mov.0] = index
        }
        
        let userRank = userRanks[title]
        let friendRank = friendRanks[title]
        let result = "#\(friendRank! + 1)" + ", " + "#\(userRank! + 1)"
        
        return result
    }


}




extension WatchPartyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.tableMovieList?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.watchPartyCell , for: indexPath) as? WatchPartyCell
        
        if self.tableMovieList != nil {
            
            let title = self.tableMovieList![indexPath.row]
            
            let movieRanks = self.getRanks(title: title.0)
            
            cell?.displayMovie(title: String(indexPath.row+1) + ". " + title.0, scores: movieRanks)

        }
        else {
            cell?.displayMovie(title: String(indexPath.row+1) + ". ", scores: "ERROR")

        }
    
        return cell!

    }
    
}
