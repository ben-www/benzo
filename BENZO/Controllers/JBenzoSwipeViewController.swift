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
    
    
    var data = [Movie]()
    var genres: [String] = [String]()
    var jBenzoData:JBenzoData?

    
    var testIndx = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.hidesBackButton = true
        self.title = "J BENZO"
        
        titleLabel.text = data[0].Title
        rawScoreLabel.text = String(data[0].Raw!)
        benzoScoreLabel.text = String(data[0].BENZO!)
        
        //self.swipe.delegate = self

    }

    
    @IBAction func swipeLeftHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Swiped left")
        self.testIndx -= 1
        titleLabel.text = data[self.testIndx].Title
        rawScoreLabel.text = String(data[self.testIndx].Raw!)
        benzoScoreLabel.text = String(data[self.testIndx].BENZO!)
    }
    
    @IBAction func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Swiped right")
        self.testIndx += 1
        titleLabel.text = data[self.testIndx].Title
        rawScoreLabel.text = String(data[self.testIndx].Raw!)
        benzoScoreLabel.text = String(data[self.testIndx].BENZO!)
    }
}











//extension JBenzoSwipeViewController: UIGestureRecognizerDelegate {
//
//}
