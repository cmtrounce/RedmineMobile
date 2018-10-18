//
//  AppDelegate.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 20/12/2017.
//  Copyright © 2017 DTT. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let authenticationService = AuthenticationService()
    
    var tabbedController: UITabBarController {
        let controller = UITabBarController()
        
        let loggedHours = LoggedHoursViewController()
        loggedHours.tabBarItem = UITabBarItem.init(title: "My Logged Hours", image: #imageLiteral(resourceName: "passage-of-time"), tag: 2)
        controller.viewControllers = [UINavigationController.init(rootViewController: loggedHours)]
        controller.title = "Redmine"
        controller.tabBar.barTintColor = UIColor.init(white: 0.9, alpha: 1)
        controller.tabBar.tintColor = .redmineBlue
        controller.tabBar.isTranslucent = false
        controller.tabBar.unselectedItemTintColor = .lightGray
        controller.selectedIndex = 0
        return controller
    }
    
    var loginNav: UINavigationController {
        let loginVC = LoginViewController()
        let loginNav = UINavigationController.init(rootViewController: loginVC)
        return loginNav
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SVProgressHUD.style()
        UINavigationBar.style()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = authenticationService.credentials() {
            window?.rootViewController = tabbedController
        } else {
            window?.rootViewController = loginNav
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func switchTo(nav: UIViewController) {
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

