//
//  UIWindow+Blur.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    private var currentBlurView: UIVisualEffectView? {
        return self.viewWithTag(1000) as? UIVisualEffectView
    }
    
    private func addBlurView() {
        let view = UIVisualEffectView()
        view.alpha = 0
        view.effect = UIBlurEffect.init(style: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.tag = 1000
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func showBlur() {
        
        if currentBlurView == nil {
            addBlurView()
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.currentBlurView?.alpha = 1
        }
    }
    
    private func hideBlur() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.currentBlurView?.alpha = 0
        }
    }
    
    static func showBlur() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let currentWindow = appDelegate.window else {
            print("couldnt find window")
            return
        }
        
        currentWindow.showBlur()
    }
    
    static func hideBlur() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let currentWindow = appDelegate.window else {
            print("couldnt find window")
            return
        }
        
        currentWindow.hideBlur()
    }
}
