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
    var friends = [BenzoUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        
        tableView.delegate = self
        tableView.dataSource = self
        
//
//        UserService.retrieveAllProfiles { (retrievedUsers) in
//            self.users = retrievedUsers
//
//            self.users.sort(by: {$0.username! < $1.username!})
//
//            self.tableView.reloadData()
//            }
        
    }
    



}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.friendCell , for: indexPath) as? FriendCell
        
        let user = self.friends[indexPath.row]
        
        cell?.displayUsername(username: user.username!)

        return cell!
    }
    
    
}

// MARK: UISearchBarDelegate
extension FriendsListViewController: UISearchBarDelegate {

    
}
