//
//  ProjectsViewController.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProjectsViewController: UIViewController {

    fileprivate let viewModel = ProjectsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Redmine"
        viewModel.viewDidFinishLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
