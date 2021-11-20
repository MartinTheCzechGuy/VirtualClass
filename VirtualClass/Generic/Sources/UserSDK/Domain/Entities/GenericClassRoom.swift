//
//  GenericClassRoom.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public struct GenericClassRoom {
    public let id: UUID
    public let name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension GenericClassRoom: Hashable {}
