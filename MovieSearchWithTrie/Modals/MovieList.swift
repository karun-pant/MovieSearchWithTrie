//
//  Movie.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation

struct SearchModal {
    var name: String
    var index: Int
    init(name: String, index: Int) {
        self.name = name
        self.index = index
    }
}

struct MovieList: Codable {
    let movies: [Movie]?
    let page, totalResults: Int?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct Movie: Codable, Hashable {
    let voteCount, id: Int?
    let video: Bool?
    let voteAverage: Double?
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let originalTitle: String?
    let backdropPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
    
    func getPopularity() -> String{
        guard let voteAverage = voteAverage else { return "" }
        if voteAverage > 0 {
            return "\(ceil(voteAverage * 10))%"
        }
        return ""
    }
    
}
