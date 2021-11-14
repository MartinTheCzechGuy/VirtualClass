//
//  UserProfile.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

public struct UserProfile {
    let id: UUID
    let name: String
    let email: String
    let classes: Set<Class>
}

public struct Class {
    let id: UUID
    let name: String
}

extension Class: Hashable { }
