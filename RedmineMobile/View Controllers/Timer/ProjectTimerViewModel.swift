//
//  ProjectTimerViewModel.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 15/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProjectTimerViewModel {
    
    private let timekeepingService = TimekeepingService()
    
    private let disposeBag = DisposeBag()
    
    private var disposable: Disposable?
    
    let formattedElapsedTime: BehaviorRelay<String> = BehaviorRelay<String>.init(value: "00:00:00")
    
    func startTimer() {
        disposable = timekeepingService.start()
            .map { [weak self] secondsPassed in
                guard let `self` = self else { return "" }
                return self.formattedTimeInt(interval: secondsPassed)
            }
            .bind(to: formattedElapsedTime)
        disposable?.disposed(by: disposeBag)
    }
    
    func pauseTimer() {
        disposable?.dispose()
        disposable = nil
        timekeepingService.pause()
    }
    
    func resumeTimer() {
        disposable = timekeepingService.resume()
            .map { self.formattedTimeInt(interval: $0) }
            .bind(to: formattedElapsedTime)
        disposable?.disposed(by: disposeBag)
    }
    
    deinit {
        disposable?.dispose()
        disposable = nil
    }
    
    private func formattedTimeInt(interval: Int) -> String {
        print(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
    
    func cleanup() {
        disposable?.dispose()
        disposable = nil
    }
}
