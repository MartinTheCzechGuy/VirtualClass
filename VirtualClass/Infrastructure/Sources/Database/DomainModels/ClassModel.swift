//
//  File.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public struct DomainClassModel {
    public let id: UUID
    public let name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension DomainClassModel: Identifiable {}

extension DomainClassModel: Equatable {}

extension DomainClassModel: Hashable {}
