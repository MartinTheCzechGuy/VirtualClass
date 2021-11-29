//
//  CreateStudentProfileUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Combine
import Foundation

protocol CreateStudentProfileUseCaseType {
    func register(name: String, email: String) -> AnyPublisher<Void, StudentRepositoryError>
}

final class CreateStudentProfileUseCase {
    private let userProfileRepository: StudentRepositoryType
    
    init(userProfileRepository: StudentRepositoryType) {
        self.userProfileRepository = userProfileRepository
    }
}

extension CreateStudentProfileUseCase: CreateStudentProfileUseCaseType {
    func register(name: String, email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        userProfileRepository.create(name: name, email: email)
    }
}
