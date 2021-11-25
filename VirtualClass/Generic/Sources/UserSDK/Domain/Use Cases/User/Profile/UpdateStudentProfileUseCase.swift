//
//  UpdateStudentProfileUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine
import Foundation

public protocol UpdateStudentProfileUseCaseType {
    func update(_ profile: GenericStudent) -> AnyPublisher<Void, UserRepositoryError>
}

final class UpdateStudentProfileUseCase {
    
    private let userRepository: StudentRepositoryType
    
    init(userRepository: StudentRepositoryType) {
        self.userRepository = userRepository
    }
}

extension UpdateStudentProfileUseCase: UpdateStudentProfileUseCaseType {
    func update(_ profile : GenericStudent) -> AnyPublisher<Void, UserRepositoryError> {
        userRepository.update(profile)
    }
}
