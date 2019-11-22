//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Kyle Jennings on 11/22/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieTextView: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    // MARK: - VARIABLES
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }

    // function to update views when movie is set
    func updateViews() {
        guard let theMovie = movie else {return}
        MovieController.getImageForMovie(movie: theMovie) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
        DispatchQueue.main.async {
            self.movieTitleLabel.text = theMovie.title
            self.movieRatingLabel.text = "Rating: \(theMovie.rating)"
            self.movieTextView.text = theMovie.overview
        }
    }
}
