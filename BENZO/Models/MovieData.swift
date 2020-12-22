//
//  MovieData.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import Foundation


protocol MovieDataProtocol {
    func moviesRetrieved(_ movies:[Movie])
}

class MovieData {
    
    var delegate:MovieDataProtocol?
    
    func getMovieData ()  {
        // Fetch the questions
        getLocalJsonFile()
        
        // Fetch over Network
        //getRemoteJsonFile()
        
    }
    
    func getLocalJsonFile() {
        // Get bundle path to Json File
        let path = Bundle.main.path(forResource: "moviesJson", ofType: "json")
        
        // Dbl check that the path isn't nil
        guard path != nil else {
            print("Couldn't find the json Data File")
            return
        }
        
        // Create URL object from the path
        let url = URL(fileURLWithPath: path!)
                
        do {
            // Get data from URL
            let data = try Data(contentsOf: url)
            
            // Try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Movie].self, from: data)
        
            // Notify the delegate of the retrieved questions
            delegate?.moviesRetrieved(array)
            
        }
        catch {
            // Error: Couldn't download/read the data at that URL
        }
        
    }
    
    func getRemoteJsonFile() {
        //  Network

        // Get a URL object
        let urlString = "http://192.168.1.116/moviesJson.json"

        let url = URL(string: urlString)

        guard url != nil else {
            print("Couldn't create URL Object")
            return
        }

        // Get a URL session object
        let session = URLSession.shared

        // Get a data task object
        let dataTask = session.dataTask(with: url!) { (data, response, error) in

            // Check that there wasn't an Error
            if error == nil && data != nil {
                do {
                    // Create a JSON deodcer object
                    let decoder = JSONDecoder()

                    // Parse the JSON
                    let array = try decoder.decode([Movie].self, from: data!)

                    // Use the Main Thread to notify the View Controller, for UI work
                    DispatchQueue.main.async {
                        // Notifiy delegate (View Controller)
                        self.delegate?.moviesRetrieved(array)
                    }

                }
                catch {
                    print("Couldn't parse JSON")
                }

            }
        }

        // Call resume on data task
        dataTask.resume()
    }
}
