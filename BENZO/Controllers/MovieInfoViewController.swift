//
//  MovieInfoViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import UIKit

class MovieInfoViewController: UIViewController {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var directorButton: UIButton!
    
    @IBOutlet weak var thumbsUpButton: UIButton!
    @IBOutlet weak var thumbsDownButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBOutlet weak var jBenzoScore: UILabel!
    
    
    @IBOutlet weak var rankLabel: UILabel!
    var rank:Int?
    var movie:Movie?
    var data = [Movie]()

    var jBenzoData:JBenzoData?
    var watchedData:WatchData?
    
    //@IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var reLabel: UILabel!
    @IBOutlet weak var metaCLabel: UILabel!
    @IBOutlet weak var metaULabel: UILabel!
    @IBOutlet weak var rtCLabel: UILabel!
    @IBOutlet weak var rtALabel: UILabel!
    @IBOutlet weak var imbdLabel: UILabel!
    @IBOutlet weak var rawLabel: UILabel!
    @IBOutlet weak var benzoLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        
        jBenzoScore.alpha = 0
        thumbsUpButton.alpha = 0
        thumbsDownButton.alpha = 0
        
        if self.movie?.jBENZO != nil  {
            jBenzoScore.alpha = 1
            jBenzoScore.text = "\(movie!.jBENZO!)"
            
            thumbsUpButton.alpha = 1
            thumbsDownButton.alpha = 1
            
            
            // Check swipedMovies for like or dislike
            if let mov = self.jBenzoData?.swipedMovies![(self.movie?.Title)!] {
                
                if mov == "like" {
                    self.thumbsUpButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                }
                else {
                    self.thumbsDownButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)

                }
            }
           
        
        }
        
        
        var dir = "n/a"
        if self.movie?.Director != "" {
            dir = (self.movie?.Director)!
        }
        
        
        // put in Func
        let re = movie!.RogerEbert ?? 0.0
        
        if re == 0.0 {
            self.reLabel.text = "Roger Ebert: n/a"
        }
        else {
            self.reLabel.text = "Roger Ebert: \(movie!.RogerEbert!)"

        }
        
        
        self.titleButton.setTitle((movie?.Title)!, for: .normal)
        self.directorButton.setTitle(dir, for: .normal)
        
        let genres = createCatList()
        self.genresLabel.text = "Genres: " + genres

        self.yearLabel.text = "Year: \(movie!.Year!)"
        
        self.metaCLabel.text = "Meta Critic: \(movie!.MetaCritic!)"
        self.metaULabel.text = "Meta User: \(movie!.MetaUser!)"
        
        self.rtCLabel.text = "Rotten Tomatoes(RT) Critic: \(movie!.RTCritic!)"
        self.rtALabel.text = "RT Audience: \(movie!.RTAudience!)"
        
        self.imbdLabel.text = "IMDB: \(movie!.IMDB!)"
        
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
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveExtraInfo" {
            let movieExtraInfoController = segue.destination as! MovieExtraInfoViewController
            movieExtraInfoController.movie = self.movie
        }
        
        if segue.identifier == "moveDirectorInfo" {
            let directorController = segue.destination as! DirectorMovieListViewController
            directorController.directorName = self.movie?.Director
            directorController.directorMovies = LocalBenzoService.getDirectorMovies(data: self.data, directorName: (self.movie?.Director)!)
            directorController.data = self.data
        }

    }
    
    
    
    
    
    @IBAction func directorTapped(_ sender: Any) {
        print("Director! Button Tapped.")
    }
    
    
    @IBAction func titleTapped(_ sender: Any) {
        print("Title Button Tapped.")
    }
    
    
    
    
    @IBAction func addToListTapped(_ sender: Any) {
        showAddAlert(title: "\(self.movie!.Title!)", message: " Which of the following actions?")
        return
        
    }
    
    
    
    @IBAction func howToWatchTapped(_ sender: Any) {
        var newTitle = self.movie?.Title
        newTitle = newTitle?.replacingOccurrences(of: " ", with: "+")
        
        let hyperlink = "https://www.google.com/search?q=" + newTitle! + "+stream"
        
        if let url = URL(string: hyperlink) {
            UIApplication.shared.open(url)
        }
        
    }
    
    
    @IBAction func thumbsUpTapped(_ sender: Any) {
        
        if self.thumbsUpButton.currentImage == UIImage(systemName: "hand.thumbsup") {
            self.thumbsUpButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            // Update DB to like
            SwipeService.addToSwipedMovies(title: movie?.Title, value: "like")
            
            if self.thumbsDownButton.currentImage == UIImage(systemName: "hand.thumbsdown.fill") {
                // If previously Thumbs DOWN, unfill
                self.thumbsDownButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            }
        }
        else {
            //self.thumbsUpButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            // Delete from SwipedMovies, add back to UnswipedMovies
        }
    
    }
    
    
    @IBAction func thumbsDownTapped(_ sender: Any) {
        
        if self.thumbsDownButton.currentImage == UIImage(systemName: "hand.thumbsdown") {
            self.thumbsDownButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            // Update DB to dilike
            SwipeService.addToSwipedMovies(title: movie?.Title, value: "dislike")
            
            if self.thumbsUpButton.currentImage == UIImage(systemName: "hand.thumbsup.fill") {
                // If previously Thumbs UP, unfill
                self.thumbsUpButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)

            }
        }
        else {
            //self.thumbsDownButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            // Delete from SwipedMovies, add back to UnswipedMovies

        }
    }
    
}

