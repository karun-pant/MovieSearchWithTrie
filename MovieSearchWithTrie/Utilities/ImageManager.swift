//
//  File.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import Kingfisher

class BMSImageView: UIImageView {
    private var imageBaseURL = "https://image.tmdb.org/t/p/w1280"

    func loadImage(imagePath: String) {
        if let completeUrl = URL.init(string: "\(imageBaseURL)\(imagePath)"){
            self.kf.setImage(with: completeUrl, options: [.transition(.fade(0.2))])
        }
    }
    
    
    
}
