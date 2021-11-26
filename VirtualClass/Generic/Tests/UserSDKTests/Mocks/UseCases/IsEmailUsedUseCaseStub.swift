//
//  IsEmailUsedUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
@testable import UserSDK

final class IsEmailUsedUseCaseStub: IsEmailUsedUseCaseType {
    private let result: AnyPublisher<Bool, UserRepositoryError>
    
    init(result: AnyPublisher<Bool, UserRepositoryError>) {
        self.result = result
    }
    
    func isAlreadyUsed(_ email: String) -> AnyPublisher<Bool, UserRepositoryError> {
        result
    }
}
