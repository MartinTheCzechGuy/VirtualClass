//
//  HandleLoginUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class HandleLoginUseCaseStub: HandleLoginUseCaseType {
    
    private let loginResult: LoginValidationResult
    
    init(loginResult: LoginValidationResult) {
        self.loginResult = loginResult
    }
    
    func login(email: String, password: String) -> AnyPublisher<LoginValidationResult, Never> {
        Just(loginResult).eraseToAnyPublisher()
    }
}
