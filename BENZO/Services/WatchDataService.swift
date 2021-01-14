//
//  WatchDataService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/30/20.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class WatchDataService {
    
    static func createWatchDataEntry() -> WatchData {
        
        var watchData = WatchData()
                
        let currentUser = Auth.auth().currentUser!.uid
        let username = String((LocalStorageService.loadUser()?.username)!)
        
        watchData.byId = currentUser
        watchData.byUsername = username
        
        var metaData = [String:Any]()
        
        // Set metaData
        metaData["byId"] = currentUser
        metaData["byUsername"] = username
        metaData["watchlist"] = [String]()
        metaData["alreadyWatchedMovies"] = [String]()


        
        let db = Firestore.firestore()
        
        db.collection("WatchData").document(currentUser).setData(metaData)
        
        return watchData
        
    }
    
    
    // MARK: Load Functions
    static func retrieveWatchData(data:[Movie], completion: @escaping (WatchData?) -> Void) {
        
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the user id of the current User
        let userId = LocalStorageService.loadUserID()
        
        // Get a database reference
        let db = Firestore.firestore()
        
        

        db.collection("WatchData").document(userId!).getDocument { (snapshot, error) in
            // Check for errors
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }

            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var watchData = WatchData()

                watchData.byId = profile["byId"] as? String
                watchData.byUsername = profile["byUsername"] as? String
                watchData.watchlist = profile["watchlist"] as? Array<String>
                watchData.alreadyWatchedMovies = profile["alreadyWatchedMovies"] as? Array<String>


                completion(watchData)
                // Return the User
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }
        
    }
    
    
    static func retrieveFriendWatchData(data:[Movie], userId:String, completion: @escaping (WatchData?) -> Void) {
        
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the user id of the current User
        //let userId = LocalStorageService.loadUserID()
        
        // Get a database reference
        let db = Firestore.firestore()
        
        

        db.collection("WatchData").document(userId).getDocument { (snapshot, error) in
            // Check for errors
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }

            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var watchData = WatchData()

                watchData.byId = profile["byId"] as? String
                watchData.byUsername = profile["byUsername"] as? String
                watchData.watchlist = profile["watchlist"] as? Array<String>
                watchData.alreadyWatchedMovies = profile["alreadyWatchedMovies"] as? Array<String>


                completion(watchData)
                // Return the User
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }
        
    }
    

    static func addToWatchlist(title:String?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("WatchData").document(currentUser).updateData(["watchlist":FieldValue.arrayUnion([title!])])

        
    }

    static func removeFromWatchlist(title:String?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("WatchData").document(currentUser).updateData(["watchlist":FieldValue.arrayRemove([title!])])

        
    }
    
    
    static func addToAlreadyWatchedlist(title:String?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("WatchData").document(currentUser).updateData(["alreadyWatchedMovies":FieldValue.arrayUnion([title!])])
    }
    
    static func removeFromAlreadyWatchlist(title:String?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("WatchData").document(currentUser).updateData(["alreadyWatchedMovies":FieldValue.arrayRemove([title!])])

    }
    
}
