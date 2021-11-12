//
//  UserProfileRepository.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Combine
import Database

final class UserProfileRepository {
    private let database: DatabaseInteracting
    
    init(database: DatabaseInteracting) {
        self.database = database
    }
}

extension UserProfileRepository: UserProfileRepositoryType {
    
}
