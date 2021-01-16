//
//  AddFriendViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/3/21.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var users = [BenzoUser]()
    var foundUsers = [BenzoUser]()
    //var currentFriends = [String:String]()
    
    var searchList = [String]()
    var searching = false
    
    var friendListData:FriendListData?



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Friends"
    

        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        UserService.retrieveAllProfiles { (retrievedUsers) in
            self.users = retrievedUsers

            // Remove user from ADD list
            self.removeUserAndFriends()

            self.users.sort(by: {$0.username! < $1.username!})
            self.tableView.reloadData()
            }
        

    }
    
    
    
    func removeUserAndFriends() {
        
        // Remove current User
        let currentUser = String((LocalStorageService.loadUser()?.username)!)
        let deleteIndex = self.users.firstIndex(where: {$0.username == currentUser})
        self.users.remove(at: deleteIndex!)
        
        
        // Remove current friends & friend requests for Add User list
        let currentFriends =  (self.friendListData?.friendList)!
        let requests =  (self.friendListData?.friendRequests)!

        let friends = Array<String>((currentFriends.keys))
        let friendRequests = Array<String>((requests.keys))


        var finalUsers = [BenzoUser]()
        
        for user in self.users {
            if !friends.contains(user.username!) && !friendRequests.contains(user.username!) {
                finalUsers.append(user)
            }

        }
        
        
        
        self.users = finalUsers
        
        
        
    }
    
    
    
    // MARK: Alert
    func showAddFriendAlert(title:String, message:String, user:BenzoUser) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let addFriendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            // Add to list to SHOW pending friends
            UserService.addFriend(user: user)
            // SEND REQUEST: 
            UserService.sendFriendRequest(user: user)
            self.navigationController?.popViewController(animated: true)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        alert.addAction(addFriendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

}




extension AddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        var user = self.users[indexPath.row]
        
        if searching {
            user = self.foundUsers[indexPath.row]

        }
        print(user)

        // Prompt User to add selections to Friends list
        showAddFriendAlert(title: "Add Friend", message: "Would you like to send a friend request to '\(user.username!)'?", user: user)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.foundUsers.count
        }
        else {
            return self.foundUsers.count

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.addFriendCell , for: indexPath) as? AddFriendCell
        
        var user = self.users[indexPath.row]
        if searching {
            user = self.foundUsers[indexPath.row]
            
        }
        
        cell?.displayUsername(username: user.username!)

        return cell!
    }
    
    
}


// MARK: UISearchBarDelegate
extension AddFriendViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searching = true
        self.foundUsers = [BenzoUser]()
        
        
        for user in self.users {
            if user.username!.lowercased().contains(searchText.lowercased()) {
                self.searchList.append(user.username!)
            }
        }
        
        if searchList.count > 0 {
            for user in self.users {
                if searchList.contains(user.username!) {
                    self.foundUsers.insert(user, at: 0    )
                }
            }
        }
        
        if searchText == "" {
            searching = false
        }
        
        self.foundUsers.sort(by: { $0.username! < $1.username! })
        tableView.reloadData()
        self.searchList.removeAll()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
}

