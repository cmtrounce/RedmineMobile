//
//  ApiService.swift
//  kvk
//
//  Created by Callum Trounce on 13/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import RxAlamofire
import RxCocoa
import RxSwift
import Alamofire

class Networking<API: ApiProtocol> {
    
    fileprivate let userDefaults: UserDefaults = .standard
    private let manager = SessionManager.default.rx
    private let authService = AuthenticationService()
    private let disposeBag = DisposeBag()
    
    /// Make a request to the API
    ///
    /// - Returns: A promise of the specified Codable type, can be an array or single object
    func request(to target: API) -> Observable<Data> {
        let request = buildRequest(to: target)
        return request
            .asObservable()
    }
    
    func buildRequest(to target: API) -> Observable<Data> {

        let requestPath = base + target.path
        var headers = target.headers
        
        if target.requiresAuthentication {
            if let credentials = authService.credentials() {
                headers["Authorization"] = credentials
            } else {
                return Observable.error(Errors.invalidCredentials)
            }
        }
        
        do {
            let params = try target.parameters()
            let request = manager.data(target.method,
                                 requestPath,
                                 parameters: params,
                                 encoding: target.encoding,
                                 headers: headers)
            return request
            
        } catch {
            return Observable.error(error)
        }
    }
}



// MARK: - ApiProtocol Extension in order to select correct properties when making call
extension Networking: Target {
    
    var base: String {
        return userDefaults.string(forKey: "server") ?? ""
    }
}
