//
//  JBENZOCalculatorViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/7/20.
//

import UIKit

class GetGenrePercentagesViewController: UIViewController {
    
    var jBENZO = false
    var genres = [String]()
    var genrePercentages: [String:Double] = [:]
    var questionNum = 1
    

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var percentageTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.title = "J BENZO"
        
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

            // Entry is VALIDATED: Add Entry to self.genrePercentages
            //var pct = self.percentageTextField.text
            if self.questionNum >= self.genres.count - 2 {
                self.confirmButton.setTitle("Done", for: .normal)

            }
            // Last Genre to give %
            if self.questionNum >= self.genres.count - 1 {
                
                self.genrePercentages[self.genreLabel.text!] = Double(self.percentageTextField.text!)
                
                // Create Jbenzo DB entry w/ Genre %(s), using userId & self.genrePercentages
                _ = JBenzoService.createJBenzoEntry(genrePercentages: self.genrePercentages)

                self.navigationController?.popToRootViewController(animated: true)
                let homeVC = (self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeVC))! as HomeViewController

                let nav = UINavigationController.init(rootViewController: homeVC)
                self.view.window?.rootViewController = nav
                self.view.window?.makeKeyAndVisible()
                return
            }
            
            self.genrePercentages[self.genreLabel.text!] = Double(self.percentageTextField.text!)

            
            // Erease TXTField
            self.percentageTextField.text = ""

            // Update Genre Questions index
            self.questionNum += 1
            self.genreLabel.text = self.genres[self.questionNum]
        }
    }
    
    



}
