//
//  LoggedHoursViewController.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftDate
import RxSwift
import RxCocoa
import Hero
import SDWebImage

enum FilterState {
    case none
    case start
    case end
}

class LoggedHoursViewController: UIViewController {
    
    fileprivate let viewModel = LoggedHoursViewModel()
    fileprivate var currentlyExpandedRow: Int? = nil
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var headerView: MyHoursHeader!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.addSubview(refreshControl)
            tableView.contentInset = .init(top: 160, left: 0, bottom: 5, right: 0)
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableViewAutomaticDimension
            let cellNib = UINib.init(nibName: "ProjectHoursTableViewCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "ProjectHoursCell")
            tableView.hero.modifiers = [.cascade]
        }
    }
    
    @IBOutlet weak var filterView: UIView! {
        didSet {
            filterView.layer.shadowColor = UIColor.darkGray.cgColor
            filterView.layer.shadowOpacity = 0.3
            filterView.superview?.bringSubview(toFront: filterView)
            filterView.layer.shadowOffset = .init(width: 0, height: 3)
        }
    }
    
    @IBOutlet weak var sortTypeButton: UIButton! {
        didSet {
            sortTypeButton.setTitleColor(.white, for: .selected)
            sortTypeButton.clipsToBounds = true
            sortTypeButton.setBackgroundColor(color: .black, forState: .selected)
        }
    }
    
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Redmine"
        // Do any additional setup after loading the view.
        hero.isEnabled = true
        configureFilterButton()
        configureTableView()
        viewModel.delegate = self
        viewModel.fetchMyTimeEntries()
        viewModel.fetchActivities()
        setProfileImageOnBarButton()
        
        self.filterView.isHidden = true
    }
    
    @IBAction func filterViewSwipeUp(_ sender: UISwipeGestureRecognizer) {
        toggleFilterView()
    }
    
    @IBAction func sortTypeButtonTouched(_ sender: Any) {
        sortTypeButton.isSelected = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        sortTypeButton.layer.cornerRadius = sortTypeButton.frame.size.height / 2
    }
}

extension LoggedHoursViewController {
   
    func setProfileImageOnBarButton() {
        
        UserService.shared.fetchCurrent()
            .map { $0.user }
            .subscribe(onNext: { (user) in
                
                guard let server = UserDefaults.standard.string(forKey: "server"),
                    let url = URL.init(string: server + "account/get_avatar/\(user.id)") else { return }
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.imageView?.contentMode = .scaleAspectFill
                button.sd_setImage(with: url, for: .normal, completed: nil)
                button.frame = CGRect.init(x: 0, y: 0, width: 32, height: 32)
                button.layer.cornerRadius = 16
                button.layer.masksToBounds = true
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 0.5
                let barButton = UIBarButtonItem(customView: button)
                self.navigationItem.leftBarButtonItem = barButton
                
                button.widthAnchor.constraint(equalToConstant: 32).isActive = true
                button.heightAnchor.constraint(equalToConstant: 32).isActive = true
                
            }, onError: { (error) in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func configureFilterButton() {
       
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        filterView.backgroundColor = .redmineBlue
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "filter-results-button").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(toggleFilterView))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func toggleFilterView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        
                        guard let strongSelf =  self else { return }
                        
                        strongSelf.filterView.isHidden = !strongSelf.filterView.isHidden
        }, completion: { [weak self] success in
            
        })
    }
    
    fileprivate func configureTableView() {
        
        refreshControl.tintColor = .redmineBlue
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        
        
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    @objc func refreshPulled() {
        refreshControl.beginRefreshing()
        viewModel.fetchMyTimeEntries()
    }
}

extension LoggedHoursViewController: LoggedHoursViewModelDelegate {
    
    func loggedHoursUpdated(timeEntries: [ProjectTimeEntry]) {
        DispatchQueue.main.async {
            self.currentlyExpandedRow = nil
            self.refreshControl.endRefreshing()
            self.tableView.hero.isEnabled = true
            self.tableView.hero.modifiers = [.cascade]
            self.tableView.reloadData()
            self.headerView.configure(hoursAmount: self.viewModel.totalHoursString)
            self.headerView.isHidden = false
        }
        
    }
    
}

extension LoggedHoursViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row != currentlyExpandedRow else { return }
        
        let selectedProject = viewModel.projectTimeEntries[indexPath.row]
        let vc = IssuesViewController.init(project: selectedProject.project)
        vc.hidesBottomBarWhenPushed = true
        show(vc, sender: nil)
    }
    
}

extension LoggedHoursViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projectTimeEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectHoursCell") as? ProjectHoursTableViewCell else {
            fatalError("failed to register cell")
        }
        
        let projectHours = viewModel.projectTimeEntries[indexPath.item]
        cell.configure(timeEntry: projectHours,
                       logVisible: currentlyExpandedRow == indexPath.row,
                       delegate: self)
        
        return cell
    }
}

extension LoggedHoursViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let inset = tableView.contentInset.top
        let fractionRemaining = -scrollView.contentOffset.y / inset
        print(fractionRemaining)
        let headerAlpha: CGFloat = fractionRemaining
        headerView?.alpha = headerAlpha
    }
}

extension LoggedHoursViewController: LoggedHoursCellDelegate {
    
    func startTimerTapped(in cell: ProjectHoursTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let project = viewModel
            .projectTimeEntries[indexPath.item]
            .project
        
        let vc = ProjectTimerViewController.init(project: project)
        cell.startTimerButton.hero.id = "startTimerButton"
        vc.hero.isEnabled = true
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.hero.isEnabled = true
        //navigationController?.hero.navigationAnimationType = .cover(direction: .left)
        
        //show(vc, sender: nil)
        
        present(vc, animated: true, completion: nil)
    }
    
   
    func itemsForPicker(in cell: ProjectHoursTableViewCell) -> [String] {
        return viewModel.activities.map { $0.name }
    }
    
    
    func cancelAddTapped(in cell: ProjectHoursTableViewCell) {
        
        currentlyExpandedRow = nil
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
       
    }
    
    func confirmAddTapped(in cell: ProjectHoursTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell),
            let amount = NumberFormatter().number(from: cell.amountTextField.text ?? "") else { return }
        
        let timeEntryProject = viewModel.projectTimeEntries[indexPath.item]
        let selectedActivityIndex = cell.activityPicker.selectedRow(inComponent: 0)
        
        viewModel.logHours(for: timeEntryProject.project,
                           selectedActivity: viewModel.activities[selectedActivityIndex],
                           duration: amount.floatValue,
                           comments: cell.activityDescriptionTextField.text)
    }

    func addHoursTapped(in cell: ProjectHoursTableViewCell) {
        
        let oldIndex = currentlyExpandedRow
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var indexesToUpdate: [IndexPath] = [indexPath]
        if let oldIndex = oldIndex {
            indexesToUpdate.append(IndexPath.init(row: oldIndex, section: 0))
        }
        
        currentlyExpandedRow = indexPath.row
        tableView.beginUpdates()
        tableView.reloadRows(at: indexesToUpdate, with: .automatic)
        tableView.endUpdates()
    }
}

