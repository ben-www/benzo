//
//  CreateProfileViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/21/20.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    var allUsers = [BenzoUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.delegate = self
        
        UserService.retrieveAllProfiles { (retrievedUsers) in
            self.allUsers = retrievedUsers
        }

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    

    @IBAction func confirmTapped(_ sender: Any) {
        // Check that there is a User logged in
        guard Auth.auth().currentUser != nil else {
            // No user logged in
            return
        }
        
        // Get the username
        // Check it against whitespace, new lines, illegal char, tec.
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that the username isn't nil
        if username == nil || username == "" {
            // Show an error message and return
            return
        }
        

        // Check if username is Available
        for user in self.allUsers {
            if user.username == username {
                // Username is Taken, show an error message and return
                let alert = UIAlertController(title: "Try Again", message: "Sorry, that username already exists!", preferredStyle: .alert)
                let takenAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

                alert.addAction(takenAction)

                // Show Alert
                present(alert, animated: true, completion: nil)

                return
            }
        }
        
        
        
        // Call the userService to create the profile
        UserService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!) { (user) in
            // Check if created successfully
            if user != nil {
                // If so, go to the tab contorller
                // Save user to localStorage
                LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
                
                let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginSuccessful)
                
                // Set it as the root view controller of the window
                self.view.window?.rootViewController = homeVC
                self.view.window?.makeKeyAndVisible()
                
            }
            else {
                // If not, display error

            }
        }
        
        
        
    }
    
}
