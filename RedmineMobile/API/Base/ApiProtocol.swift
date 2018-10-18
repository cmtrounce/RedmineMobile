//
//  ApiProtocol.swift
//  kvk
//
//  Created by Callum Trounce on 13/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import Foundation
import Alamofire

typealias ApiController = Target & ApiProtocol

protocol Target {
    var base: String { get }
}

protocol ApiProtocol {
    var path: String { get }
    var requiresAuthentication: Bool  { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
    var method: HTTPMethod { get }
    func parameters() throws -> Parameters?
}
