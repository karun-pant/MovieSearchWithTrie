//
//  DetailModals.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation

struct Synopsys: Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue, runtime: Int?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget,genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func getTimeAndGenre() -> String {
        var timeStr = ""
        var genreStr = ""
        var timeAndGenre = ""
        if let genres = genres, genres.count > 0 {
            for (index, genre) in genres.enumerated() {
                if index == genres.count - 1 {
                    genreStr.append(" \(genre.name ?? "")")
                }else {
                    genreStr.append(" \(genre.name ?? "") |")
                }
            }
        }
        if let runTime = runtime {
            timeStr = Utils.secondsToHoursMinutesSeconds(seconds: runTime)
        }
        if timeStr != "" {
            let newTimeStr = genreStr == "" ? timeStr : "\(timeStr) |"
            timeAndGenre = "\(newTimeStr)"
        }
        if genreStr != "" {
            timeAndGenre.append("\(genreStr)")
        }
        return timeAndGenre
    }
    
    func getPopularity() -> String{
        guard let voteAverage = voteAverage else { return "" }
        if voteAverage > 0 {
            return "\(ceil(voteAverage * 10))%"
        }
        return ""
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
