//
//  Extensions.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 8/30/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func isAlphanumeric()->Bool{
        let range = NSMakeRange(0, self.count)
        //return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
        do {
            let regexSpecial = try NSRegularExpression(pattern: ".*[^a-zA-Z0-9].*", options: NSRegularExpression.Options())
            if let _ = regexSpecial.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range){
                return false
            }
        }catch{
            debugPrint(error.localizedDescription)
            return false
        }
        return true
    }//end of isAlphanumeric
    
    func isPasswordValid()->Bool{
        var hasSpecial:Bool = false
        var hasNumber:Bool = false
        var hasAlpha:Bool = false
        let range = NSMakeRange(0, self.count)
        
        do {
            let regexSpecial = try NSRegularExpression(pattern: ".*[^a-zA-Z0-9].*", options: NSRegularExpression.Options())
            if let _ = regexSpecial.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range){
                hasSpecial = true
            }
            let regexAlpha = try NSRegularExpression(pattern: ".*[a-zA-Z].*", options: NSRegularExpression.Options())
            if let _ = regexAlpha.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range){
                hasAlpha = true
            }
            let regexNumeric = try NSRegularExpression(pattern: ".*[0-9].*", options: NSRegularExpression.Options())
            if let _ = regexNumeric.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range){
                hasNumber = true
            }
        }catch{
            debugPrint(error.localizedDescription)
            return false
        }
        
        return hasSpecial && hasNumber && hasAlpha
    }//end of isValidPassword
}


extension UIColor{
    static let madisonBlue = UIColor(red: 44.0/255.0, green: 61.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    //static let newTan = UIColor(red: 210.0/255, green: 180.0/255.0, blue: 140.0/255.0, alpha: 1.0)
}

extension UIView{
    func addGradient(colors:[CGColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.frame
        self.layer.addSublayer(gradientLayer)
        self.revealSubviews()
    }
    
    func revealSubviews() {
        for subView in self.subviews{
            self.bringSubview(toFront: subView)
        }
    }
}




