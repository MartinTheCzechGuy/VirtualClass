//
//  Converters+User.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import CoreDatabase

extension DatabaseModelConverter where DatabaseModel == UserEntity, DomainModel == DomainUserModel {
    static let live: Self = . init { userEntity, domainUser in
        userEntity.id = domainUser.id
        userEntity.name = domainUser.name
        userEntity.email = domainUser.email
    }
}

extension DomainModelConverter where DatabaseModel == UserEntity, DomainModel == DomainUserModel {
    static let live: Self = .init { userEntity in
        DomainUserModel(id: userEntity.id, name: userEntity.name, email: userEntity.email, classes: [])
    }
}
