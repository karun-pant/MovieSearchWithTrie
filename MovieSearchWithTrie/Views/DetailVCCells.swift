//
//  DetailVCCells.swift
//  BMSAssignment
//
//  Created by Karun on 18/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var lblReviewer: UILabel!
    @IBOutlet weak var lblReview: UILabel!
}

class MovieDetailsCell: UITableViewCell {
    
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var lblTotalVotes: UILabel!
    @IBOutlet weak var lblRatingPercentage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblTimeAndGenre: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
}

class CarouselCell: UITableViewCell {
    @IBOutlet weak var carouselView: CarouselView!
    
}

class CarouselView: UIView {
    private var movieDataSource: [Movie]?
    private var castDataSource: [Cast]?
    private var crewDataSource: [Crew]?
    @IBOutlet weak var carousel: UICollectionView!
    
    override func awakeFromNib() {
        let nib = UINib.init(nibName: "CastCollectionViewCell", bundle: nil)
        carousel.register(nib, forCellWithReuseIdentifier: "CastCollectionViewCell")
    }
    
    func reloadMovieCarousel(with data: [Movie]){
        movieDataSource = data
        crewDataSource = nil
        castDataSource = nil
        carousel.dataSource = self
        carousel.reloadData()
    }
    func reloadCrewCarousel(with data: [Crew]){
        movieDataSource = nil
        crewDataSource = data
        castDataSource = nil
        carousel.dataSource = self
        carousel.reloadData()
    }
    func reloadCastCarousel(with data: [Cast]){
        movieDataSource = nil
        crewDataSource = nil
        castDataSource = data
        carousel.dataSource = self
        carousel.reloadData()
    }
    
    
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = movieDataSource {
            return dataSource.count
        }else if let dataSource = castDataSource {
            return dataSource.count
        }else if let dataSource = crewDataSource {
            return dataSource.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell
        if let dataSource = movieDataSource {
            let movie = dataSource[indexPath.item]
            if let posterPath = movie.posterPath {
                cell?.imgProfilePic.loadImage(imagePath: posterPath)
                cell?.imgProfilePic.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            }else {
                cell?.imgProfilePic.image = nil
                cell?.imgProfilePic.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            }
            cell?.lblName.text = movie.title
            cell?.lblSubDetail.text = movie.releaseDate
            
        }else if let dataSource = castDataSource {
            let cast = dataSource[indexPath.item]
            if let profilePath = cast.profilePath {
                cell?.imgProfilePic.loadImage(imagePath: profilePath)
                cell?.imgProfilePic.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            }else {
                cell?.imgProfilePic.image = nil
                cell?.imgProfilePic.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            }
            cell?.lblName.text = cast.name
            cell?.lblSubDetail.text = cast.character
            
        }else if let dataSource = crewDataSource {
            let crew = dataSource[indexPath.item]
            if let profilePath = crew.profilePath {
                cell?.imgProfilePic.loadImage(imagePath: profilePath)
                cell?.imgProfilePic.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            }else {
                cell?.imgProfilePic.image = nil
                cell?.imgProfilePic.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            }
            cell?.lblName.text = crew.name
            cell?.lblSubDetail.text = crew.job
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: 148, height: 259)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
