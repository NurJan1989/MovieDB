//
//  NetworkManager.swift
//  MovieDB
//
//  Created by Macbook Air on 2/25/21.
//

import Foundation

struct NetworkManager {
    
    func fetchCurrentMovie(complitionHandler: @escaping([Result])->()) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {return}
        let seesion = URLSession.shared
        seesion.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                print("Status Code: ",response.statusCode)
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let currentMovieData = try decoder.decode(CurrentMovieData.self, from: data )
                    complitionHandler(currentMovieData.results)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
