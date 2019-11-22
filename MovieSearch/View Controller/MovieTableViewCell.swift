//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Kyle Jennings on 11/22/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleTextField: UILabel!
    @IBOutlet weak var movieRatingTextField: UILabel!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    // Creating a movie landing that will update views when it is set
    var movieLanding: Movie? {
        didSet {
            updateViews()
        }
    }
    
    // Function to update the views of the cell
    func updateViews() {
        guard let movie = self.movieLanding else {return}
        
        // Need to get the image for the movie
        MovieController.getImageForMovie(movie: movie) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    
                    // updating the image on the main queue
                    self.moviePosterImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
        DispatchQueue.main.async {
            
            // updating the fields on the main queue (want to do this separately from the image function in case an image doesn't exist, these wouldn't be called)
            self.movieTitleTextField.text = movie.title
            self.movieRatingTextField.text = "Rating: \(movie.rating)"
            self.movieOverviewTextView.text = movie.overview
        }
    }

}
