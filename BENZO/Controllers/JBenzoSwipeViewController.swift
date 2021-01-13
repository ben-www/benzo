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
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("BACK to Home Works")
        // update JBenzoData: genrePercentages & JBenzoScores in db
        

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
        
        // Update Local Variables
        
        
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

