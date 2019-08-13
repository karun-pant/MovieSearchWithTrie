
//
//  Loadable.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import UIKit
import Foundation

protocol Loadable {
    var loader: DotLoader? {get set}
    func showLoader(_ loader: DotLoader?) -> DotLoader
    func hideLoader(_ loader: DotLoader?)
}

extension Loadable where Self: UIViewController {
    
    func showLoader(_ loader: DotLoader?) -> DotLoader {
        if let loader = loader {
            loader.center = view.center
            self.view.addSubview(loader)
            loader.startAnimating()
            return loader
        }else {
            let loader = DotLoader.init(loaderMode: .page)
            loader.center = view.center
            self.view.addSubview(loader)
            loader.startAnimating()
            return loader
        }
    }
    
    func hideLoader(_ loader: DotLoader?) {
        if let loader = loader{
            loader.stopAnimating()
        }
    }
}
