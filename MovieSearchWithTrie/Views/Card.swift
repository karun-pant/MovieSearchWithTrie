//
//  Card.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable
class Card: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = .black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var borderColor: UIColor = .black
    @IBInspectable var borderWidth:CGFloat = 0
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
    }
}
