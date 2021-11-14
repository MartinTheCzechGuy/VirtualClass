//
//  UpdateUserProfileUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine
import Foundation

public protocol UpdateUserProfileUseCaseType {
    func update(userProfile: UserProfile) -> Result<Void, UserRepositoryError>
}

final class UpdateUserProfileUseCase {
    
    private let userRepository: UserProfileRepositoryType
    
    init(userRepository: UserProfileRepositoryType) {
        self.userRepository = userRepository
    }
}

extension UpdateUserProfileUseCase: UpdateUserProfileUseCaseType {
    func update(userProfile: UserProfile) -> Result<Void, UserRepositoryError> {
        userRepository.update(userProfile)
    }
}
