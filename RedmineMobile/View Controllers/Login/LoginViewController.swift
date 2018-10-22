//
//  LoginViewController.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 20/12/2017.
//  Copyright © 2017 DTT. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    private let authService = AuthenticationService()
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.backgroundColor = UIColor.groupTableViewBackground
            loginButton.clipsToBounds = true
            loginButton.layer.cornerRadius = 6
            loginButton.setTitle("Login", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
    }
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, let server = serverTextField.text else { return }
        
        authService.logIn(server: server,
                          username: username,
                          password: password,
                          success:
            { user in
                
                print("LOGGED IN AS " + user.firstname + " " + user.lastname)
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                appDelegate.switchTo(nav: appDelegate.tabbedController)
                
        }, failure: { error in
            self.alert(message: error.localizedDescription)
        })
    }
    
}
