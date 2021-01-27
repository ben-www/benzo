//
//  GuessingGameViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/13/21.
//

import UIKit

class GuessingGameViewController: UIViewController, MovieDataProtocol {

    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var movieData = MovieData()
    var data = [Movie]()
    
    var friendJBenzoData:JBenzoData?
    var userGameData:GameData?

    var swipedMovies:[String]?
    var wrongGuesses = [String]()
    
    var correctAnswers = 0
    var currentQuestion = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieData.delegate = self
        movieData.getMovieData()
        
        self.swipedMovies = Array<String>((self.friendJBenzoData?.swipedMovies!.keys)!)
        self.swipedMovies?.shuffle()
        
        updateUI()
        
    }
    
    
    
    // MARK: MovieData Delgate
    func moviesRetrieved(_ movies: [Movie]) {
        print("Movies: retrieved from the MovieData.")
        self.data = movies
        self.data.sort(by: { $0.BENZO! > $1.BENZO! })
    }
 
    
    func animateUI() {
        movieTitleLabel.fadeTransition(0.3)
        questionNumLabel.fadeTransition(0.3)
        genreLabel.fadeTransition(0.3)
    }
    
    
    func updateUI() {
        self.questionNumLabel.text = "\(currentQuestion) of 5"
        self.movieTitleLabel.text = "\(self.swipedMovies![self.currentQuestion-1])"
        
        // Get Genre(s)
        for mov in self.data {
            if mov.Title == self.movieTitleLabel.text {
                genreLabel.text = JBenzoService.createCatList(mov: mov)

            }
        }
        
    }
    
    
    // MARK: Alert
    func resultsAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        

        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func likeTapped(_ sender: Any) {
        animateUI()
        
        // Record answer & if correct or NOT
        let correctAnswer = self.friendJBenzoData?.swipedMovies![self.movieTitleLabel.text!]
        
        if correctAnswer == "like" {
            self.correctAnswers += 1
        } else {
            // Wrong Answer
            self.wrongGuesses.insert(self.movieTitleLabel.text!, at: 0)
        }
        
        
        // Update CurrentQuestion
        self.currentQuestion += 1
        
        if self.currentQuestion == 6 {
            // DONE
            let results = self.wrongGuesses.joined(separator: ", ")
            
            // Update db
            let currentScore = self.userGameData?.gameScores![(self.friendJBenzoData?.byId)!]
            
            if currentScore == "0/0" {
                let overallScore = "\(self.correctAnswers)/5"
                self.userGameData?.gameScores![(self.friendJBenzoData?.byId)!] = overallScore
            }
            else {
                let scoreArr = currentScore?.components(separatedBy: "/")

                var nom = Int(scoreArr![0])
                var denom = Int(scoreArr![1])
                
                nom! += self.correctAnswers
                denom! += 5
                
                let overallScore = "\(nom!)/\(denom!)"

                self.userGameData?.gameScores![(self.friendJBenzoData?.byId)!] = overallScore
            }

            GameService.addUpdateNewGame(gameScores: (self.userGameData?.gameScores)!)

            // Show Results
            resultsAlert(title: "\(self.correctAnswers) out of 5 correct!", message: "You guessed wrong for the following Movie(s): \(results)")
        }
        else {
            updateUI()
        }
    }
    

    
    @IBAction func dislikedTapped(_ sender: Any) {
        animateUI()

        // Record answer & if correct or NOT
        let correctAnswer = self.friendJBenzoData?.swipedMovies![self.movieTitleLabel.text!]
        
        if correctAnswer == "dislike" {
            self.correctAnswers += 1
        } else {
            // Wrong Answer
            self.wrongGuesses.insert(self.movieTitleLabel.text!, at: 0)
        }
        
        // Update UI
        self.currentQuestion += 1
        
        if self.currentQuestion == 6 {
            // DONE
            let results = self.wrongGuesses.joined(separator: ", ")
            
            // Update db
            let currentScore = self.userGameData?.gameScores![(self.friendJBenzoData?.byId)!]
            
            if currentScore == "0/0" {
                let overallScore = "\(self.correctAnswers)/5"
                self.userGameData?.gameScores![(self.friendJBenzoData?.byId)!] = overallScore
            }
            else {
                let scoreArr = currentScore?.components(separatedBy: "/")

                var nom = Int(scoreArr![0])
                var denom = Int(scoreArr![1])
                
                nom! += self.correctAnswers
                denom! += 5
                
                let overallScore = "\(nom!)/\(denom!)"

                self.userGameData?.gameScores![(self.friendJBenzoData?.byId)!] = overallScore
            }

            GameService.addUpdateNewGame(gameScores: (self.userGameData?.gameScores)!)

            // Show Results
            resultsAlert(title: "\(self.correctAnswers) out of 5 correct!", message: "You guessed wrong for the following Movie(s): \(results)")
        }
        else {
            updateUI()
        }
        
    }
    
    
    @IBAction func moreInfoTapped(_ sender: Any) {
        
        let newTitle = self.movieTitleLabel.text?.replacingOccurrences(of: " ", with: "+")
        
        let hyperlink = "https://www.google.com/search?q=" + newTitle! + "+movie"
        
        if let url = URL(string: hyperlink) {
            UIApplication.shared.open(url)
        }
    }
    
}




