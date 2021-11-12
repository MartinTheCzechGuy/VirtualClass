//
//  File.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

struct DomainClassModel {
    let id: UUID
    let name: String
}

extension DomainClassModel: Identifiable {}

extension DomainClassModel: Equatable {}

