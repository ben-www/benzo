//
//  SearchViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data = [Movie]()
    var foundData = [Movie]()
    var scopeIndex = 0
    
    var searching = false
    
    var movieTitles = [String]()
    var movieDirectors = [String]()
    var movieYears = [String]()

    var searchList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for mov in data {
            let title = String(mov.Title!)
            let year = String(mov.Year!)
            let dir = String(mov.Director!)
            
            if !self.movieTitles.contains(title) {
                self.movieTitles.append(title)
            }
            if !self.movieYears.contains(year) {
                self.movieYears.append(year)
            }
            if !self.movieDirectors.contains(dir) {
                self.movieDirectors.append(dir)
            }
        }
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let movieInfoController = segue.destination as! MovieInfoViewController
        
        // SEARCHING FUNCTIONALITY
        //!!!!!!
        
        
        if tableView.indexPathForSelectedRow != nil {
            
            

            // pass on movie
            if searching {
                let index = self.data.firstIndex(where: { $0.Title == foundData[tableView.indexPathForSelectedRow!.row].Title })
                movieInfoController.rank = Int(index!) + 1
                movieInfoController.data = self.data

                
                movieInfoController.movie = foundData[tableView.indexPathForSelectedRow!.row]
                

            } else {
                let index = self.data.firstIndex(where: { $0.Title == data[tableView.indexPathForSelectedRow!.row].Title })
                movieInfoController.rank = Int(index!) + 1
                
                movieInfoController.data = self.data

                movieInfoController.movie = data[tableView.indexPathForSelectedRow!.row]

            }
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
    }
        

    
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return foundData.count
        }
        else {
            return self.data.count

        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.searchTitleCellId , for: indexPath) as? SearchTitleCell
        
        var movie:Movie?
        
        if searching {
            movie = self.foundData[indexPath.row]
        }
        else {
            movie = self.data[indexPath.row]
            
        }
                
        
        if movie != nil {
            cell?.displayMovieTitle(title: (movie?.Title!)!, rank: String((movie?.BENZO!)!))

        }

        return cell!
        
    }
    

}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.searching = true
        self.foundData = [Movie]()
        
    
        if self.scopeIndex == 0 {
            
            //searchList = movieTitles.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            
            for title in self.movieTitles {
                if title.lowercased().contains(searchText.lowercased()) {
                    self.searchList.append(title)
                }
            }
            
            
            if searchList.count > 0 {
                for mov in self.data {
                    if searchList.contains(mov.Title!) {
                        self.foundData.insert(mov, at: 0    )
                    }
                }
            }
            
        }
        else if self.scopeIndex == 1 {
            
            searchList = movieYears.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})

    
            if searchList.count > 0 {
                for mov in self.data {
                    if searchList.contains(String(mov.Year!)) {
                        self.foundData.insert(mov, at: 0    )
                    }
                }
            }
            
        }
        else if self.scopeIndex == 2 {
            
            //searchList = movieDirectors.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            
            for dir in self.movieDirectors {
                if dir.lowercased().contains(searchText.lowercased()) {
                    self.searchList.append(dir)
                }
            }
            
            if searchList.count > 0 {
                for mov in self.data {
                    if searchList.contains(mov.Director!) {
                        self.foundData.insert(mov, at: 0    )
                    }
                }
            }
            
        }

        
        self.foundData.sort(by: { $0.BENZO! > $1.BENZO! })
        tableView.reloadData()
        self.searchList.removeAll()

        

    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        self.scopeIndex = selectedScope
        self.searchBar.text = nil
        
        if self.scopeIndex == 0 {
            self.searchBar.placeholder = "Title"
        }
        if self.scopeIndex == 1 {
            self.searchBar.placeholder = "Year"
        }
        if self.scopeIndex == 2 {
            self.searchBar.placeholder = "Director"
        }
        print(selectedScope)
        self.searching = false
        tableView.reloadData()
        
    }
    
}
