//
//  Navigation+Style.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    static func style() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.barTintColor = .redmineBlue
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
