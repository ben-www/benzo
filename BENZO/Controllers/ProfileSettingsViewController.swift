//
//  ProfileSettingsViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/24/20.
//

import UIKit
import FirebaseAuth



class ProfileSettingsViewController: UIViewController {
    var data = [Movie]()
    var jBenzoData:JBenzoData?
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.usernameLabel.text = String((LocalStorageService.loadUser()?.username)!)

    }
    
    // MARK: SIGN OUT
    func showSignOutAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            do {
                try Auth.auth().signOut()
                
                LocalStorageService.clearUser()
                let loginNavVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginVC)
                
                self.view.window?.rootViewController = loginNavVC
                self.view.window?.makeKeyAndVisible()
            }
            catch {
                // Coulnd't Sign Out
            }
        }
        
        alert.addAction(yesAction)

        
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
        }
        
        alert.addAction(noAction)

        // Show Alert
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.watchlist {

            let watchlistVC = segue.destination as! WatchlistViewController
            watchlistVC.data = self.data
            watchlistVC.jBenzoData = self.jBenzoData


        }
        
        
    }
    
    


    @IBAction func signOutTapped(_ sender: Any) {
        showSignOutAlert(title: "Sign Out", message: "Are you sure?")
    }
    
    
    
    
    
}
