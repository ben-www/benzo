//
//  UserService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/22/20.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    
    // ONLY CALLED FROM LoginViewController
    static func retrieveProfile(userId:String, completion: @escaping (BenzoUser?) -> Void) {
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Check for a profile, given the UserId
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }
            
            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var u = BenzoUser()
                u.userId = snapshot!.documentID
                u.username = profile["username"] as? String
                completion(u)
                // Return the User
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }
        
    }
    
    
    static func createProfile(userId:String, username:String, completion: @escaping (BenzoUser?) -> Void ) {
    
        // Create a dict for the profile data
        let profileData = ["username":username, "userId":userId]
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Create the document for the userId
        db.collection("users").document(userId).setData(profileData) { (error) in
            
            // Check for errors
            if error == nil {
                // Profile was created successfully
                // Create and return a User
                let u = BenzoUser(userId: userId, username: username)

                completion(u)
            }
            else {
                // Somthing went wrong
                completion(nil)             // Return nil
            }
        }

    }
    
    
    static func retrieveAllProfiles(completion: @escaping ([BenzoUser]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snapshot, error) in
            if error != nil {
                // error getting users
                return
            }
            
            let documents = snapshot?.documents
            
            if let documents = documents {
                
                // create array to hold users
                var userArr = [BenzoUser]()
                
                for doc in documents {
                    
                    let user = BenzoUser(snapshot: doc)
                    
                    if user != nil {
                        userArr.insert(user!, at: 0)
                    }
                }
                
                completion(userArr)
            }
        }
    }
    
    

}
