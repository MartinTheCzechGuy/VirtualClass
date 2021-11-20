//
//  IsEmailUsedUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

protocol IsEmailUsedUseCasetype {
    func isAlreadyUsed(_ email: String) -> Result<Bool, UserRepositoryError>
}

final class IsEmailUsedUseCase {
    private let userRepository: StudentRepositoryType
    
    init(userRepository: StudentRepositoryType) {
        self.userRepository = userRepository
    }
}

extension IsEmailUsedUseCase: IsEmailUsedUseCasetype {
    func isAlreadyUsed(_ email: String) -> Result<Bool, UserRepositoryError> {
        userRepository.takenEmails()
            .map { $0.contains(email) }
    }
}
