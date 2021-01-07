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
    
    
    
    
    
}
