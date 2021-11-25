//
//  ClassRoom.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Foundation

public struct ClassRoom {
    public let id: UUID
    public let name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension ClassRoom: Equatable {}

extension ClassRoom: Hashable {}
