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

    
    var testIndx = 0
    var numOfSwipes = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        
        self.data.shuffle()
        
        //self.title = "J BENZO"
        titleLabel.text = data[0].Title
        rawScoreLabel.text = "Raw Score: " + String(data[0].Raw!)
        benzoScoreLabel.text = "BENZO: " + String(data[0].BENZO!)
        genresLabel.text = JBenzoService.createCatList(mov: data[0])
        numberOfSwipesLabel.text = "(#) Movies rated in this session"

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Back to Home Works")
        
        // update JBenzoData: genrePercentages & JBenzoScores in db
        // using JBenzoService
        

    }
        
    
    
    @IBAction func dontknowTapped(_ sender: Any) {
        print("Don't Know **")
    }
    
    
    @IBAction func likeTapped(_ sender: Any) {
        print("Like **")
        self.testIndx += 1
        titleLabel.text = data[self.testIndx].Title
        rawScoreLabel.text = "Raw Score: " + String(data[self.testIndx].Raw!)
        benzoScoreLabel.text = "BENZO: " + String(data[self.testIndx].BENZO!)
        genresLabel.text = JBenzoService.createCatList(mov: data[self.testIndx])

        numOfSwipes += 1
        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
    
    
    @IBAction func dislikeTapped(_ sender: Any) {
        print("Dislike **")
    }
  
    
    @IBAction func howToWatchTapped(_ sender: Any) {
        var newTitle = data[self.testIndx].Title
        newTitle = newTitle?.replacingOccurrences(of: " ", with: "+")
        
        let hyperlink = "https://www.google.com/search?q=" + newTitle! + "+stream"
        
        if let url = URL(string: hyperlink) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func swipeLeftHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Swiped left")
        self.testIndx -= 1
        titleLabel.text = data[self.testIndx].Title
        rawScoreLabel.text = "Raw Score: " + String(data[self.testIndx].Raw!)
        benzoScoreLabel.text = "BENZO: " + String(data[self.testIndx].BENZO!)
        genresLabel.text = JBenzoService.createCatList(mov: data[self.testIndx])

        numOfSwipes += 1
        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
    
    @IBAction func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Swiped right")
        self.testIndx += 1
        titleLabel.text = data[self.testIndx].Title
        rawScoreLabel.text = "Raw Score: " + String(data[self.testIndx].Raw!)
        benzoScoreLabel.text = "BENZO: " + String(data[self.testIndx].BENZO!)
        genresLabel.text = JBenzoService.createCatList(mov: data[self.testIndx])

        numOfSwipes += 1
        numberOfSwipesLabel.text = String(numOfSwipes) + " Movies rated in this session"
    }
    

}

//dislikeTapped
//        print("Dislike **")

