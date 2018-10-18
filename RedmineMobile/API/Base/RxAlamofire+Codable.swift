//
//  RxAlamofire+Codable.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 02/03/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import RxSwift
import Alamofire

extension Observable where E == Data {
    
    public func mapCodable<T: Codable>() -> Observable<T> {
        return flatMap { data -> Observable<T> in
            
            let jsonString = try JSONSerialization.jsonObject(with: data, options: [])
            print(jsonString)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let object = try decoder.decode(T.self, from: data)
            return Observable<T>.just(object)
        }
    }
}
