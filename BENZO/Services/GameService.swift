//
//  GameService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/26/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class GameService {
    
    static func createGameDataEntry() -> GameData {
        
        var gameData = GameData()
                
        let currentUser = Auth.auth().currentUser!.uid
        let username = String((LocalStorageService.loadUser()?.username)!)
        
        gameData.byId = currentUser
        gameData.byUsername = username
        
        var metaData = [String:Any]()
        
        // Set metaData
        metaData["byId"] = currentUser
        metaData["byUsername"] = username
        metaData["gameScores"] = [String:String]()


        let db = Firestore.firestore()
        
        db.collection("GameData").document(currentUser).setData(metaData)
        
        return gameData
        
    }
    
    
    // MARK: Load Functions
    static func retrieveGameData(completion: @escaping (GameData?) -> Void) {

        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }

        // Get the user id of the current User
        let userId = LocalStorageService.loadUserID()

        // Get a database reference
        let db = Firestore.firestore()



        db.collection("GameData").document(userId!).getDocument { (snapshot, error) in
            // Check for errors
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }

            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var gameData = GameData()

                gameData.byId = profile["byId"] as? String
                gameData.byUsername = profile["byUsername"] as? String
                gameData.gameScores = profile["gameScores"] as? [String:String]


                completion(gameData)
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }

    }
    
}
