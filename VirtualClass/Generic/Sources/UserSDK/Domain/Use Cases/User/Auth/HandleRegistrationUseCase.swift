//
//  HandleUserRegistrationUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine
import CombineExt
import Common
import Foundation

public protocol HandleUserRegistrationUseCaseType {
    func register(form: RegistrationFormData) -> AnyPublisher<RegistrationValidationResult, Never>
}

final class HandleUserRegistrationUseCase {
    
    private let checkValidEmailUseCase: CheckValidEmailUseCaseType
    private let checkValidPasswordUseCase: CheckValidPasswordUseCaseType
    private let isEmailUsedUseCase: IsEmailUsedUseCaseType
    private let userAuthRepository: UserAuthRepositoryType
    private let createUserProfileUseCase: CreateStudentProfileUseCaseType
    
    init(
        checkValidEmailUseCase: CheckValidEmailUseCaseType,
        checkValidPasswordUseCase: CheckValidPasswordUseCaseType,
        isEmailUsedUseCase: IsEmailUsedUseCaseType,
        userAuthRepository: UserAuthRepositoryType,
        createUserProfileUseCase: CreateStudentProfileUseCaseType
    ) {
        self.checkValidEmailUseCase = checkValidEmailUseCase
        self.checkValidPasswordUseCase = checkValidPasswordUseCase
        self.isEmailUsedUseCase = isEmailUsedUseCase
        self.userAuthRepository = userAuthRepository
        self.createUserProfileUseCase = createUserProfileUseCase
    }
}

extension HandleUserRegistrationUseCase: HandleUserRegistrationUseCaseType {
    
    func register(form: RegistrationFormData) -> AnyPublisher<RegistrationValidationResult, Never> {
        guard form.password1 == form.password2 else {
            return Just(.passwordsDontMatch).eraseToAnyPublisher()
        }
        
        guard checkValidPasswordUseCase.isValid(password: form.password1) else {
            return Just(.invalidPassword).eraseToAnyPublisher()
        }
        
        guard checkValidEmailUseCase.isValid(email: form.email) else {
            return Just(.invalidEmail).eraseToAnyPublisher()
        }
        
        let isEmailUsed = isEmailUsedUseCase.isAlreadyUsed(form.email)
            .mapToResult()
        
        // TOTO bude zahrnuty v result mergi
        let emailIsUsed = isEmailUsed
            .compactMap(\.success)
            .filter { $0 }
            .map { _ in RegistrationValidationResult.emailAlreadyUsed }
        
        let errorLoadingUsedEmail = isEmailUsed
            .compactMap { $0.failure }
            .map { _ in RegistrationValidationResult.errorStoringCredentials }
        
        let storeCredentialsResult = isEmailUsed
            .compactMap(\.success)
            .filter { !$0 }
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, UserAuthRepositoryError>, Never> in
                guard let self = self else {
                    return Just(.failure(UserAuthRepositoryError.storageError(nil))).eraseToAnyPublisher()
                }
                
                return self.userAuthRepository.store(credentials: .init(email: form.email, password: form.password1)).publisher
                    .mapToResult()
                    .eraseToAnyPublisher()
            }

        let errorStoringCredentials = storeCredentialsResult
            .compactMap(\.failure)
            .map { _ in RegistrationValidationResult.errorStoringCredentials }
        
        let registerUser = storeCredentialsResult
            .compactMap(\.success)
            .flatMap { [weak self] _ -> AnyPublisher<RegistrationValidationResult, Never> in
                guard let self = self else {
                    return Just(.errorStoringCredentials).eraseToAnyPublisher()
                }
                
                return self.createUserProfileUseCase.register(name: form.name, email: form.email)
                    .map { _ in return .validData }
                    .replaceError(with: RegistrationValidationResult.errorStoringCredentials)
                    .eraseToAnyPublisher()
            }
        
        return registerUser
            .merge(with: errorStoringCredentials)
            .merge(with: errorLoadingUsedEmail)
            .merge(with: errorLoadingUsedEmail)
            .merge(with: emailIsUsed)
            .first()
            .eraseToAnyPublisher()
    }
}
