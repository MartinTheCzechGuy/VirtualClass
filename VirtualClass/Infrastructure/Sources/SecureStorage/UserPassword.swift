//
//  UserPassword.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public struct UserPassword {
    let service: String
    let accessGroup: String?
    
    public init(service: String, accessGroup: String?) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

extension UserPassword: SecureStorageQueryable {
    public var query: [String : Any] {
        var query: [String : Any] = [:]
        // tímhle říkáš co to je za data, keychain je podle toho šifruje
        query[String(kSecClass)] = kSecClassGenericPassword
        
        query[String(kSecAttrService)] = service
        
        // Access group dovoluje sharovat itemy mezi několika aplikacemi se stejnou groupu
        // používá se třeba pro hodinky
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
        #endif
        
        return query
    }
}
