//
//  MovieProvider.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import Nikka


class MovieProvider: HTTPProvider {
    let baseURL: URL = URL.init(string: "https://api.themoviedb.org/3/movie")!
    static let requiredParams: [String: Any] = ["api_key" : "83be532777e8f2578ca71df3c76cfeab", "language": "en-US"]
}

/*
 ● Now Playing: now_playing?api_key=83be532777e8f2578ca71df3c76cfeab&language=en-US&page=1
 ● Synopsis: {movie_id}?api_key=<<api_key>>&language=en-US
 ● Reviews: {movie_id}/reviews?api_key=<<api_key>>&language=en-US&page=1
 ● Credits: {movie_id}/credits?api_key=<<api_key>>
 ● Similar Movies: {movie_id}/similar
 */
extension Route {
    static let nowPlaying = { (page: Int) -> Route in
        var params = MovieProvider.requiredParams
        params["page"] = page
        return Route.init(path: "/now_playing", method: .get, params: params)
    }
    
    static let synopsis = { (movieId: Int) in
        Route.init(path: "/\(movieId)", method: .get, params: MovieProvider.requiredParams)
    }
    
    static let reviews = { (movieId: Int, page: Int) -> Route in
        var params = MovieProvider.requiredParams
        params["page"] = page
        return Route.init(path: "/\(movieId)/reviews", method: .get, params: params)
    }
    
    static let credits = { (movieId: Int) in
        Route.init(path: "/\(movieId)/credits", method: .get, params: MovieProvider.requiredParams)
    }
    
    static let similarMovies = { (movieId: Int, page: Int) -> Route in
        var params = MovieProvider.requiredParams
        params["page"] = page
        return Route.init(path: "/\(movieId)/similar", method: .get, params: params)
    }
}

