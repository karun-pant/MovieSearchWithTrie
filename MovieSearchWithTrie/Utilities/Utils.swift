//
//  Utils.swift
//  BMSAssignment
//
//  Created by Karun on 17/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class Utils {
    
    class func votesWithSuffix(_ votes:Int) -> String {
        
        var num:Double = Double(votes);
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(num) Votes";
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","G","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(roundedNum)\(units[exp-1]) Votes";
    }
    
    class func downloadImage(imagePath: String, completion: @escaping (UIImage)-> ()) {
        if let completeUrl = URL.init(string: "https://image.tmdb.org/t/p/w1280\(imagePath)"){
            let downloader = ImageDownloader.default
            downloader.downloadImage(with: completeUrl) { result in
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure(let error):
                    print(error)
                }
            }
                    
        }
    }
    
    class func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        var runTime = ""
        if hours > 0 {
            runTime.append("\(hours)h ")
        }
        if minutes > 0 {
            runTime.append("\(minutes)m ")
        }
        if seconds > 0 {
            runTime.append("\(seconds)s")
        }
        return runTime
    }
    
}

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UINavigationController {
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    func setTitleForgroundTitle(_ color: UIColor, fontName: String) {
        
        let font = UIFont.init(name: fontName, size: 17)
        self.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: color, NSAttributedString.Key.font.rawValue: font ?? UIFont.systemFont(ofSize: 17)])
    }
    
    func setLargeTitle(_ color: UIColor, fontName: String) {
        
        let font = UIFont.init(name: fontName, size: 30)
        self.navigationBar.largeTitleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: color, NSAttributedString.Key.font.rawValue: font ?? UIFont.systemFont(ofSize: 30)])
    }
    
    func setAllTitleAppearances(_ color: UIColor, fontName: String) {
        setTitleForgroundTitle(color, fontName: fontName)
        setLargeTitle(color, fontName: fontName)
        self.navigationBar.tintColor = color
    }
}

public extension UIColor {
    
    convenience init(hexString:String) {
        let hexString : String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        _=scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
}
extension UIViewController {
    func alert(_ message: Any?) {
        guard let strMessage = message as? String else { return }
        let contoller = UIAlertController(title: nil, message: strMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        contoller.addAction(alertAction)
        self.present(contoller, animated: true, completion: nil)
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


