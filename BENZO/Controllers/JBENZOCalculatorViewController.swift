//
//  JBENZOCalculatorViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/7/20.
//

import UIKit

class JBENZOCalculatorViewController: UIViewController {
    
    var jBENZO = false
    var genres = [String]()
    var ratings: [String:Double] = [:]
    var questionNum = 1

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var percentageTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.percentageTextField.keyboardType = .decimalPad
            
        self.genreLabel.text = self.genres[self.questionNum]

    }
    
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        
        // Add Dismiss Button
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Show Alert
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        let inputRating = Double(percentageTextField.text!)

        if percentageTextField.text == "" || inputRating! < 0.0 || inputRating! > 100 {
            // Show Error ??
            self.showAlert(title: "Not Valid", message: "Please Enter a % (0.0 - 100)")
            return
        }
        else {

            // Entry is VALIDATED: Add Entry to self.Ratings
            //var pct = self.percentageTextField.text
            if self.questionNum >= self.genres.count - 2 {
                self.confirmButton.setTitle("Done", for: .normal)

            }
            if self.questionNum >= self.genres.count - 1 {
                
                self.navigationController?.popToRootViewController(animated: true)
                let homeVC = (self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeVC))! as HomeViewController
                
                self.ratings[self.genreLabel.text!] = Double(self.percentageTextField.text!)
                homeVC.ratings = self.ratings
                //homeVC.jBENZO = true

                let nav = UINavigationController.init(rootViewController: homeVC)
                self.view.window?.rootViewController = nav
                self.view.window?.makeKeyAndVisible()
                return
            }
            
            self.ratings[self.genreLabel.text!] = Double(self.percentageTextField.text!)

            
            // Erease TXTField
            self.percentageTextField.text = ""

            // Update Genre Questions index
            self.questionNum += 1
            self.genreLabel.text = self.genres[self.questionNum]
        }
        
        
    }
    
    



}
