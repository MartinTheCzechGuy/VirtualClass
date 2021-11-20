//
//  CheckEmailTakenUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

enum CheckEmailTakenUseCaseError: Error {
    case userProfileError(error: Error)
}

protocol CheckEmailTakenUseCaseType {
    func isTaken(email: String) -> Result<Bool, CheckEmailTakenUseCaseError>
}

final class CheckEmailTakenUseCase {
    
    private let userRepository: StudentRepositoryType
    
    init(userRepository: StudentRepositoryType) {
        self.userRepository = userRepository
    }
}

extension CheckEmailTakenUseCase: CheckEmailTakenUseCaseType {
    func isTaken(email: String) -> Result<Bool, CheckEmailTakenUseCaseError> {
        userRepository.takenEmails()
            .mapError(CheckEmailTakenUseCaseError.userProfileError)
            .map { takenEmails in
                takenEmails.contains(email)
            }
    }
}
