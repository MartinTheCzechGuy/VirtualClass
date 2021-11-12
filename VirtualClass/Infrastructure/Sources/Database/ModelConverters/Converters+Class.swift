//
//  Converters+Class.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import CoreDatabase

extension DatabaseModelConverter where DatabaseModel == ClassEntity, DomainModel == DomainClassModel {
    static let live: Self = . init { classEntity, domainClass in
        classEntity.id = domainClass.id
        classEntity.name = domainClass.name
    }
}

extension DomainModelConverter where DatabaseModel == ClassEntity, DomainModel == DomainClassModel {
    static let live: Self = .init { classEntity in
        DomainClassModel(id: classEntity.id!, name: classEntity.name!)
    }
}
