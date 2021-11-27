//
//  GenericUserProfile.swift
//  
//
//  Created by Martin on 27.11.2021.
//

import Foundation

public struct GenericUserProfile {
    public let id: UUID
    public let name: String
    public let email: String

    public init(
        id: UUID,
        name: String,
        email: String
    ) {
        self.id = id
        self.name = name
        self.email = email
    }
}

extension GenericUserProfile: Hashable { }
