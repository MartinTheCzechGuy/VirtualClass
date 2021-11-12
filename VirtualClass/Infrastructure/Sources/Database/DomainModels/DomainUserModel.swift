//
//  DomainUserModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public struct DomainUserModel {
    public let id: UUID
    let name: String
}

extension DomainUserModel: Identifiable {}

extension DomainUserModel: Equatable {}
