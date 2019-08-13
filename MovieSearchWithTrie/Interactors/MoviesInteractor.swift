//
//  MoviesInteractor.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import Nikka

protocol MoviesInteractionDelegate: class {
    func handleError(_ error: String)
    func didLoadMovies(_ newMovies:[Movie], pageNumber: Int)
}

class MoviesInteractor: Pageable {
    
    
    var pageNumber: Int = 1
    
    var lastLoadedPage: Int = 0
    
    var totalPages: Int = 0
    
    var trie: Trie = Trie()
    
    enum InteractorType {
        case nowShowing, similar
    }
    
    private var movieId: Int = -1
    private var type: InteractorType = .nowShowing
    private var preLoadedMovies: [Movie]?
    
    init() {
        type = .nowShowing
    }
    
    // For similar movies
    init(with movieId: Int, preLoadedMovies: [Movie]? = nil) {
        self.movieId = movieId
        self.preLoadedMovies = preLoadedMovies
        type = .similar
    }
    
    weak var delegate: MoviesInteractionDelegate?
    
    func setPageDataForPreLoad(pageNumber: Int, totalPages: Int) {
        self.pageNumber = pageNumber
        self.totalPages = totalPages
    }
    
    public func getMovies() {
        if let preLoadedMovies = preLoadedMovies {
            handlePreload(preLoadedMovies)
            self.preLoadedMovies = nil
            return
        }
        
        guard shouldRequestMore else { return }
        
        let nowPlayingProvider = MovieProvider()
        let route: Route = type == .nowShowing ? Route.nowPlaying(pageNumber) : Route.similarMovies(movieId, pageNumber)
        _ = nowPlayingProvider.request(route).responseObject({[weak self] (response: Response<MovieList>) in
            guard let strongSelf = self else { return }
            switch response.result {
            case.success (let movieList):
                strongSelf.handleSuccess(movieList)
                break
            case .failure (let error):
                strongSelf.failurePaginationTasks()
                if let delegate = strongSelf.delegate {
                    delegate.handleError(error.description)
                }
                break
            }
        })
    }
    
    private func handlePreload(_ preLoadedMovies: [Movie]){
        if let delegate = delegate {
            delegate.didLoadMovies(preLoadedMovies, pageNumber: 1)
        }
    }
    
    private func handleSuccess(_ movieList: MovieList) {
        if let delegate = delegate {
            delegate.didLoadMovies(movieList.movies ?? [Movie](), pageNumber: self.pageNumber)
        }
        if let loadedPage = movieList.page, let totalPages = movieList.totalPages {
            successPaginationTasks(loadedPage: loadedPage, totalPages: totalPages)
        }
    }
    
    func successPaginationTasks(loadedPage: Int, totalPages: Int) {
        self.lastLoadedPage = loadedPage
        self.totalPages = totalPages
        pageNumber = pageNumber <= totalPages ? pageNumber + 1 : pageNumber
    }
    
    func failurePaginationTasks(){
        self.pageNumber = self.lastLoadedPage
    }
    
}


