//
//  Reviews.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation

struct ReviewList: Codable {
    let id, page: Int?
    let reviews: [Review]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, page
        case reviews = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Review: Codable {
    let author, content, id: String?
    let url: String?
}
