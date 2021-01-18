//
//  SwipeService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/7/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class SwipeService {
    
    static func addToSwipedMovies(title:String?, value:String?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()

        db.collection("JBenzoUserData").document(currentUser).setData([
            "swipedMovies": [title:value]
        ], merge: true)
                
    }
    
    
    
    static func removeFromUnswipedMovies(title:String?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("JBenzoUserData").document(currentUser).updateData(["unswipedMovies":FieldValue.arrayRemove([title!])])
    }

    
    
    static func updateNumberOfMoviesRated(count:Int?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("JBenzoUserData").document(currentUser).updateData(["numOfMoviesRated":count!])
    }
    
    static func updateGPs( genrePercentages:[String:Double] ) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        //db.collection("SwipeData").document(currentUser).updateData(["genrePercentages":])
    }
    
    
    
    
    static func createSwipeDataEntry() -> SwipeData {
        
        var swipeData = SwipeData()
                
        let currentUser = Auth.auth().currentUser!.uid
        let username = String((LocalStorageService.loadUser()?.username)!)
        
        swipeData.byId = currentUser
        swipeData.byUsername = username
        
        var metaData = [String:Any]()
        
        // Set metaData
        metaData["byId"] = currentUser
        metaData["byUsername"] = username
        metaData["genrePercentages"] = [String:Double]()



        let db = Firestore.firestore()
        
        db.collection("SwipeData").document(currentUser).setData(metaData)
        
        return swipeData
        
    }
    
    
    // MARK: Load Functions
    static func retrieveSwipeData(completion: @escaping (SwipeData?) -> Void) {

        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }

        // Get the user id of the current User
        let userId = LocalStorageService.loadUserID()

        // Get a database reference
        let db = Firestore.firestore()



        db.collection("SwipeData").document(userId!).getDocument { (snapshot, error) in
            // Check for errors
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }

            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var swipeData = SwipeData()

                swipeData.byId = profile["byId"] as? String
                swipeData.byUsername = profile["byUsername"] as? String
                swipeData.genrePercentages = profile["genrePercentages"] as? [String:Double]


                completion(swipeData)
                // Return the User
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }

    }

    
    
}
