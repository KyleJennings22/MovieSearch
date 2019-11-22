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
    
    // MARK: - LIFECYCLE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We conformed to UISearchBarDelegate, need to set our delegate as ourself
        movieSearchBar.delegate = self
    }
    
    //MARK: - ACTIONS
    @IBAction func favoritesButtonTapped(_ sender: UIBarButtonItem) {
        if sender.title == "Favorites" {
            sender.title = "Cancel"
            favoritesShown = true
            self.tableView.reloadData()
        } else {
            sender.title = "Favorites"
            favoritesShown = false
            self.tableView.reloadData()
        }
    }
    

    // MARK: - VARIABLES
    
    // Creating an empty array of movies to assign results of fetching movies, then reloading on the main queue when it is set.
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Creating an array of favorite movies
    var favoriteMovies: [Movie] = []
    
    // Setting a variable for favorites
    var favoritesShown = false

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If favorites shown is true then return the favorite movies array
        if favoritesShown {
            return favoriteMovies.count
        } else {
            return movies.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}

        if favoritesShown {
            cell.movieLanding = favoriteMovies[indexPath.row]
        } else {
            cell.movieLanding = movies[indexPath.row]
        }
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
    
    // I know this was deprecated but I couldn't find a way to do this without it. Slide to favorite
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { (action, indexPath) in
            self.favoriteMovies.append(self.movies[indexPath.row])
            self.tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.systemYellow
        }
        favorite.backgroundColor = .systemGreen
        return [favorite]
    }

    // When search button is clicked on search bar
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

