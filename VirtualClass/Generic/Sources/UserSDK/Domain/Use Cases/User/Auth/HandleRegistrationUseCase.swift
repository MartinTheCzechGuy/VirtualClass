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
    
    init(
        checkValidEmailUseCase: CheckValidEmailUseCaseType,
        checkValidPasswordUseCase: CheckValidPasswordUseCaseType,
        checkEmailTakenUseCase: CheckEmailTakenUseCaseType,
        isEmailUsedUseCase: IsEmailUsedUseCasetype,
        userAuthRepository: UserAuthRepositoryType
    ) {
        self.checkValidEmailUseCase = checkValidEmailUseCase
        self.checkValidPasswordUseCase = checkValidPasswordUseCase
        self.checkEmailTakenUseCase = checkEmailTakenUseCase
        self.isEmailUsedUseCase = isEmailUsedUseCase
        self.userAuthRepository = userAuthRepository
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
        
        print("password is valid")
        
        guard checkValidEmailUseCase.isValid(email: form.email) else {
            return .invalidEmail
        }
        
        print("email is valid")

        // 1) koukám do DB, jestli neexistuje email s přiřazeným stejným účtem
        guard let isEmailUsed = isEmailUsedUseCase.isAlreadyUsed(form.email).success else {
            return .errorStoringCredentials
        }
        
        print("Found all used emails")
        
        #warning("TODO - put me back into action.")
//        guard !isEmailUsed else {
//            return .emailAlreadyUsed
//        }
        
        print("email is not taken")
        
        let storeCredentialsResult = userAuthRepository.store(credentials: .init(email: form.email, password: form.password1))
        
        print("storing result \(storeCredentialsResult)")
        
        return storeCredentialsResult.success != nil ? .validData : .errorStoringCredentials
    }
}
