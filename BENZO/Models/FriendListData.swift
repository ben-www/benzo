//
//  FriendListData.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/3/21.
//

import Foundation
import FirebaseFirestore


struct FriendListData {
    
    var byId:String?
    var byUsername:String?
    var acceptedFriends:Array<String>?
    var friendRequests:[String : String]?

    var friendList:[String : String]?


    
    
    init? (snapshot:QueryDocumentSnapshot) {
        
        let data = snapshot.data()
        
        let byId = data["byId"] as? String
        let byUsername = data["byUsername"] as? String
        let friendList = data["friendList"] as? [String : String]?
        let acceptedFriends = data["acceptedFriends"] as? Array<String>?
        let friendRequests = data["friendRequests"] as? [String : String]?


        
        
        if byId == nil || byUsername == nil || friendList == nil || acceptedFriends == nil || friendRequests == nil  {
            return nil
        }
        
        self.byId = byId
        self.byUsername = byUsername
        self.friendList = friendList!
        self.acceptedFriends = acceptedFriends!
        self.friendRequests = friendRequests!
    }
}

extension FriendListData {
    init() {
        
    }
}
