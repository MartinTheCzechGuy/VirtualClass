//
//  CheckEmailTakenUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine

enum CheckEmailTakenUseCaseError: Error {
    case userProfileError(error: Error)
}

protocol CheckEmailTakenUseCaseType {
    func isTaken(email: String) -> AnyPublisher<Bool, CheckEmailTakenUseCaseError>
}

final class CheckEmailTakenUseCase {
    
    private let userRepository: StudentRepositoryType
    
    init(userRepository: StudentRepositoryType) {
        self.userRepository = userRepository
    }
}

extension CheckEmailTakenUseCase: CheckEmailTakenUseCaseType {
    func isTaken(email: String) -> AnyPublisher<Bool, CheckEmailTakenUseCaseError> {
        userRepository.loadAll()
            .mapElement(\.email)
            .mapError(CheckEmailTakenUseCaseError.userProfileError)
            .map { takenEmails in
                takenEmails.contains(email)
            }
            .eraseToAnyPublisher()
    }
}
