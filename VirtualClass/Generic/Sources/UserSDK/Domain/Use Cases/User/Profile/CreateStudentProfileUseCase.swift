//
//  CreateStudentProfileUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

protocol CreateStudentProfileUseCaseType {
    func register(name: String, email: String) -> Result<Void, UserRepositoryError>
}

final class CreateStudentProfileUseCase {
    private let userProfileRepository: UserProfileRepositoryType
    
    init(userProfileRepository: UserProfileRepositoryType) {
        self.userProfileRepository = userProfileRepository
    }
}

extension CreateStudentProfileUseCase: CreateStudentProfileUseCaseType {
    func register(name: String, email: String) -> Result<Void, UserRepositoryError> {
        userProfileRepository.create(name: name, email: email)
    }
}
