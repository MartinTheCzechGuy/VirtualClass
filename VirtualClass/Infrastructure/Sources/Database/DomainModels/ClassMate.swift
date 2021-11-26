//
//  ClassMate.swift
//  
//
//  Created by Martin on 23.11.2021.
//

import Foundation

public struct ClassMate {
    public let name: String
    public let email: String
    
    public init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

extension ClassMate: Hashable {}
