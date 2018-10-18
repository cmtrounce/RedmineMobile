//
//  TimekeepingService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TimekeepingService {
    
    static let shared = TimekeepingService()
    
    let elaspedTime: BehaviorRelay<Int> = BehaviorRelay<Int>.init(value: 0)
    
    private var disposable: Disposable?
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    func start() -> BehaviorRelay<Int> {
        disposable = Observable<Int>
            .interval(1.0, scheduler: MainScheduler.instance)
            .map { _ in self.elaspedTime.value + 1  }
            .bind(to: elaspedTime)
        disposable?.disposed(by: disposeBag)
        return elaspedTime
    }
    
    func pause() {
        disposable?.dispose()
        disposable = nil
    }
    
    func resume() -> BehaviorRelay<Int> {
        disposable = Observable<Int>
            .interval(1.0, scheduler: MainScheduler.instance)
            .map { _ in self.elaspedTime.value + 1  }
            .bind(to: elaspedTime)
        disposable?.disposed(by: disposeBag)
        return elaspedTime
    }
}
