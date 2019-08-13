//
//  DetailsHeader.swift
//  BMSAssignment
//
//  Created by Karun on 17/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import UIKit

class DetailsHeader: UIView {

    public var onAction: (()->())?
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func doAction(_ sender: UIButton) {
        if let onAction = onAction {
            onAction()
        }
    }
    
}
