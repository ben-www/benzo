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

        // Get the Average Benzo score for Dir,  MOVIE LIST pass in from last VC
        let avg = getAvgBENZO()
        benzoScoreLabel.text = String(avg)
        

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
            
            dirMovieInfoController.data = self.data

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
