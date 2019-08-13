//
//  Pageable.swift
//  BMSAssignment
//
//  Created by Karun on 17/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation

protocol Pageable {
    var pageNumber: Int { get set }
    var lastLoadedPage: Int {get set}
    var totalPages: Int {get set}
    var shouldRequestMore: Bool {get}
    func successPaginationTasks(loadedPage: Int, totalPages: Int)
    func failurePaginationTasks()
}

extension Pageable {
    var shouldRequestMore: Bool{
        get {
            //page number should be less then total + handle first load
            return (pageNumber < totalPages) || (pageNumber == 1 && totalPages == 0)
        }
    }
    
}
