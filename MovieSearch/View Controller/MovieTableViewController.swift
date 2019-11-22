//
//  MovieTableViewController.swift
//  MovieSearch
//
//  Created by Kyle Jennings on 11/22/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We conformed to UISearchBarDelegate, need to set our delegate as ourself
        movieSearchBar.delegate = self
    }

    // Creating an empty array of movies to assign results of fetching movies, then reloading on the main queue when it is set.
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}

        cell.movieLanding = movies[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMovieDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? MovieDetailViewController else {return}
            destinationVC.movie = self.movies[indexPath.row]
        }
    }
    
    // Implementing this so when someone clicks on a cell it doesn't stay selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {return}
        // getting a movie based on search text
        MovieController.getMovies(searchTerm: searchText) { (result) in
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                print(error)
            }
        }
        // Better UX - set text to nothing after search and dismiss the keybaord
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
