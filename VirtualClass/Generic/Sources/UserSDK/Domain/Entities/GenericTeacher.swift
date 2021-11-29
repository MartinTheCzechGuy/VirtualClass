//
//  GenericTeacher.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public struct GenericTeacher {
    public let id: UUID
    public let name: String

    public init(
        id: UUID,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

extension GenericTeacher: Hashable { }
