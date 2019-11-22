//
//  Movie.swift
//  MovieSearch
//
//  Created by Kyle Jennings on 11/22/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//
// API KEY -  5a305d7b820dcbeed1d9b87786e175d5
import Foundation

struct TopLevelDict: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    var title: String
    var overview: String
    var poster: String
    var rating: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case poster = "poster_path"
        case rating = "vote_average"
    }
}
