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
    
    var searchList = [String]()
    var searching = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Friends"

        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        UserService.retrieveAllProfiles { (retrievedUsers) in
            self.users = retrievedUsers
            
            self.users.sort(by: {$0.username! < $1.username!})
            
            self.tableView.reloadData()
            }
        

    }
    



}


extension AddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.foundUsers.count
        }
        else {
            return self.users.count

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
    
}

