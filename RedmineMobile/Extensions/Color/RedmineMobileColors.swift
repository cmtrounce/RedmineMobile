//
//  RedmineMobileColors.swift
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

/// 🎨 The class that contains all the specific colors for the project.
extension UIColor {
    
    /**
     ### EXAMPLE ###
     This is an example of how you have to specify your colors in this class.
     All your colors MOST follow this guideline.
     
     ### HOW TO USE: ###
     When you want to use the color you can do it in the following way
     ```
        view.backgroundColor = UIColor.exampleWhite
        view.backgroundColor = .exampleWhite
     ```
     
     ### NOTE ###
     Replace this example with your actual colors!
    */
    static var redmineRed: UIColor = UIColor(hexCode: "#c30e1a")
    static var redmineBlue: UIColor = UIColor(hexCode: "#3c4251")
    static var appleRed: UIColor = UIColor.init(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1)
    static var appleBlue: UIColor = UIColor.init(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1)
}
