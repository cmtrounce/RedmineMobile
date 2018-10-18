//
//  IssuesViewController.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class IssuesViewController: UIViewController {

    private var viewModel: IssuesViewModelProtocol = IssuesViewModel()
    private let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Issue>>(
        configureCell: { (_, tv, indexPath, element) in
            
            let cell = tv.dequeueReusableCell(withIdentifier: IssueTableViewCell.identifier) as! IssueTableViewCell
            cell.configure(name: element.subject,
                           description: element.description,
                           priority: element.priority.name,
                           priorityColor: UIColor.redmineBlue)
            return cell
    },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
    }
    )
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib.init(nibName: "IssueTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: IssueTableViewCell.identifier)
            configureBindings()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.project?.name
        viewModel.viewDidFinishLoading()
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "internet"), style: .plain, target: self, action: #selector(webButtonTouched))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    init(project: TimeEntry.Project) {
        super.init(nibName: "IssuesViewController", bundle: nil)
        viewModel.project = project
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension IssuesViewController {
   
    @objc func webButtonTouched() {
        guard let project = viewModel.project else { return }
        let urlString = "https://redmine.d-tt.nl/" + "projects/" + "\(project.id)" + "/issues"
        guard let url = URL.init(string: urlString) else { return }
        
        let webVC = WebViewController.init(requestURL: url)
        webVC.hidesBottomBarWhenPushed = true
        show(webVC, sender: nil)
    }
    
    func configureBindings() {
        viewModel.sectionModels
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Issue.self))
            .bind { [unowned self] indexPath, selectedIssue in
                
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                guard let url = URL.init(string: "https://redmine.d-tt.nl/" + "issues/\(selectedIssue.id)") else { return }
                let webVC = WebViewController.init(requestURL: url)
                webVC.hidesBottomBarWhenPushed = true
                self.show(webVC, sender: nil)
            }
            .disposed(by: disposeBag)
    }
    
}
