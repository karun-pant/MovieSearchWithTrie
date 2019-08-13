//
//  DetailsViewController.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class DetailsVC: UITableViewController, Loadable {

    public var movie: Movie?
    var loader: DotLoader?
    fileprivate var interactor: DetailsInteractor?
    fileprivate var dataSource: [String: Any?] = ["synopsys": nil,
                                                  "reviews" : nil,
                                                  "cast": nil,
                                                  "crew": nil,
                                                  "similarMovies": nil
                                                  ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            interactor = DetailsInteractor.init(movie: movie)
            weak var weakSelf = self
            interactor?.moviesInteractor.delegate = weakSelf
            interactor?.reviewsInteractor.delegate = weakSelf
            interactor?.delegate = weakSelf
            if let backDrop = movie.backdropPath {
                let header: DetailsTableHeader = UIView.fromNib()
                header.imgHeader.loadImage(imagePath: backDrop)
                if let adult = movie.adult {
                    header.advisory.isHidden = !adult
                }
                self.tableView.tableHeaderView = header
            }else if let poster = movie.posterPath {
                let header: DetailsTableHeader = UIView.fromNib()
                header.imgHeader.loadImage(imagePath: poster)
                if let adult = movie.adult {
                    header.advisory.isHidden = !adult
                }
                self.tableView.tableHeaderView = header
            }
        }
        setupNavigationBar()
        loader = showLoader(loader)
        interactor?.loadDetails()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar(){
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.setAllTitleAppearances(.white, fontName: "Avenir-Heavy")
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hexString: "#BE2E3D")
    }
    
}

extension DetailsVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataSource["synopsys"] != nil ? 1 : 0
        }else if section == 1 {
            guard let reviews = dataSource["reviews"] as? [Review],
                let _ = reviews.first(where: { (review) -> Bool in
                    if let content = review.content, content.count > 0 {
                        return true
                    }
                    return false
                }) else { return 0 }
            return 1
        }else if section == 2 {
            guard let cast = dataSource["cast"] as? [Cast], cast.count > 0  else { return 0 }
            return 1
        }else if section == 3 {
            guard let crew = dataSource["crew"] as? [Crew], crew.count > 0  else { return 0 }
            return 1
        }else {
            guard let movies = dataSource["similarMovies"] as? [Movie], movies.count > 0 else { return 0 }
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            guard let synopsys = dataSource["synopsys"] as? Synopsys,
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell") as? MovieDetailsCell else {
                    return tableView.dequeueReusableCell(withIdentifier: "Cell")!
            }
            cell.lblName.text = synopsys.originalTitle
            cell.lblReleaseDate.text = synopsys.releaseDate
            cell.lblTimeAndGenre.text = synopsys.getTimeAndGenre()
            cell.lblDetails.text = synopsys.overview
            let pop = synopsys.getPopularity()
            if pop != "" {
                cell.ratingsView.isHidden = false
                cell.lblRatingPercentage.text = pop
                if let voteCount = synopsys.voteCount {
                    cell.lblTotalVotes.text = Utils.votesWithSuffix(voteCount)
                }
            }else {
                cell.ratingsView.isHidden = false
            }
            return cell
        }else if section == 1 {
            guard let reviews = dataSource["reviews"] as? [Review],
                let review = reviews.first(where: { (review) -> Bool in
                    if let content = review.content, content.count > 0 {
                        return true
                    }
                    return false
                }) ,
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as? ReviewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "Cell")!
            }
            cell.lblReview.text = review.content
            cell.lblReviewer.text = review.author
            return cell
        }else if section == 2 {
            guard let cast = dataSource["cast"] as? [Cast], cast.count > 0 ,
                let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselCell") as? CarouselCell else {
                    return tableView.dequeueReusableCell(withIdentifier: "Cell")!
            }
            cell.carouselView.reloadCastCarousel(with: cast)
            return cell
        }else if section == 3 {
            guard let crew = dataSource["crew"] as? [Crew], crew.count > 0 ,
                let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselCell") as? CarouselCell else {
                    return tableView.dequeueReusableCell(withIdentifier: "Cell")!
            }
            cell.carouselView.reloadCrewCarousel(with: crew)
            return cell
        }else {
            guard let movies = dataSource["similarMovies"] as? [Movie], movies.count > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselCell") as? CarouselCell else {
                    return tableView.dequeueReusableCell(withIdentifier: "Cell")!
            }
            cell.carouselView.reloadMovieCarousel(with: movies)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else if section == 1 {
            guard let reviews = dataSource["reviews"] as? [Review],
                let _ = reviews.first(where: { (review) -> Bool in
                if let content = review.content, content.count > 0 {
                    return true
                }
                return false
            })  else { return 0 }
            return 56
        }else if section == 2 {
            guard let cast = dataSource["cast"] as? [Cast], cast.count > 0  else { return 0 }
            return 56
        }else if section == 3 {
            guard let crew = dataSource["crew"] as? [Crew], crew.count > 0  else { return 0 }
            return 56
        }else {
            guard let movies = dataSource["similarMovies"] as? [Movie], movies.count > 0 else { return 0 }
            return 56
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else if section == 1 {
            guard let reviews = dataSource["reviews"] as? [Review] else { return nil }
            let view: DetailsHeader = UIView.fromNib()
            view.lblHeaderTitle.text = "Reviews"
            view.onAction = {
                //load review
                guard let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsVC") as? ReviewsVC
                    else { return }
                if let movie = self.movie, let movieId = movie.id {
                    let reviewsInteractor = ReviewsInteractor.init(movieId, preLoadedReviews: reviews)
                    reviewsInteractor.setPageDataForPreLoad(pageNumber: self.interactor?.moviesInteractor.pageNumber ?? 1,
                                                           totalPages: self.interactor?.moviesInteractor.totalPages ?? 1)
                    
                    reviewVC.interactor = reviewsInteractor
                }
                self.navigationController?.pushViewController(reviewVC, animated: true)
            }
            return view
        }else if section == 2 {
            guard let cast = dataSource["cast"] as? [Cast], cast.count > 0  else { return nil }
            let view: DetailsHeader = UIView.fromNib()
            view.lblHeaderTitle.text = "Cast"
            view.btnAction.isHidden = true
            return view
        }else if section == 3 {
            guard let crew = dataSource["crew"] as? [Crew], crew.count > 0  else { return nil }
            let view: DetailsHeader = UIView.fromNib()
            view.lblHeaderTitle.text = "Crew"
            view.btnAction.isHidden = true
            return view
        }else {
            guard let movies = dataSource["similarMovies"] as? [Movie], movies.count > 0 else { return nil }
            let view: DetailsHeader = UIView.fromNib()
            view.lblHeaderTitle.text = "Similar movies"
            view.onAction = {
                //load movies
                guard let movieListVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieListVC") as? MovieListVC
                    else { return }
                if let movie = self.movie, let movieId = movie.id {
                    let moviesInteractor = MoviesInteractor.init(with: movieId, preLoadedMovies: movies)
                    moviesInteractor.setPageDataForPreLoad(pageNumber: self.interactor?.moviesInteractor.pageNumber ?? 1,
                                                           totalPages: self.interactor?.moviesInteractor.totalPages ?? 1)
                    movieListVC.title = "Similar movies"
                    movieListVC.interactor = moviesInteractor
                }
                self.navigationController?.pushViewController(movieListVC, animated: true)
            }
            return view
        }
    }
}

extension DetailsVC: DetailsInteractionDelegate, MoviesInteractionDelegate, ReviewsInteractionDelegate {
    func didLoadMovies(_ newMovies: [Movie], pageNumber: Int) {
        dataSource["similarMovies"] = newMovies
        self.tableView.reloadData()
        hideLoader(loader)
    }
    
    func didLoadSynopsis(synopsys: Synopsys) {
        dataSource["synopsys"] = synopsys
        self.tableView.reloadData()
        hideLoader(loader)
    }
    
    func didLoadReviews(newReviews: [Review], pageNumber: Int) {
        dataSource["reviews"] = newReviews
        self.tableView.reloadData()
        hideLoader(loader)
    }
    
    func didLoadCredits(credits: Credits) {
        if let cast = credits.cast, cast.count > 0 {
            dataSource["cast"] = cast
        }
        if let crew = credits.crew, crew.count > 0 {
            dataSource["crew"] = crew
        }
        self.tableView.reloadData()
        hideLoader(loader)
    }
    
    func handleError(_ error: String) {
        hideLoader(loader)
        alert(error)
    }
}
