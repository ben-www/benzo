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
    
    var foundDirectors = [DirectorData]()
    var foundYears = [YearData]()
    
    var scopeIndex = 0
    
    var jBenzoData:JBenzoData?
    
    var searching = false
    
    var movieTitles = [String]()
    var movieDirectors = [String]()
    var movieYears = [String]()
    var searchList = [String]()
    
    var allDirectorData = [DirectorData]()
    var allYearData = [YearData]()

    
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
        
        getAllDirectorData()
        getAllYearData()
        self.allDirectorData.sort(by: { $0.avg! > $1.avg! })
        self.allYearData.sort(by: { $0.avg! > $1.avg! })
    }

    
    func getAllYearData() {
        // Get AVG Benzo for each Director, before creating table -> To Sort
        for yr in self.movieYears {
            
            var temp = YearData()
            
            temp.year = yr
            temp.yearMovies = LocalBenzoService.getYearMovies(data: self.data, year: yr)
            
            var avg = getAvgBENZO(directorMovies: temp.yearMovies)
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                avg = getAvgBENZO(directorMovies: temp.yearMovies, jBenzo: true)
            }
            
            avg = round(10000.0 * avg) / 10000.0
            temp.avg = avg
            self.allYearData.append(temp)

        }
        
    }
    
    
    func getAllDirectorData() {
        // Get AVG Benzo for each Director, before creating table -> To Sort
        for dir in self.movieDirectors {
            
            var temp = DirectorData()
            
            temp.name = dir
            temp.directorMovies = LocalBenzoService.getDirectorMovies(data: self.data, directorName: dir)
            
            var avg = getAvgBENZO(directorMovies: temp.directorMovies)
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                avg = getAvgBENZO(directorMovies: temp.directorMovies, jBenzo: true)
            }
            
            avg = round(10000.0 * avg) / 10000.0
            temp.avg = avg
            self.allDirectorData.append(temp)

        }
        
    }
    
    
    
    func getAvgBENZO(directorMovies: [Movie], jBenzo:Bool = false ) -> Double {
        
        var avg = 0.0
        
        for mov in directorMovies {
            if jBenzo {
                avg += mov.jBENZO!

            } else {
                avg += mov.BENZO!

            }
        }
        
        return avg / Double(directorMovies.count)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.movieDirectorInfo {
            
            let directorController = segue.destination as! DirectorMovieListViewController
            
            directorController.data = self.data
            if searching {
                directorController.directorName = self.foundDirectors[tableView.indexPathForSelectedRow!.row].name
                directorController.directorMovies = self.foundDirectors[tableView.indexPathForSelectedRow!.row].directorMovies
            }
            else {
                directorController.directorName = self.allDirectorData[tableView.indexPathForSelectedRow!.row].name
                directorController.directorMovies = self.allDirectorData[tableView.indexPathForSelectedRow!.row].directorMovies
            }

            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)

        }

        if segue.identifier == Constants.Segue.yearMovieList {
            
            let yearVC = segue.destination as! YearMovieListViewController
            
            yearVC.data = self.data
            if searching {
                yearVC.year = self.foundYears[tableView.indexPathForSelectedRow!.row].year
                yearVC.yearMovies = self.foundYears[tableView.indexPathForSelectedRow!.row].yearMovies
                yearVC.avg =  self.foundYears[tableView.indexPathForSelectedRow!.row].avg
            }
            else {
                yearVC.year = self.allYearData[tableView.indexPathForSelectedRow!.row].year
                yearVC.yearMovies = self.allYearData[tableView.indexPathForSelectedRow!.row].yearMovies
                yearVC.avg =  self.allYearData[tableView.indexPathForSelectedRow!.row].avg

            }

            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)

        }
        
        //searchCelltoMovieInfo
        if segue.identifier == Constants.Segue.searchCelltoMovieInfo {
            let movieInfoController = segue.destination as! MovieInfoViewController

            if tableView.indexPathForSelectedRow != nil {

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
        

    
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            switch self.scopeIndex {
            case 1:
                return self.foundYears.count
            case 2:
                return self.foundDirectors.count
            default:
                return foundData.count
            }
        }
        else {
            
            switch self.scopeIndex {
            case 1:
                return self.movieYears.count
            case 2:
                return self.movieDirectors.count
            default:
                return self.data.count

            }
            //return self.data.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        if self.scopeIndex == 0 {
            self.performSegue(withIdentifier: Constants.Segue.searchCelltoMovieInfo, sender: nil)
        }
        if self.scopeIndex == 1 {
            self.performSegue(withIdentifier: Constants.Segue.yearMovieList, sender: nil)
        }
        if self.scopeIndex == 2 {
            self.performSegue(withIdentifier: Constants.Segue.movieDirectorInfo, sender: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.searchTitleCellId , for: indexPath) as? SearchTitleCell
        
        var movie:Movie?
        var dir:DirectorData?
        var yr:YearData?
        
        
        if self.scopeIndex == 1 {
            // self.scopeIndex == 1: Years
            if searching {
                yr = self.foundYears[indexPath.row]
            }
            else {
                yr = self.allYearData[indexPath.row]
            }
            
            cell?.displayMovieTitle(title: (yr?.year)!, rank: String((yr?.avg!)!))
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                cell?.displayMovieTitle(title: (yr?.year)!, rank: String((yr?.avg!)!), jBenzo: true)
            }

        }
        else if self.scopeIndex == 2 {
            // self.scopeIndex == 2: Directors
            if searching {
                dir = self.foundDirectors[indexPath.row]
            }
            else {
                dir = self.allDirectorData[indexPath.row]
            }
            
            cell?.displayMovieTitle(title: (dir?.name!)!, rank: String((dir?.avg!)!))
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                cell?.displayMovieTitle(title: (dir?.name!)!, rank: String((dir?.avg!)!), jBenzo: true)
            }

        }
        else {
            // self.scopeIndex == 0: Titles
            if searching {
                movie = self.foundData[indexPath.row]
            }
            else {
                movie = self.data[indexPath.row]
            }
            
            
            if movie != nil {
                cell?.displayMovieTitle(title: (movie?.Title!)!, rank: String((movie?.BENZO!)!))
                
                if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                    let score = movie?.jBENZO
                    let finalScore = round(10000.0 * score!) / 10000.0
                    cell?.displayMovieTitle(title:(movie?.Title!)!, rank: String(finalScore), jBenzo: true)
                }
            }
            return cell!
            
        }

        return cell!
    }
    
}


// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.searching = true
        self.foundData = [Movie]()
        self.foundDirectors = [DirectorData]()
        self.foundYears = [YearData]()

    
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
            
            for yr in self.movieYears {
                if yr.lowercased().contains(searchText.lowercased()) {
                    self.searchList.append(yr)
                }
            }
            
            if searchList.count > 0 {
                for yr in self.allYearData {
                    if searchList.contains(yr.year!) {
                        self.foundYears.insert(yr, at: 0    )
                    }
                }
            }
            
        }
        else if self.scopeIndex == 2 {
            
            for dir in self.movieDirectors {
                if dir.lowercased().contains(searchText.lowercased()) {
                    self.searchList.append(dir)
                }
            }
            
            if searchList.count > 0 {
                for dir in self.allDirectorData {
                    if searchList.contains(dir.name!) {
                        self.foundDirectors.insert(dir, at: 0    )
                    }
                }
            }
            
        }

        self.foundYears.sort(by: { $0.avg! > $1.avg! })
        self.foundDirectors.sort(by: { $0.avg! > $1.avg! })
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
}
