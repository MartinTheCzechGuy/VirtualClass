//
//  GetStudentProfileUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Foundation

public protocol GetStudentProfileUseCaseType {
    var userProfile: GenericStudent? { get }
}

final class GetStudentProfileUseCase {
    
    private let getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseType
    private let userProfileRepository: StudentRepositoryType
    
    init(getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseType, userProfileRepository: StudentRepositoryType) {
        self.userProfileRepository = userProfileRepository
        self.getLoggedInUserEmailUseCase = getLoggedInUserEmailUseCase
    }
}

extension GetStudentProfileUseCase: GetStudentProfileUseCaseType {
    var userProfile: GenericStudent? {
        guard let email = getLoggedInUserEmailUseCase.email else {
            return nil
        }
        
        guard let profile = userProfileRepository.load(userWithEmail: email).success else {
            return nil
        }
     
        return profile
    }
}
