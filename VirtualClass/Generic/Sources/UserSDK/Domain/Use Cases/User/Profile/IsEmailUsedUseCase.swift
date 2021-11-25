//
//  IsEmailUsedUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine

protocol IsEmailUsedUseCasetype {
    func isAlreadyUsed(_ email: String) -> AnyPublisher<Bool, UserRepositoryError>
}

final class IsEmailUsedUseCase {
    private let userRepository: StudentRepositoryType
    
    init(userRepository: StudentRepositoryType) {
        self.userRepository = userRepository
    }
}

extension IsEmailUsedUseCase: IsEmailUsedUseCasetype {
    func isAlreadyUsed(_ email: String) -> AnyPublisher<Bool, UserRepositoryError> {
        userRepository.loadAll()
            .mapElement(\.email)
            .map { $0.contains(email) }
            .eraseToAnyPublisher()
    }
}
