//
//  KeychainManager.swift
//  flamma
//
//  Created by Maiko Hermans on 14/11/2017.
//  Copyright © 2017 DTT. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

/// 🔐 Class that manages the Keychain.
class KeychainManager {
    
    
    static let threadSafeQueue = DispatchQueue.init(label: "threadSafeKeychainQueue")
    
    /// 🔑 The possible keys that are used for the keychain.
    struct Keys {
        static let usernameKey            =   "username"
        static let passwordKey            =   "password"
        static let baseDomainKey          =   "baseDomain"
    }
    
    /// 🕸 Structure that contains keys regarding the API that are stored in the keychain.
    struct ApiChain {
        static var username: String? {
            return KeychainManager.retrieveFromChain(key: Keys.usernameKey)
        }
        static var password: String? {
            return KeychainManager.retrieveFromChain(key: Keys.passwordKey)
        }
        static var baseDomain: String? {
            return KeychainManager.retrieveFromChain(key: Keys.baseDomainKey)
        }
    }
    
    /// Create a new value in the keychain.
    ///
    /// - Parameters:
    ///   - value: the value that needs to be stored in the keychain.
    ///   - key: the key.
    /// - Returns: whether the key was succesfully added to the keychain or not.
    static func storeInChain(value: String, key: String) -> Bool {
        
        return threadSafeQueue.sync {
            return KeychainWrapper.standard.set(value, forKey: key)
        }
       
    }
    
    fileprivate static func retrieveFromChain(key: String) -> String? {
        
        return threadSafeQueue.sync {
             return KeychainWrapper.standard.string(forKey: key)
        }
        
    }
    
    static func remove(forKey key: String) -> Bool {
        
         return threadSafeQueue.sync {
            return KeychainWrapper.standard.removeObject(forKey: key)
        }
    }
}
