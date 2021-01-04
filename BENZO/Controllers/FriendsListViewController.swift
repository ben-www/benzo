//
//  FriendsListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/3/21.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var friendRequestsButton: UIButton!
    
    var friends = [String]()
    var friendListData:FriendListData?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set button image
        
        
        UserService.retrieveFriendListData { (retrievedData) in
            
            // Get the Users WatchedData
            self.friendListData = retrievedData
            
            if self.friendListData == nil {
                self.friendListData = UserService.createFriendListEntry()
            }

            if self.friendListData?.friendList != nil {
                self.friends = Array<String>((self.friendListData?.friendList!.keys)!)

            }
            
            // Do you have any Friend Requests
            if (self.friendListData?.friendRequests?.count)! > 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
            }

            
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserService.retrieveFriendListData { (retrievedData) in
            
            // Get the Users WatchedData
            self.friendListData = retrievedData
            
            if self.friendListData == nil {
                self.friendListData = UserService.createFriendListEntry()
            }

            if self.friendListData?.friendList != nil {
                self.friends = Array<String>((self.friendListData?.friendList!.keys)!)

            }
            
            // Do you have any Friend Requests
            if (self.friendListData?.friendRequests?.count)! > 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
            }

            if (self.friendListData?.friendRequests?.count)! == 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: ""), for: .normal)
            }
            
            self.tableView.reloadData()
        }
    }
    
    
    func showDeleteAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remove", style: .default) { (action) in
            //UserService.addFriend(user: user)
            //self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        
        
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.addFriend {

            let addFriendVC = segue.destination as! AddFriendViewController


            // add BENZO overall rating (pass value)
            
            if self.friendListData?.friendList != nil {
                addFriendVC.currentFriends = (self.friendListData?.friendList)!
            }
        

        }
        
        
    }
    



}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.friendListData?.friendList != nil {
            return (self.friendListData?.friendList?.count)!

        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.friendCell , for: indexPath) as? FriendCell
        
        let user = self.friends[indexPath.row]
        cell?.displayUsername(username: user)

        if ((self.friendListData?.acceptedFriends?.contains(user))!) {
            cell?.displayUsername(username: user, hasAccepted: true)

        }
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.showDeleteAlert(title: "Remove Friend", message: "Would you like to remove '\(self.friends[indexPath.row])' from your Friends List?")
            
            // Remove from DB
            
            
            tableView.reloadData()
        }
    }
    
    
}

// MARK: UISearchBarDelegate
extension FriendsListViewController: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
}
