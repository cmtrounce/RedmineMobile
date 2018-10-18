//
//  Encodable+JSON.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 31/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation

extension Encodable  {
    
    func toJson() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(self)
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            let userInfo = [NSLocalizedDescriptionKey : "Unable to convert request parameters to a json object"]
            throw NSError.init(domain: "APIService",
                               code: 400,
                               userInfo: userInfo)
        }
        
        return json
    }
}
