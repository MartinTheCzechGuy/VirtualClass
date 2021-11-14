//
//  HandleUserLoginUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Common
import Foundation

public protocol HandleUserLoginUseCaseType {
    func login(email: String, password: String) -> LoginValidationResult
}

final class HandleUserLoginUseCase {
    
    private let checkValidEmailUseCase: CheckValidEmailUseCaseType
    private let checkValidPasswordUseCase: CheckValidPasswordUseCaseType
    private let userAuthRepository: UserAuthRepositoryType
    
    init(
        checkValidEmailUseCase: CheckValidEmailUseCaseType,
        checkValidPasswordUseCase: CheckValidPasswordUseCaseType,
        userAuthRepository: UserAuthRepositoryType
    ) {
        self.checkValidEmailUseCase = checkValidEmailUseCase
        self.checkValidPasswordUseCase = checkValidPasswordUseCase
        self.userAuthRepository = userAuthRepository
    }
}

extension HandleUserLoginUseCase: HandleUserLoginUseCaseType {
    func login(email: String, password: String) -> LoginValidationResult {
        guard checkValidPasswordUseCase.isValid(password: password) else {
            return .invalidPassword
        }
        
        print("password is valid")
        
        guard checkValidEmailUseCase.isValid(email: email) else {
            return .invalidEmail
        }
        
        print("email is valid")
        
        guard userAuthRepository.isLoggedIn else {
            return .accountDoesNotExist
        }
        
        print("mám email z user defaults")
        
        guard let savedPassword = userAuthRepository.storedPassword(for: email).success else {
            return .errorLoadingData
        }
        
        print("mám heslo z keychain")
        
        guard password == savedPassword else {
            return .invalidCredentials
        }
        
        print("hesla sedí")
    
        return .validData
    }
}
