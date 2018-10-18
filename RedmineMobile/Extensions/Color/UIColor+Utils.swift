//
//  UIColor+Utils.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright (c) 2018 DTT. All rights reserved.
//
//  REMINDER:
//
//  If you need help or don't remember how to, first take a look at the code conventions:
//  https://docs.google.com/document/d/1vFtsnmMlqilCOF4Y087AMRdCsp_CwhzR6wRVkzb7eIw/edit?usp=sharing
//  
//  BUT WAIT there is more!
//  The official raywenderlich.com Swift Style Guide. 
//  https://github.com/raywenderlich/swift-style-guide
//

import UIKit

/// 🎨 The base for all the UIColor utility functions. Contains the must haves for each project.
extension UIColor {
    
    /// Initialise a new color using a hex code.
    ///
    /// - Parameter hexCode: hex code representation of the color you wish to use.
    convenience init(hexCode: String) {
        
        var cString: String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.characters.count != 6 {
            self.init(white: 0.5, alpha: 1)
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
        
    }
    
}
