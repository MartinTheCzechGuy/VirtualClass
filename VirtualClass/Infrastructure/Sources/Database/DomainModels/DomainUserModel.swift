//
//  DomainUserModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public struct DomainUserModel {
    public let id: UUID
    public let name: String
    public let email: String
    public let classes: Set<DomainClassModel>
    
    public init(
        id: UUID,
        name: String,
        email: String,
        classes: Set<DomainClassModel>
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.classes = classes
    }
}

extension DomainUserModel: Identifiable {}

extension DomainUserModel: Equatable {}

extension DomainUserModel: Hashable {}
