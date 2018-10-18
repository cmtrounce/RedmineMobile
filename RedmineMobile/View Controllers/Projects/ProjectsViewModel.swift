//
//  ProjectsViewModel.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 26/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProjectsViewModelProtocol: class {
    func viewDidFinishLoading()
}

class ProjectsViewModel: ProjectsViewModelProtocol {
    
    fileprivate let service = ProjectsService()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    let parentProjects: BehaviorRelay<[Project]> = BehaviorRelay<[Project]>.init(value: [])
   
    func viewDidFinishLoading() {
        fetchParentProjects()
    }
}

extension ProjectsViewModel {
    
    func fetchParentProjects() {
        service.fetchAll()
            .map { $0.projects.filter { $0.parent == nil } }
            .bind(to: parentProjects)
            .disposed(by: disposeBag)
    }
}
