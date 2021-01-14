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
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var friendRequestsButton: UIButton!
    
    var blurEffectView = UIVisualEffectView()
    var pickerData: [String] = [String]()

    var data = [Movie]()
    
    var friends = [String]()
    var friendListData:FriendListData?
    var friendRequestUsername:String?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends"
        self.friendRequestsButton.isEnabled = false

        
        tableView.delegate = self
        tableView.dataSource = self
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        // Set button image
        
        self.popoverView.layer.cornerRadius = 24
        self.popoverView.layer.shadowColor = UIColor.black.cgColor
        self.popoverView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.popoverView.layer.shadowOpacity = 0.2
        self.popoverView.layer.shadowRadius = 4.0
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.blurEffectView.effect = blurEffect
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        
        
        UserService.retrieveFriendListData { (retrievedData) in
            
            // Get the Users WatchedData
            self.friendListData = retrievedData
            
            if self.friendListData == nil {
                self.friendListData = UserService.createFriendListEntry()
            }

            if self.friendListData?.friendList != nil {
                self.friends = Array<String>((self.friendListData?.friendList!.keys)!)
                self.friends.sort()

            }
            
            // Do you have any Friend Requests
            if (self.friendListData?.friendRequests?.count)! > 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
                self.pickerData = Array<String>((self.friendListData?.friendRequests!.keys)!)
                self.friendRequestsButton.isEnabled = true


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
                self.friends.sort()


            }
            
            // Do you have any Friend Requests
            if (self.friendListData?.friendRequests?.count)! > 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
                self.pickerData = Array<String>((self.friendListData?.friendRequests!.keys)!)
                self.friendRequestsButton.isEnabled = true
            }

            if (self.friendListData?.friendRequests?.count)! == 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: ""), for: .normal)
                self.friendRequestsButton.isEnabled = false

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
    
    
    
    
    
    @IBAction func friendRequestsTapped(_ sender: Any) {
        self.blurEffectView.alpha = 0.5
        print("Friend Requests Tapped")
        self.view.addSubview(self.blurEffectView)
        self.view.addSubview(self.popoverView)
        popoverView.center = self.view.center
        
        
    }
    
    
    
    @IBAction func acceptTapped(_ sender: Any) {
        
        // Add to acceptedFriends for USER & SENDER & Add to friendsList for USER
        UserService.updateAcceptedFriends(friendRequestUsername: self.friendRequestUsername!, friendRequests:(self.friendListData?.friendRequests)!)
        
        // Remove from friendRequests for USER
        UserService.removeFriendRequest(friendRequestUsername: self.friendRequestUsername!, friendRequests:(self.friendListData?.friendRequests)!)


        
        UserService.retrieveFriendListData { (retrievedData) in
            
            // Get the Users WatchedData
            self.friendListData = retrievedData
            
            if self.friendListData == nil {
                self.friendListData = UserService.createFriendListEntry()
            }

            if self.friendListData?.friendList != nil {
                self.friends = Array<String>((self.friendListData?.friendList!.keys)!)
                self.friends.sort()


            }
            
            // Do you have any Friend Requests
            if (self.friendListData?.friendRequests?.count)! > 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
                
                self.pickerData = Array<String>((self.friendListData?.friendRequests!.keys)!)
                self.picker.reloadAllComponents()
                self.picker.selectRow(0, inComponent: 0, animated: true)
                
                self.friendRequestsButton.isEnabled = true
            }

            if (self.friendListData?.friendRequests?.count)! == 0 {
                self.friendRequestsButton.setImage(UIImage(systemName: ""), for: .normal)
                self.friendRequestsButton.isEnabled = false

            }
            
            
            self.popoverView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
            self.tableView.reloadData()
        }
        
        
        
//
//        self.popoverView.removeFromSuperview()
//        self.blurEffectView.removeFromSuperview()
//        tableView.reloadData()
    }
    
    
    @IBAction func declineTapped(_ sender: Any) {
        
        self.popoverView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        tableView.reloadData()
    }
    

    @IBAction func cancelTapped(_ sender: Any) {
        self.popoverView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.addFriend {

            let addFriendVC = segue.destination as! AddFriendViewController

            if self.friendListData?.friendList != nil {
                //addFriendVC.currentFriends = (self.friendListData?.friendList)!
                addFriendVC.friendListData = self.friendListData
            }
        }
        
        if segue.identifier == Constants.Segue.friendListToActions {
            
            let friendActionsVC = segue.destination as! FriendActionsViewController
            
            let friendTapped = self.friends[tableView.indexPathForSelectedRow!.row]
            
            friendActionsVC.friend =  friendTapped
            friendActionsVC.friendId =  self.friendListData?.friendList![friendTapped]
            friendActionsVC.data = self.data

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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        let user = self.friends[indexPath.row]
        
        if ((self.friendListData?.acceptedFriends?.contains(user))!) {
            self.performSegue(withIdentifier: Constants.Segue.friendListToActions, sender: nil)

        }
        

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


// MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension FriendsListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.friendRequestUsername = self.pickerData[0]
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        self.friendRequestUsername = pickerData[row]


    }
    
    
    
}
