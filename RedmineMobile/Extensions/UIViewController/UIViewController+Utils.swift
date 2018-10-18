//
//  UIViewController+Utils.swift
//  BPP
//
//  Created by Callum Trounce on 19/06/2017.
//  Copyright © 2017 DTT. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "", action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
