//
//  ReviewsInteractor.swift
//  BMSAssignment
//
//  Created by Karun on 17/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import Nikka

protocol ReviewsInteractionDelegate: class {
    func didLoadReviews(newReviews: [Review], pageNumber: Int)
    func handleError(_ error: String)
}

class ReviewsInteractor: Pageable {
    
    var pageNumber: Int = 1
    
    var lastLoadedPage: Int = 0
    
    var totalPages: Int = 0
    private var movieId: Int
    private var preLoadedReviews: [Review]?
    
    init(_ movieId: Int, preLoadedReviews: [Review]? = nil) {
        self.preLoadedReviews = preLoadedReviews
        self.movieId = movieId
    }
    
    weak var delegate: ReviewsInteractionDelegate?
    
    func setPageDataForPreLoad(pageNumber: Int, totalPages: Int) {
        self.pageNumber = pageNumber
        self.totalPages = totalPages
    }
    
    func loadReviews(){
        if let preLoadedReviews = preLoadedReviews {
            handlePreload(preLoadedReviews)
            self.preLoadedReviews = nil
            return
        }
        
        guard shouldRequestMore else { return }
        
        let reviewProvider = MovieProvider()
        _ = reviewProvider.request(.reviews(movieId, pageNumber)).responseObject({[weak self] (response: Response<ReviewList>) in
            guard let strongSelf = self else { return }
            switch response.result {
            case .success(let reviewList):
                if let delegate = strongSelf.delegate {
                    delegate.didLoadReviews(newReviews: reviewList.reviews ?? [Review](), pageNumber: strongSelf.pageNumber)
                }
                if let loadedPage = reviewList.page, let totalPages = reviewList.totalPages {
                    strongSelf.successPaginationTasks(loadedPage: loadedPage, totalPages: totalPages)
                }
                break
            case .failure(let error):
                strongSelf.failurePaginationTasks()
                if let delegate = strongSelf.delegate {
                    delegate.handleError(error.description)
                }
                break
            }
        })
    }
    
    private func handlePreload(_ preLoadedReviews: [Review]){
        if let delegate = delegate {
            delegate.didLoadReviews(newReviews: preLoadedReviews, pageNumber: 1)
        }
    }
    
    func successPaginationTasks(loadedPage: Int, totalPages: Int) {
        self.lastLoadedPage = loadedPage
        self.totalPages = totalPages
        pageNumber = pageNumber <= totalPages ? pageNumber + 1 : pageNumber
    }
    
    func failurePaginationTasks() {
        self.pageNumber = self.lastLoadedPage
    }
    
}
