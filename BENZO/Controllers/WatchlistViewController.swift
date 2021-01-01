//
//  WatchlistViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/30/20.
//

import UIKit

class WatchlistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // pass data
    // pass watchlist
    var data = [Movie]()
    var jBenzoData:JBenzoData?
    
    var watchedData:WatchData?
    var watchlist = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Watchlist"
        
        tableView.delegate = self
        tableView.dataSource = self
        

        // Check if movie in Watchlist/Already Watched
        WatchDataService.retrieveWatchData(data: self.data) { (retrievedData) in
            
            // Get the Users WatchedData
            self.watchedData = retrievedData
            if self.watchedData != nil {

                self.watchlist = (self.watchedData?.watchlist)!
                self.watchlist.reverse()
            }
            self.tableView.reloadData()
        }

    }
    
    
    
    func getMovie(title:String) -> Movie {
        var mov = Movie()
        
        for m in self.data {
            if m.Title == title {
                mov = m
            }
        }
        
        return mov
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Works")
        // Check if movie in Watchlist/Already Watched
        WatchDataService.retrieveWatchData(data: self.data) { (retrievedData) in
            
            // Get the Users WatchedData
            self.watchedData = retrievedData
            if self.watchedData != nil {
                self.watchlist = (self.watchedData?.watchlist)!
                self.watchlist.reverse()
            }

            self.tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "WatchListToMovieInfo" {
            
            let movieInfoController = segue.destination as! MovieInfoViewController
            
            if tableView.indexPathForSelectedRow != nil {
                // pass on movie
                movieInfoController.movie = getMovie(title: watchlist[tableView.indexPathForSelectedRow!.row])
                movieInfoController.data = self.data
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }

        }
        
        
    }
    



}

// MARK: UITableViewDelegate, UITableViewDataSource
extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.watchlistCell , for: indexPath) as? WatchlistCell
        
        
        let movie = getMovie(title: watchlist[indexPath.row])
        cell?.displayMovieTitle(title: movie.Title!, rank:"\(movie.BENZO ?? 0.0)")
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            if let score = movie.jBENZO {
                let finalScore = round(10000.0 * score) / 10000.0
                cell?.displayMovieTitle(title: movie.Title!, rank: "\(finalScore)", jBenzo: true)

            }

        }
        
        return cell!
        
    }
    
    
    
}

