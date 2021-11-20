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
                
        guard checkValidEmailUseCase.isValid(email: email) else {
            return .invalidEmail
        }
                
        guard let userExists = userAuthRepository.isExistingUser(withEmail: email).success, userExists
        else {
            return .accountDoesNotExist
        }
                
        guard let savedPassword = userAuthRepository.storedPassword(for: email).success,
                savedPassword != nil
        else {
            return .errorLoadingData
        }
                
        guard password == savedPassword else {
            return .invalidCredentials
        }
        
        userAuthRepository.storeLoggedInUser(email)
            
        return .validData
    }
}
