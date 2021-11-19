//
//  UserProfile.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

public struct UserProfile {
    public let id: UUID
    public let name: String
    public let email: String
    public let classes: Set<Class>
    
    public init(
        id: UUID,
        name: String,
        email: String,
        classes: Set<Class>
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.classes = classes
    }
}

public struct Class {
    public let ident: String
    public let name: String
}

extension Class: Identifiable {
    public var id: String {
        ident
    }
}

extension Class: Hashable { }
