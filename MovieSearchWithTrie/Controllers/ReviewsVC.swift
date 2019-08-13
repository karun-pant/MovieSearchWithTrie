//
//  ReviewsVC.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import  UIKit

class ReviewVCCell: UITableViewCell {
    @IBOutlet weak var lblReviewer: UILabel!
    @IBOutlet weak var lblReview: UILabel!
}

class ReviewsVC: UITableViewController {
    var movieId: Int = 0
    var reviews: [Review] = [Review]()
    var interactor: ReviewsInteractor?
    
    override func viewDidLoad() {
        self.tableView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        setupNavigationBar()
        if interactor == nil {
            interactor = ReviewsInteractor.init(movieId)
        }
        weak var weakSelf = self
        interactor?.delegate = weakSelf
        interactor?.loadReviews()
    }
    
    private func setupNavigationBar(){
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.setAllTitleAppearances(.white, fontName: "Avenir-Heavy")
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#BE2E3D")
    }
}

extension ReviewsVC {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, let desiredIndexPath = visibleIndexPaths.first {
            if desiredIndexPath.row == reviews.count - 7 {
                interactor?.loadReviews()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewVCCell") as? ReviewVCCell else {
            return tableView.dequeueReusableCell(withIdentifier: "Cell")!
        }
        let review = reviews[indexPath.row]
        cell.lblReview.text = review.content
        cell.lblReviewer.text = review.author
        return cell
    }
}

extension ReviewsVC: ReviewsInteractionDelegate {
    
    private func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
        var startIndex = self.reviews.count - newReviews.count
        startIndex = startIndex < 0 ? 0 : startIndex
        let endIndex = startIndex + newReviews.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func didLoadReviews(newReviews: [Review], pageNumber: Int) {
        if pageNumber > 1 {
            let indexPathsToReload = calculateIndexPathsToReload(from: newReviews)
            self.reviews.append(contentsOf: newReviews)
            self.tableView.insertRows(at: indexPathsToReload, with: .none)
        }else {
            self.reviews.append(contentsOf: newReviews)
            self.tableView.reloadData()
        }
    }
    
    func handleError(_ error: String) {
        alert(error)
    }
}
