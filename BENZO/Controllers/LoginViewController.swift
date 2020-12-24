//
//  LoginViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/21/20.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    @IBAction func loginTapped(_ sender: Any) {
        // Create a FirebaseUI Object
        let authUI = FUIAuth.defaultAuthUI()
        
        // Check that it isn't nil
        if let authUI = authUI {
            // Set self as delegate for the authUI
            authUI.delegate = self
            
            // Set sing-in providers
            authUI.providers = [FUIEmailAuth()]
            
            // Get the prebuilt UI view controller
            let authViewController = authUI.authViewController()
            
            // Present it
            present(authViewController, animated: true, completion: nil)
        }
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check
        if error != nil {
            // There was an error
            return
        }
        
        let user = authDataResult?.user
        
        if let user = user {
            // Got a User
            // Check on the Database side, if User has a profile
            UserService.retrieveProfile(userId: user.uid) { (user) in
                // Check if user is nil
                if user == nil {
                    // If not, go to CreateProtfileViewController
                    self.performSegue(withIdentifier: Constants.Segue.profileSegue, sender: self)
                }
                else {
                    // If so, go to tab bar controller
                    // Save user to localStorage
                    LocalStorageService.saveUser(userId: user!.userId, username: user!.username)

                    // Create instance of Homecontroller
                    let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginSuccessful)

                    guard homeVC != nil else {
                        return
                    }
                    // Set it as the root view controller of the window
                    self.view.window?.rootViewController = homeVC
                    self.view.window?.makeKeyAndVisible()
                }
            }
            
        }
    }
}
