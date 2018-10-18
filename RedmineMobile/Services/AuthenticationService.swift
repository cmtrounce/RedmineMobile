//
//  AuthenticationService.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 16/04/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticationService {
    
    private let userDefaults: UserDefaults = .standard
    
    func logIn(server: String,
               username: String,
               password: String,
               success: @escaping ((User) -> Void),
               failure: @escaping ((Error) -> Void)) {
        
        Alamofire.request(server + "/users/current.json")
            .validate(statusCode: 200..<300)
            .authenticate(user: username, password: password)
            .responseJSON { response in
                
                if let error = response.error {
                    failure(error)
                    return
                }
                
                if let json = response.data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try decoder.decode(UserResponse.self, from: json)
                        
                        self.userDefaults.set(username, forKey: "username")
                        self.userDefaults.set(password, forKey: "password")
                        var validServer = server
                        if validServer.last != "/" {
                            validServer.append("/")
                        }
                        self.userDefaults.set(validServer, forKey: "server")
                        success(response.user)
                    } catch {
                        failure(error)
                    }
                }
        }
    }
    
    func credentials() -> String? {
        guard let user = userDefaults.string(forKey: "username"),
            let password = userDefaults.string(forKey: "password"),
            let data = "\(user):\(password)".data(using: .utf8) else {
                
            return nil
        }
      
        let base64Credentials = data.base64EncodedString()
        return "Basic " + base64Credentials
    }
}
