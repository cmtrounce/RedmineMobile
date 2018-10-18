//
//  IssuesViewModel.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


protocol IssuesViewModelProtocol: ViewModelProtocol {
    var sectionModels: BehaviorRelay<[SectionModel<String, Issue>]> { get }
    var project: TimeEntry.Project? { get set }
}

class IssuesViewModel: IssuesViewModelProtocol {
    
    var sectionModels: BehaviorRelay<[SectionModel<String, Issue>]> = BehaviorRelay<[SectionModel<String, Issue>]>.init(value: [])
    
    private let resultIssues = BehaviorRelay<[Issue]>.init(value: [])
    var project: TimeEntry.Project?
    private var priorityOrder: [Issue.Reference] = []
    private let disposeBag: DisposeBag = DisposeBag()
    private let issueService = IssueService()
    
    private func configurePrivateBindings() {
        resultIssues.subscribe(onNext: { (issues) in
            let allPrios = issues.map { $0.priority }
            let set = NSOrderedSet.init(array: allPrios)
            self.priorityOrder = set.array as! [Issue.Reference]
            let sections = self.priorityOrder.map { priority in
                SectionModel.init(model: priority.name,
                                  items: issues.filter { $0.priority.id == priority.id } )
            }
            self.sectionModels.accept(sections)
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    fileprivate func fetchIssues() {
        guard let project = project else { return }
        issueService.issues(for: project)
            .map { $0.issues }
            .bind(to: resultIssues)
            .disposed(by: disposeBag)
    }
    
    func viewDidFinishLoading() {
        configurePrivateBindings()
        fetchIssues()
    }
}
