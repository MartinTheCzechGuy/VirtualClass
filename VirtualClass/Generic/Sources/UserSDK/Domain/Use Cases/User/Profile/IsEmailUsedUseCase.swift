//
//  IsEmailUsedUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine

protocol IsEmailUsedUseCaseType {
    func isAlreadyUsed(_ email: String) -> AnyPublisher<Bool, StudentRepositoryError>
}

final class IsEmailUsedUseCase {
    private let userRepository: StudentRepositoryType
    
    init(userRepository: StudentRepositoryType) {
        self.userRepository = userRepository
    }
}

extension IsEmailUsedUseCase: IsEmailUsedUseCaseType {
    func isAlreadyUsed(_ email: String) -> AnyPublisher<Bool, StudentRepositoryError> {
        userRepository.loadAll()
            .mapElement(\.email)
            .map { $0.contains(email) }
            .eraseToAnyPublisher()
    }
}
