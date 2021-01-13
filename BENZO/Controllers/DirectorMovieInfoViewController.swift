//
//  DirectorMovieInfoViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/5/20.
//

import UIKit

class DirectorMovieInfoViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var titleButton: UIButton!
    var movie:Movie?
    
    @IBOutlet weak var directorLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var reLabel: UILabel!
    @IBOutlet weak var metaCLabel: UILabel!
    @IBOutlet weak var metaULabel: UILabel!
    @IBOutlet weak var rtCLabel: UILabel!
    
    @IBOutlet weak var rtALabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var rawLabel: UILabel!
    @IBOutlet weak var benzoLabel: UILabel!

    @IBOutlet weak var deltaLabel: UILabel!
    
    var watchedData:WatchData?
    var data = [Movie]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put in Func
        let re = movie!.RogerEbert ?? 0.0
        
        if re == 0.0 {
            self.reLabel.text = "Roger Ebert: n/a"
        }
        else {
            self.reLabel.text = "Roger Ebert: \(movie!.RogerEbert!)"

        }
        
        
        self.titleButton.setTitle((movie?.Title)!, for: .normal)
        self.directorLabel.text = "\(movie!.Director!)"
        let genres = createCatList()
        self.genresLabel.text = "Genres: " + genres

        self.yearLabel.text = "Year: \(movie!.Year!)"
        
        self.metaCLabel.text = "Meta Critic: \(movie!.MetaCritic!)"
        self.metaULabel.text = "Meta User: \(movie!.MetaUser!)"
        
        self.rtCLabel.text = "Rotten Tomatoes(RT) Critic: \(movie!.RTCritic!)"
        self.rtALabel.text = "RT Audience: \(movie!.RTAudience!)"
        
        self.imdbLabel.text = "IMDB: \(movie!.IMDB!)"
        
        self.rawLabel.text = "Raw Score: \(movie!.Raw!)"
        self.benzoLabel.text = "BENZO: \(movie!.BENZO!)"
        
        var delta = (movie?.BENZO!)! - (movie?.Raw!)!
        delta = round(10000.0 * delta) / 10000.0
        
        self.deltaLabel.text = "Detla: (+)\(String(delta))"
        
        
        // Check if movie in Watchlist/Already Watched
        WatchDataService.retrieveWatchData(data: self.data) { (retrievedData) in
            
            // Get the Users WatchedData
            self.watchedData = retrievedData
            
            // If User doesn't have WatedData
            if self.watchedData == nil {
                self.watchedData = WatchDataService.createWatchDataEntry()
            }
            
            if ((self.watchedData?.watchlist?.contains((self.movie?.Title)!)) == true) {
                self.itemAdded()
            }
        }
    
      
    }
    
    func createCatList() -> String {
        
        var joinedCategories = [String]()

        if ((self.movie!.Category1) == "") {
            return "n/a"
        }
        if ((self.movie!.Category2) == "") {
            return self.movie!.Category1!
            
        }
        if ((self.movie!.Category3) == "") {
            joinedCategories = [self.movie!.Category1!, self.movie!.Category2!]
            return joinedCategories.joined(separator: ", ")
            
        }
        else {
            joinedCategories = [self.movie!.Category1!, self.movie!.Category2!, self.movie!.Category3!]
            return joinedCategories.joined(separator: ", ")
        }
        

    }
    
    
    func itemAdded() {
        if self.addButton.currentImage == UIImage(systemName: "plus.circle") {
            self.addButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }

    func itemRemoved() {
        if self.addButton.currentImage == UIImage(systemName: "checkmark.circle.fill") {
            self.addButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        }
    }
    
    
    // MARK: J Benzo Toggle Msg
    func showAddAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var watchLaterAction = UIAlertAction(title: "+ Watchlist", style: .default) { (action) in
            self.itemAdded()
            WatchDataService.addToWatchlist(title: title)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        if ((self.watchedData?.watchlist?.contains((self.movie?.Title)!)) == true) {
            watchLaterAction = UIAlertAction(title: "Remove From Watchlist", style: .default) { (action) in
                self.itemRemoved()
                WatchDataService.removeFromWatchlist(title: title)
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        

        var seendAction = UIAlertAction(title: "+ Already Watched", style: .default) { (action) in
            //self.itemAdded()
            
            WatchDataService.addToAlreadyWatchedlist(title: title)
            self.navigationController?.popViewController(animated: true)

        }
        
        if ((self.watchedData?.alreadyWatchedMovies?.contains((self.movie?.Title)!)) == true) {
            seendAction = UIAlertAction(title: "Remove From Already Watched", style: .default) { (action) in
                WatchDataService.removeFromAlreadyWatchlist(title: title)
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        


        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        
        //alert.addAction(watchingAction)
        alert.addAction(watchLaterAction)
        alert.addAction(seendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
        
    
    @IBAction func homeTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    


    @IBAction func howToWatchTapped(_ sender: Any) {
        var newTitle = self.movie?.Title
        newTitle = newTitle?.replacingOccurrences(of: " ", with: "+")
        
        let hyperlink = "https://www.google.com/search?q=" + newTitle! + "+stream"
        
        if let url = URL(string: hyperlink) {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func addToListTapped(_ sender: Any) {
        showAddAlert(title: "\(self.movie!.Title!)", message: " Which of the following actions?")
        return
    }
    
    
    
}
