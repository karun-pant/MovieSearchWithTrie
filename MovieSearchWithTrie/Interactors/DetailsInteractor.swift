//
//  DetailsInteractor.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import Nikka

protocol DetailsInteractionDelegate: class {
    func didLoadSynopsis(synopsys: Synopsys)
    func didLoadCredits(credits: Credits)
    func handleError(_ error: String)
}

extension DetailsInteractionDelegate {
    func didLoadSynopsis(synopsys: Synopsys){}
    func didLoadCredits(credits: Credits){}
}

class DetailsInteractor  {
    
    private var movie: Movie    
    weak var delegate: DetailsInteractionDelegate?
    var reviewsInteractor: ReviewsInteractor
    var moviesInteractor: MoviesInteractor
    private var movieId: Int
    
    
    init(movie: Movie) {
        self.movie = movie
        movieId = movie.id ?? 0
        reviewsInteractor = ReviewsInteractor.init(movieId)
        moviesInteractor = MoviesInteractor.init(with: movieId, preLoadedMovies: nil)
    }
    
    
    func loadDetails(){
        loadSynopys()
        loadCredits()
        reviewsInteractor.loadReviews()
        moviesInteractor.getMovies()
    }
    
    private func loadSynopys(){
        
        let synopsysProvider = MovieProvider()
        _ = synopsysProvider.request(.synopsis(movieId)).responseObject({ [weak self] (response: Response<Synopsys>) in
            guard let strongSelf = self else { return }
            switch response.result {
            case .success(let synopsys):
                if let delegate = strongSelf.delegate {
                    delegate.didLoadSynopsis(synopsys: synopsys)
                }
                break
            case .failure(let error):
                if let delegate = strongSelf.delegate {
                    delegate.handleError(error.description)
                }
                break
            }
        })
    }
    private func loadCredits(){
        let creditsProvider = MovieProvider()
        _ = creditsProvider.request(.credits(movieId)).responseObject({ [weak self] (response: Response<Credits>) in
            guard let strongSelf = self else { return }
            switch response.result {
            case .success(let credits):
                if let delegate = strongSelf.delegate {
                    delegate.didLoadCredits(credits: credits)
                }
                break
            case .failure(let error):
                if let delegate = strongSelf.delegate {
                    delegate.handleError(error.description)                }
                break
            }
        })
    }
}
