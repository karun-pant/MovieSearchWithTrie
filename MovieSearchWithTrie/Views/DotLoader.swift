//
//  DotLoader.swift
//  BMSAssignment
//
//  Created by Karun on 16/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import UIKit

enum LoaderMode {
    case page
    case button
}

class DotLoader: UIView {
    
    fileprivate var contentView: UIView!
    fileprivate var noOfDots : Int = 5
    fileprivate var dotViews : [UIView] = []
    fileprivate var dotFrame : CGRect = .zero
    fileprivate var animDuration = 0.35
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(noOfDots: Int = 5, loaderMode: LoaderMode = .page) {
        self.init(frame: .zero)
        let dotFrame = self.getDotFrame(loaderMode: loaderMode)
        let containerFrame = self.getContainerFrame(noOfDots: noOfDots, dotFrame: dotFrame)
        self.frame = containerFrame
        self.noOfDots = noOfDots
        self.dotFrame = dotFrame
        setupView()
        
    }
    
    convenience init(loaderMode: LoaderMode) {
        
        self.init(frame: .zero)
        
        let dotFrame = self.getDotFrame(loaderMode: loaderMode)
        let noOfDots = self.getNoOfDots(loaderMode: loaderMode)
        let containerFrame = self.getContainerFrame(noOfDots: noOfDots , dotFrame: dotFrame)
        self.frame = containerFrame
        self.noOfDots = noOfDots
        self.dotFrame = dotFrame
        setupView()
        
    }
    
}

extension DotLoader {
    
    
    func getDotFrame(loaderMode: LoaderMode) -> CGRect{
        
        switch loaderMode {
        case .page: return CGRect(x: 0, y: 0, width: 12, height: 12)
        case .button: return CGRect(x: 0, y: 0, width: 8, height: 8)
            
        }
    }
    
    func getContainerFrame(noOfDots: Int, dotFrame: CGRect) -> CGRect{
        
        //dotFrame.width is the distance between the dots
        //dotFrame.width/2 is the leading and trailing space
        //2 is the space above and below the dots
        
        let totalDotsWidth = Double(noOfDots) * Double(dotFrame.width)
        let spaceBtwDots = Double(dotFrame.width * CGFloat((noOfDots-1)))
        
        return  CGRect(x: 0, y: 0, width: totalDotsWidth + spaceBtwDots + Double(dotFrame.width), height: Double(dotFrame.height * 2.0) + 4)
    }
    
    func getNoOfDots(loaderMode: LoaderMode) -> Int{
        switch loaderMode {
            
        case .page: return 4
        case .button: return 3
            
        }
    }
    
    func setupView() {
        
        self.isUserInteractionEnabled = false
        contentView = UIView(frame: self.bounds)
        contentView.backgroundColor = .clear
        contentView.alpha = 0.0
        contentView.isUserInteractionEnabled = false
        addSubview(contentView)
        
        if self.noOfDots > 4 {
            self.animDuration = 0.35 + 0.05*Double((self.noOfDots-4))
        } else{
            self.animDuration = 0.35
        }
        
        self.addDotViews()
    }
    
    func addDotViews(){
        for i in 0..<self.noOfDots {
            let dotView = UIView(frame: dotFrame)
            let y = contentView.center.y - (dotFrame.height/2)
            let x = dotView.center.x
            dotView.center = CGPoint.init(x: x, y: y)
            
            if i == 0 {
                let frameX = dotView.frame.origin.x + dotFrame.width/2.0
                var newRect = dotView.frame
                newRect.origin.x = frameX
                dotView.frame = newRect
                
            }else {
                let totalDotWidth = Double(i) * Double(dotFrame.width)
                let totalSpaceWidth = Double(i) * Double(dotFrame.width)
                let frameX = dotView.frame.origin.x + CGFloat(totalSpaceWidth + totalDotWidth + Double(dotFrame.width)/2.0)
                var newRect = dotView.frame
                newRect.origin.x = frameX
                dotView.frame = newRect
            }
            
            dotView.layer.cornerRadius = dotFrame.height/2
            dotView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
            dotView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            dotView.isUserInteractionEnabled = false
            contentView.addSubview(dotView)
            dotViews.append(dotView)
        }
    }
    
    func doAnimations(){
        
        for i in 0..<self.noOfDots{
            
            let dotView = self.dotViews[i]
            let delay = Double(i)*(self.animDuration/Double(noOfDots))
            
            //Up Down animation
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = self.animDuration
            animation.beginTime = CACurrentMediaTime() + delay
            animation.repeatCount = .infinity
            animation.autoreverses = true
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.isRemovedOnCompletion = false
            
            animation.fromValue = NSValue(cgPoint: CGPoint(x: dotView.center.x , y: dotView.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: dotView.center.x, y: dotView.center.y +  dotView.frame.size.height))
            
            self.dotViews[i].layer.add(animation, forKey: "position")
            
            
            //Scale Up Animations
            UIView.animate(withDuration: self.animDuration, delay: delay, options: [.curveEaseInOut], animations: {
                dotView.transform =  CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    
    func startAnimating(){
        contentView.alpha = 1.0
        self.doAnimations()
    }
    
    func stopAnimating(){
        
        for i in 0..<self.noOfDots{
            self.dotViews[i].layer.removeAllAnimations()
            self.dotViews[i].removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
}

