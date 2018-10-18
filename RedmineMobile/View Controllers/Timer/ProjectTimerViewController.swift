//
//  ProjectTimerViewController.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit
import Hero
import RxSwift
import RxCocoa

class ProjectTimerViewController: UIViewController {
    
    @IBOutlet weak var pauseTimerButton: UIButton! {
        didSet {
            pauseTimerButton.clipsToBounds = true
            pauseTimerButton.layer.cornerRadius = 6
            
        }
    }
    
    @IBOutlet weak var stopTimerButton: UIButton! {
        didSet {
            stopTimerButton.clipsToBounds = true
            stopTimerButton.layer.cornerRadius = 6
            stopTimerButton.backgroundColor = .appleRed
        }
    }
    
    @IBOutlet weak var startTimerButton: UIButton! {
        didSet {
            startTimerButton.clipsToBounds = true
            startTimerButton.layer.cornerRadius = 6
            startTimerButton.hero.id = "startTimerButton"
        }
    }
    
    @IBOutlet weak var projectTitleLabel: UILabel! {
        didSet {
            projectTitleLabel.text = project.name
        }
    }
    
    @IBOutlet weak var elapsedTimeLabel: UILabel! {
        didSet {
            viewModel.formattedElapsedTime
                .bind(to: elapsedTimeLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var dismissButton: UIButton!
    
    private let viewModel = ProjectTimerViewModel()
    private let disposeBag = DisposeBag()
    private var project: TimeEntry.Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hero.isEnabled = true
        view.hero.modifiers = [HeroModifier.arc()]
    }
    
    deinit {
        viewModel.cleanup()
    }

    init(project: TimeEntry.Project) {
        self.project = project
        super.init(nibName: "ProjectTimerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    @IBAction func dismissButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pauseTimerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .appleBlue : UIColor.groupTableViewBackground
//
        if sender.isSelected {
            viewModel.pauseTimer()
        } else {
            viewModel.resumeTimer()
        }
        
//        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
//            self.stopTimerButton.isHidden = sender.isSelected
//            self.stopTimerButton.alpha = sender.isSelected ? 0 : 1
//        }, completion: nil)
        
    }
    
    @IBAction func startTimerButtonTouched(_ sender: UIButton) {
        self.startTimerButton.isHidden = true
        self.stopTimerButton.isHidden = false
        self.pauseTimerButton.isHidden = false
        
        viewModel.startTimer()
    }
}
