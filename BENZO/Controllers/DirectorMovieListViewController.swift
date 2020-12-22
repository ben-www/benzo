//
//  DirectorMovieListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/5/20.
//

import UIKit

class DirectorMovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var benzoScoreLabel: UILabel!
    
    var directorName:String?
    var data = [Movie]()
    var directorMovies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = directorName
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get Director Movies from self.data
        self.directorMovies = getDirectorMovies()
        let avg = getAvgBENZO()
        benzoScoreLabel.text = String(avg)
        

    }
    
    
    func getDirectorMovies() -> [Movie] {
        var dirMovies = [Movie]()
        
        for mov in self.data {
            //let title = String(mov.Title!)
            let dir = String(mov.Director!)
                    
            if dir == self.directorName {
                dirMovies.append(mov)
            }
        }
        
        
        return dirMovies
    
        
    }
    
    
    func getAvgBENZO() -> Double {
        
        var avg = 0.0
        
        for mov in self.directorMovies {
            avg += mov.BENZO!
        }
        
        return avg / Double(self.directorMovies.count)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dirMovieInfo" {

            let dirMovieInfoController = segue.destination as! DirectorMovieInfoViewController

            if tableView.indexPathForSelectedRow != nil {
                // add BENZO overall rating (pass value)

                dirMovieInfoController.movie = directorMovies[tableView.indexPathForSelectedRow!.row]
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }

        }
        
        
    }
    
    
    
    @IBAction func homeTapped(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}


// MARK: UITableViewDelegate, UITableViewDataSource
extension DirectorMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.directorMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.directorMovieCellId , for: indexPath) as? DirectorMovieCell
        
        
        let movie = self.directorMovies[indexPath.row]
        
        cell?.displayMovieTitle(title:movie.Title!, rank: String(movie.BENZO!))
        //self.rank += 1
        return cell!
        
    }
    
    
    
}
