//
//  WatchPartyViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/26/21.
//

import UIKit

class WatchPartyViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    


    
    

}


extension WatchPartyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.watchPartyCell , for: indexPath) as? WatchPartyCell
        
        return cell!

    }
    
}
