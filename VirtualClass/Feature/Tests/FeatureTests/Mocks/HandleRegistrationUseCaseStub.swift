//
//  HandleRegistrationUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class HandleRegistrationUseCaseStub: HandleRegistrationUseCaseType {
    
    private let registrationResult: RegistrationValidationResult
    
    init(registrationResult: RegistrationValidationResult) {
        self.registrationResult = registrationResult
    }
    
    func register(form: RegistrationFormData) -> AnyPublisher<RegistrationValidationResult, Never> {
        Just(registrationResult).eraseToAnyPublisher()
    }
}
