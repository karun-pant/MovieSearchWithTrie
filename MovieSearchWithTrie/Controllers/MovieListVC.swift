//
//  ViewController.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPoster: BMSImageView!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblPopularity: UILabel!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var imgAdvisory: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
}


class MovieListVC: UITableViewController, Loadable {
    
    var loader: DotLoader?
    var movies: [Movie] = [Movie]()
    var filteredMovies: [Movie]?
    var interactor: MoviesInteractor?
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSearchController()
        self.tableView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        loader = showLoader(loader)
        if interactor == nil {
            interactor = MoviesInteractor()
        }
        weak var weakSelf = self
        interactor?.delegate = weakSelf
        interactor?.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.setAllTitleAppearances(.white, fontName: "Avenir-Heavy")
    }
    
    private func setupSearchController() {
        self.searchController = UISearchController.init(searchResultsController: nil)
        let scb = self.searchController?.searchBar
        weak var weakSelf = self
        self.searchController?.searchResultsUpdater = weakSelf;
        self.searchController?.delegate = weakSelf
        self.searchController?.searchBar.sizeToFit()
        definesPresentationContext = true
        scb?.alpha = 0.8
        scb?.barTintColor = .clear
        scb?.tintColor = .white
        scb?.backgroundColor = .clear
        if let navigationbar = self.navigationController?.navigationBar {
            navigationbar.barTintColor = UIColor.init(hexString: "#BE2E3D")
        }
        self.searchController?.dimsBackgroundDuringPresentation = false;
        scb?.tintColor = UIColor.white
        scb?.barTintColor = UIColor.white
        
        if let textfield = scb?.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    
}

extension MovieListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, let desiredIndexPath = visibleIndexPaths.first {
            if desiredIndexPath.row == movies.count - 7 {
                interactor?.getMovies()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movies = filteredMovies, let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell") as? MovieListCell else {
            return tableView.dequeueReusableCell(withIdentifier: "Cell")!
        }
        
        let movie = movies[indexPath.row]
        
        cell.lblName.text = movie.title
        cell.lblReleaseDate.text = movie.releaseDate
        let pop = movie.getPopularity()
        if pop != "" {
            cell.lblPopularity.isHidden = false
            cell.imgHeart.isHidden = false
            cell.lblVotes.isHidden = false
            cell.lblPopularity.text = pop
            if let voteCount = movie.voteCount {
                cell.lblVotes.text = Utils.votesWithSuffix(voteCount)
            }
        }else {
            cell.lblPopularity.isHidden = true
            cell.imgHeart.isHidden = true
            cell.lblPopularity.text = ""
            cell.lblVotes.isHidden = true
        }
        if let adult = movie.adult {
            cell.imgAdvisory.isHidden = !adult
            cell.lblDescription.isHidden = adult
        }
        cell.lblDescription.text = movie.overview
        if let posterPath = movie.posterPath {
            cell.imgPoster.loadImage(imagePath: posterPath)
        }
        cell.btnBook.roundCorners(corners: [.bottomRight], radius: 8)
        cell.imgPoster.roundCorners(corners: [.topLeft, .bottomLeft], radius: 8)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movies = filteredMovies, let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            let movie = movies[indexPath.row]
            detailsVC.movie = movie
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
}


extension MovieListVC: MoviesInteractionDelegate {
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        var startIndex = self.movies.count - newMovies.count
        startIndex = startIndex < 0 ? 0 : startIndex
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    func handleError(_ error: String) {
        hideLoader(loader)
        alert(error)
    }
    
    func didLoadMovies(_ newMovies: [Movie], pageNumber: Int) {
        hideLoader(loader)
        if pageNumber > 1 {
            let indexPathsToReload = calculateIndexPathsToReload(from: newMovies)
            self.movies.append(contentsOf: newMovies)
            self.filteredMovies = self.movies
            self.tableView.insertRows(at: indexPathsToReload, with: .none)
            interactor?.trie.fillTrie(movies)
        }else {
            self.movies.append(contentsOf: newMovies)
            self.filteredMovies = self.movies
            self.tableView.reloadData()
            interactor?.trie.fillTrie(movies)
        }
    }
}

extension MovieListVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            filteredMovies = interactor?.trie.findMoviesWithPrefix(in: movies, prefix: searchText)
            self.tableView.reloadData()
        }else {
            filteredMovies = movies
            self.tableView.reloadData()
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        filteredMovies = movies
        self.tableView.reloadData()
    }
    
}

