//
//  MyHoursHeader.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import UIKit

class MyHoursHeader: UIView {
    
    
    @IBOutlet weak var hoursAmountLabel: UILabel!
  
   
   
    
    func configure(hoursAmount: String) {
        hoursAmountLabel.text = hoursAmount
    }
    
}

extension UIView {
    
    func loadNib() -> UIView? {
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        return views.first as? UIView
    }
    
}
