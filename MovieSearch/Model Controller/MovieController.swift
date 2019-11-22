//
//  MovieController.swift
//  MovieSearch
//
//  Created by Kyle Jennings on 11/22/19.
//  Copyright © 2019 Kyle Jennings. All rights reserved.
//

import UIKit

class MovieController {
    
    // Static function accessible globally that will retrieve movies based on user search
    static func getMovies(searchTerm: String, completion: @escaping (Result<[Movie], MovieAPIError>) -> Void ) {
        // Creating and unrwrapping a URL by appending paths
        guard let baseURL = URL(string: "https://api.themoviedb.org")?.appendingPathComponent("3").appendingPathComponent("search").appendingPathComponent("movie") else {return completion(.failure(.invalidURL))}
        
        // Creating queries
        let queryAPI = URLQueryItem(name: "api_key", value: "5a305d7b820dcbeed1d9b87786e175d5")
        let queryLanguage = URLQueryItem(name: "language", value: "en-US")
        let queryMovie = URLQueryItem(name: "query", value: searchTerm)
        
        // Creating the URL components
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [queryAPI, queryLanguage, queryMovie]
        
        // Creating the final URL
        guard let url = urlComponents?.url else {return completion(.failure(.invalidURL))}
        
        // Initializing the datatask
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                completion(.failure(.communicationError))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                // Getting data as top level dict
                let topLevelDict = try JSONDecoder().decode(TopLevelDict.self, from: data)
                // Assigning the results of the topleveldict to [Movie]
                completion(.success(topLevelDict.results))
            } catch {
                print(error)
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    // Static function to get image for specified movie
    static func getImageForMovie(movie: Movie, completion: @escaping (Result<UIImage?, MovieAPIError>) -> Void) {
        guard let baseURL = URL(string: "https://image.tmdb.org")?.appendingPathComponent("t").appendingPathComponent("p").appendingPathComponent("w500").appendingPathComponent(movie.poster) else {return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print(error)
                completion(.failure(.communicationError))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            // Images are easy when we have data
            let image = UIImage(data: data)
            
            completion(.success(image))
        }.resume()
    }
}

enum MovieAPIError: LocalizedError {
    case invalidURL
    case communicationError
    case noData
    case unableToDecode
}
