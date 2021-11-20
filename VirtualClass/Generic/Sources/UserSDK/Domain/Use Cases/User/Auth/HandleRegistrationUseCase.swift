//
//  HandleUserRegistrationUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

import Common
import Foundation

public protocol HandleUserRegistrationUseCaseType {
    func register(form: RegistrationFormData) -> RegistrationValidationResult
}

final class HandleUserRegistrationUseCase {
    
    private let checkValidEmailUseCase: CheckValidEmailUseCaseType
    private let checkValidPasswordUseCase: CheckValidPasswordUseCaseType
    private let checkEmailTakenUseCase: CheckEmailTakenUseCaseType
    private let isEmailUsedUseCase: IsEmailUsedUseCasetype
    private let userAuthRepository: UserAuthRepositoryType
    private let createUserProfileUseCase: CreateStudentProfileUseCaseType
    
    init(
        checkValidEmailUseCase: CheckValidEmailUseCaseType,
        checkValidPasswordUseCase: CheckValidPasswordUseCaseType,
        checkEmailTakenUseCase: CheckEmailTakenUseCaseType,
        isEmailUsedUseCase: IsEmailUsedUseCasetype,
        userAuthRepository: UserAuthRepositoryType,
        createUserProfileUseCase: CreateStudentProfileUseCaseType
    ) {
        self.checkValidEmailUseCase = checkValidEmailUseCase
        self.checkValidPasswordUseCase = checkValidPasswordUseCase
        self.checkEmailTakenUseCase = checkEmailTakenUseCase
        self.isEmailUsedUseCase = isEmailUsedUseCase
        self.userAuthRepository = userAuthRepository
        self.createUserProfileUseCase = createUserProfileUseCase
    }
}

extension HandleUserRegistrationUseCase: HandleUserRegistrationUseCaseType {
    
    func register(form: RegistrationFormData) -> RegistrationValidationResult {
        guard form.password1 == form.password2 else {
            return .passwordsDontMatch
        }
        
        guard checkValidPasswordUseCase.isValid(password: form.password1) else {
            return .invalidPassword
        }
                
        guard checkValidEmailUseCase.isValid(email: form.email) else {
            return .invalidEmail
        }
        
        guard let isEmailUsed = isEmailUsedUseCase.isAlreadyUsed(form.email).success else {
            return .errorStoringCredentials
        }
                
        guard !isEmailUsed else {
            return .emailAlreadyUsed
        }
                
        let storeCredentialsResult = userAuthRepository.store(credentials: .init(email: form.email, password: form.password1))
                
        guard storeCredentialsResult.success != nil else {
            return .errorStoringCredentials
        }
                
        let createProfileResult = createUserProfileUseCase.register(name: form.name, email: form.email)
                
        return createProfileResult.success != nil ? .validData : .errorStoringCredentials
    }
}
