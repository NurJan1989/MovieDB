//
//  MoviewModel.swift
//  MovieDB
//
//  Created by Macbook Air on 2/25/21.
//

import Foundation

struct CurrentMovieData: Decodable {
    var results: [Result]
}

public struct Result: Decodable {
    let id: Int?
    let overview: String?
    let posterPath: String?
    var bestUrl: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath ?? "nil")"
    }
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
