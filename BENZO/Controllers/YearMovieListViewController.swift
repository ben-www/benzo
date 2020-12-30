//
//  YearMovieListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/29/20.
//

import UIKit

class YearMovieListViewController: UIViewController {
    
    
    var year:String?
    var data = [Movie]()
    var yearMovies = [Movie]()
    var avg:Double?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var benzoScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = year
        
        tableView.delegate = self
        tableView.dataSource = self
        benzoScoreLabel.text = String(avg!)

    }
    
    
    @IBAction func homeTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        let dirMovieInfoController = segue.destination as! DirectorMovieInfoViewController

        if tableView.indexPathForSelectedRow != nil {
            // add BENZO overall rating (pass value)

            dirMovieInfoController.movie = yearMovies[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }

    
        
        
    }
    

}


// MARK: UITableViewDelegate, UITableViewDataSource
extension YearMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yearMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.yearMovieCellId , for: indexPath) as? YearMovieCell
        
        
        let movie = self.yearMovies[indexPath.row]
        
        cell?.displayMovieTitle(title:movie.Title!, rank: String(movie.BENZO!))
        //self.rank += 1
        return cell!
        
    }
    
}
