//
//  UserService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/22/20.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

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
    
    
    
    static func createFriendListEntry() -> FriendListData {
        
        var friendListData = FriendListData()
                
        let currentUser = Auth.auth().currentUser!.uid
        let username = String((LocalStorageService.loadUser()?.username)!)
        
        friendListData.byId = currentUser
        friendListData.byUsername = username
        
        var metaData = [String:Any]()
        
        // Set metaData
        metaData["byId"] = currentUser
        metaData["byUsername"] = username
        metaData["friendList"] = [String:String]()
        metaData["friendRequests"] = [String:String]()
        metaData["acceptedFriends"] = [String]()
        

        let db = Firestore.firestore()
        
        db.collection("FriendData").document(currentUser).setData(metaData)
        
        return friendListData
        
    }
    
    
    
    
    static func addFriend(user:BenzoUser?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        let username = user?.username

        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("FriendData").document(currentUser).setData([
            "friendList": [username:user?.userId]
        ], merge: true)
        

        
    }
    
    
    
    // MARK: Load Functions
    static func retrieveFriendListData(completion: @escaping (FriendListData?) -> Void) {
        
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the user id of the current User
        let userId = LocalStorageService.loadUserID()
        
        // Get a database reference
        let db = Firestore.firestore()
        
        

        db.collection("FriendData").document(userId!).getDocument { (snapshot, error) in
            // Check for errors
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }

            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var friendData = FriendListData()

                friendData.byId = profile["byId"] as? String
                friendData.byUsername = profile["byUsername"] as? String
                friendData.friendList = profile["friendList"] as? [String:String]
                friendData.acceptedFriends = profile["acceptedFriends"] as? [String]
                friendData.friendRequests = profile["friendRequests"] as? [String:String]

                completion(friendData)
                // Return the User
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }
        
    }
    
    
    static func sendFriendRequest(user:BenzoUser?) {
        
        let currentUser = Auth.auth().currentUser!.uid
        let username = String((LocalStorageService.loadUser()?.username)!)

        
        // Get a database reference
        let db = Firestore.firestore()
        
        db.collection("FriendData").document((user?.userId)!).setData([
            "friendRequests": [username:currentUser]
        ], merge: true)
        

    }
    
    
    
    static func retrieveAllFriends(completion: @escaping ([BenzoUser]) -> Void) {
//        let db = Firestore.firestore()
        
//        db.collection("users").getDocuments { (snapshot, error) in
//            if error != nil {
//                // error getting users
//                return
//            }
//
//            let documents = snapshot?.documents
//
//            if let documents = documents {
//
//                // create array to hold users
//                var userArr = [BenzoUser]()
//
//                for doc in documents {
//
//                    let user = BenzoUser(snapshot: doc)
//
//                    if user != nil {
//                        userArr.insert(user!, at: 0)
//                    }
//                }
//
//                completion(userArr)
//            }
//        }
    }
    
    

}
