//
//  JBenzoSwipeViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/12/20.
//

import UIKit

class JBenzoSwipeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rawScoreLabel: UILabel!
    @IBOutlet weak var benzoScoreLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var numberOfSwipesLabel: UILabel!
    
    
    var data = [Movie]()
    var genres: [String] = [String]()
    var jBenzoData:JBenzoData?

    var swipeData:SwipeData?

    
    var movIndex = 0
    var numOfSwipes = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        
        self.data.shuffle()
        
        if self.jBenzoData?.unswipedMovies != nil {
            self.jBenzoData?.unswipedMovies?.shuffle()
            titleLabel.text = self.jBenzoData?.unswipedMovies![0]
            getRawAndBenzoScores(title: titleLabel.text!)

        }

        numberOfSwipesLabel.text = "(#) Movies rated in this session"
        
        SwipeService.retrieveSwipeData() { (retrievedData) in
            
            self.swipeData = retrievedData
            //self.checkForThresholds()

            // If User doesn't have
            if self.swipeData == nil {
                self.swipeData = SwipeService.createSwipeDataEntry(OGgpS: (self.jBenzoData?.genrePercentages)!)
            }
            

        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("BACK to Home Works")
        

    }
        
    
    func getRawAndBenzoScores(title: String) {
        
        for mov in self.data {
            if mov.Title == titleLabel.text {
                
                rawScoreLabel.text = "Raw Score: " + String(mov.Raw!)
                benzoScoreLabel.text = "BENZO: " + String(mov.BENZO!)
                genresLabel.text = JBenzoService.createCatList(mov: mov)
            }
        }
        
        titleLabel.fadeTransition(0.3)
        rawScoreLabel.fadeTransition(0.3)
        benzoScoreLabel.fadeTransition(0.3)
        genresLabel.fadeTransition(0.3)

        

    }
    
    
    func resetSwipedMovies() {
        var allMovies = [String]()
        
        for mov in self.data {
            allMovies.append(mov.Title!)
        }
        
        // Use Temp to reset UnswipedMovies
        JBenzoService.resetUnswipedMovies(allMovies: allMovies)
    }

    
    func checkForThresholds() {
        
        let swipeNum = numOfSwipes + (self.jBenzoData?.numOfMoviesRated)!
            
        if swipeNum == 25 || swipeNum == 50 || swipeNum == 75 || swipeNum == 100 || swipeNum == 150 || swipeNum == 200 {
            
            updateJBScores(swipeNum: swipeNum)
        }
    }
    
    
    
    func updateJBScores(swipeNum:Int) {
        
        let swipeScores = getSwipeGPs()
        let inputScores = jBenzoData?.genrePercentages
        //let allGPs = Array<String>((self.jBenzoData?.genrePercentages!.keys)!)

        var newScores = [String:Double]()

        
        
        for (genre,score) in inputScores! {
            
            if let genreSwipeScore = swipeScores[genre] {
                //print("Genre:",genre,score, genreSwipeScore)

                if swipeNum == 25 {
                    // 80,20
                    let newScore = (score)*(0.8) + (genreSwipeScore)*(0.2)
                    newScores[genre] = newScore
                }
                else if swipeNum == 50 {
                    // 70,30
                    let newScore = (score)*(0.7) + (genreSwipeScore)*(0.3)
                    newScores[genre] = newScore
                    
                }
                else if swipeNum == 75 {
                    // 60,40
                    let newScore = (score)*(0.6) + (genreSwipeScore)*(0.4)
                    newScores[genre] = newScore
                    
                }
                else if swipeNum == 100 {
                    // 50,50
                    self.resetSwipedMovies()
                    let newScore = (score)*(0.5) + (genreSwipeScore)*(0.5)
                    newScores[genre] = newScore
                    
                }
                else if swipeNum == 150 {
                    // 30,70
                    let newScore = (score)*(0.3) + (genreSwipeScore)*(0.7)
                    newScores[genre] = newScore
                    
                }
                else if swipeNum == 250 {
                    // 20,80
                    self.resetSwipedMovies()
                    let newScore = (score)*(0.2) + (genreSwipeScore)*(0.8)
                    newScores[genre] = newScore
                    
                }
                
            } else {
                //print(". OLD:",genre, score)
                newScores[genre] = score
                


            }
        }
        
        //  Update % in db
        print(newScores)
        
        JBenzoService.updateGPs(newScores: newScores)
    }
    
    
    
    func getSwipeGPs() -> [String: Double] {
        // For Movies in swiped movies, Get Genres and KEEP tally
        var gpDenominators = [String: Int]()
        var gpNominators = [String: Int]()
        var gpFinal  = [String: Double]()
        
        let swiped = Array<String>((self.jBenzoData?.swipedMovies!.keys)!)

        for mov in self.data {
            
            if swiped.contains(mov.Title!) {
                                
                if let status = self.jBenzoData?.swipedMovies![mov.Title!]  {
                    
                    if status == "like" {
                        gpNominators[mov.Category1!] = (gpNominators[mov.Category1!] ?? 0) + 1
                        gpNominators[mov.Category2!] = (gpNominators[mov.Category2!] ?? 0) + 1
                        gpNominators[mov.Category3!] = (gpNominators[mov.Category3!] ?? 0) + 1
                    }
                }

                gpDenominators[mov.Category1!] = (gpDenominators[mov.Category1!] ?? 0) + 1
                gpDenominators[mov.Category2!] = (gpDenominators[mov.Category2!] ?? 0) + 1
                gpDenominators[mov.Category3!] = (gpDenominators[mov.Category3!] ?? 0) + 1

                
            }
        }
        gpDenominators.removeValue(forKey: "")
        gpNominators.removeValue(forKey: "")

        print(gpDenominators)
        print(gpNominators)
        
        
        // Find Like % for each Genre
        for (k,v) in gpDenominators {
            
            if let nom = gpNominators[k] {
                
                let deNom = v
                
                let score = (Double(nom) / Double(deNom)) * 100
                
                gpFinal[k] = score
                print(k, "SwipeSCORE:",score, "\(nom)/\(deNom)")
            }
            else {
                gpFinal[k] = 0.0
                print(k, "SwipeSCORE:",0.0, "\(0)/\(v)")

            }
        }
        
        return gpFinal
    }
    
    
    
    @IBAction func dontknowTapped(_ sender: Any) {
        print("Don't Know **")
        self.movIndex += 1
        
        titleLabel.text = self.jBenzoData?.unswipedMovies![self.movIndex]
        getRawAndBenzoScores(title: titleLabel.text!)

    }
    
    
    
    @IBAction func howToWatchTapped(_ sender: Any) {
        var newTitle = self.jBenzoData?.unswipedMovies![self.movIndex]
        newTitle = newTitle?.replacingOccurrences(of: " ", with: "+")
        
        let hyperlink = "https://www.google.com/search?q=" + newTitle! + "+stream"
        
        if let url = URL(string: hyperlink) {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    

    
    @IBAction func dislikeTapped(_ sender: Any) {
        print("Dislike **")
        self.movIndex += 1
        
        // Add to swipedMovies w/title as Key and 'Dislike' as value
        SwipeService.addToSwipedMovies(title: titleLabel.text, value: "dislike")
        
        // Remove from unswipedMovies
        SwipeService.removeFromUnswipedMovies(title: titleLabel.text)
        
        // Update # rated in db
        numOfSwipes += 1
        let tempNum = numOfSwipes + (self.jBenzoData?.numOfMoviesRated)!
        SwipeService.updateNumberOfMoviesRated(count: tempNum)
        
        // Add to local vars
        self.jBenzoData?.swipedMovies![titleLabel.text!] = "dislike"
        
        checkForThresholds()
        
        // Change Info(Movie) Displayed
        titleLabel.text = self.jBenzoData?.unswipedMovies![self.movIndex]
        getRawAndBenzoScores(title: titleLabel.text!)
        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
  
    

    
    
    @IBAction func swipeLeftHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Swiped left (DISLIKE)")
        self.movIndex += 1
        
        // Add to swipedMovies w/title as Key and 'Dislike' as value
        SwipeService.addToSwipedMovies(title: titleLabel.text, value: "dislike")
        
        // Remove from unswipedMovies
        SwipeService.removeFromUnswipedMovies(title: titleLabel.text)
        
        // Update # rated in db
        numOfSwipes += 1
        let tempNum = numOfSwipes + (self.jBenzoData?.numOfMoviesRated)!
        SwipeService.updateNumberOfMoviesRated(count: tempNum)

        // Add to local vars
        self.jBenzoData?.swipedMovies![titleLabel.text!] = "dislike"
        
        checkForThresholds()

        titleLabel.text = self.jBenzoData?.unswipedMovies![self.movIndex]
        getRawAndBenzoScores(title: titleLabel.text!)
        
        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
    
    
    
    
    
    @IBAction func likeTapped(_ sender: Any) {
        print("Like **")
        self.movIndex += 1
        
        // Add to swipedMovies w/title as Key and 'Dislike' as value
        SwipeService.addToSwipedMovies(title: titleLabel.text, value: "like")
        
        // Remove from unswipedMovies
        SwipeService.removeFromUnswipedMovies(title: titleLabel.text)
        
        // Update # rated in db
        numOfSwipes += 1
        let tempNum = numOfSwipes + (self.jBenzoData?.numOfMoviesRated)!
        SwipeService.updateNumberOfMoviesRated(count: tempNum)

        // Add to local vars
        self.jBenzoData?.swipedMovies![titleLabel.text!] = "like"
        
        checkForThresholds()
        
        titleLabel.text = self.jBenzoData?.unswipedMovies![self.movIndex]
        getRawAndBenzoScores(title: titleLabel.text!)        
        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
    
    
    
    @IBAction func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Swiped right (LIKE)")
        self.movIndex += 1
        
        // Add to swipedMovies w/title as Key and 'Dislike' as value
        SwipeService.addToSwipedMovies(title: titleLabel.text, value: "like")
        
        // Remove from unswipedMovies
        SwipeService.removeFromUnswipedMovies(title: titleLabel.text)
        
        // Update # rated in db
        numOfSwipes += 1
        let tempNum = numOfSwipes + (self.jBenzoData?.numOfMoviesRated)!
        SwipeService.updateNumberOfMoviesRated(count: tempNum)

        // Add to local vars
        self.jBenzoData?.swipedMovies![titleLabel.text!] = "like"
        
        checkForThresholds()

        titleLabel.text = self.jBenzoData?.unswipedMovies![self.movIndex]
        getRawAndBenzoScores(title: titleLabel.text!)

        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
    

}






extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

