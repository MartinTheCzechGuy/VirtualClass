//
//  GetUserProfileUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Foundation

public protocol GetUserProfileUseCaseType {
    var userProfile: UserProfile? { get }
}

final class GetUserProfileUseCase {
    
    private let getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseType
    private let userProfileRepository: UserProfileRepositoryType
    
    init(getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseType, userProfileRepository: UserProfileRepositoryType) {
        self.userProfileRepository = userProfileRepository
        self.getLoggedInUserEmailUseCase = getLoggedInUserEmailUseCase
    }
}

extension GetUserProfileUseCase: GetUserProfileUseCaseType {
    var userProfile: UserProfile? {
        guard let email = getLoggedInUserEmailUseCase.email else {
            return nil
        }
        
        guard let profile = userProfileRepository.load(userWithEmail: email).success else {
            return nil
        }
     
        return profile
    }
}
