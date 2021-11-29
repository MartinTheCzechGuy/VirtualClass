//
//  HandleLoginUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine
import CombineExt
import Common
import Foundation

enum HandleLoginError: Error {
    case accountDoesNotExist
    case errorLoadingData
    case invalidCredentials
}

public protocol HandleLoginUseCaseType {
    func login(email: String, password: String) -> AnyPublisher<LoginValidationResult, Never>
}

final class HandleLoginUseCase {
    
    private let checkValidEmailUseCase: CheckValidEmailUseCaseType
    private let checkValidPasswordUseCase: CheckValidPasswordUseCaseType
    private let userAuthRepository: AuthRepositoryType
    
    init(
        checkValidEmailUseCase: CheckValidEmailUseCaseType,
        checkValidPasswordUseCase: CheckValidPasswordUseCaseType,
        userAuthRepository: AuthRepositoryType
    ) {
        self.checkValidEmailUseCase = checkValidEmailUseCase
        self.checkValidPasswordUseCase = checkValidPasswordUseCase
        self.userAuthRepository = userAuthRepository
    }
}

extension HandleLoginUseCase: HandleLoginUseCaseType {
    func login(email: String, password: String) -> AnyPublisher<LoginValidationResult, Never> {
        guard checkValidPasswordUseCase.isValid(password: password) else {
            return Just(.invalidPassword).eraseToAnyPublisher()
        }
                
        guard checkValidEmailUseCase.isValid(email: email) else {
            return Just(.invalidEmail).eraseToAnyPublisher()
        }
                
        let isExistingUser = userAuthRepository.isExistingUser(withEmail: email)
            .replaceError(with: false)
            .share(replay: 1)
        
        let userDoesNotExists = isExistingUser
            .filter { !$0 }
            .map { _ in LoginValidationResult.accountDoesNotExist }
        
        let hasStoredPassword = isExistingUser
            .filter { $0 }
            .flatMap { [weak self] _ -> AnyPublisher<String?, Never> in
                guard let self = self else {
                    return Just(nil).eraseToAnyPublisher()
                }
                
                return self.userAuthRepository.storedPassword(for: email).publisher
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            }
            .share(replay: 1)

        let passwordNotFound = hasStoredPassword
            .filter { optionalPassword in
                optionalPassword == nil
            }
            .map { _ in LoginValidationResult.errorLoadingData }
        
        let checkPassword = hasStoredPassword
            .compactMap { $0 }
            .map { storedPassword in
                storedPassword == password
            }
            .share(replay: 1)

        let passwordDoesntMatch = checkPassword
            .filter { !$0 }
            .map { _ in LoginValidationResult.invalidCredentials }

        let storeLoggedInUser = checkPassword
            .filter { $0 }
            .compactMap { [weak self] _ -> LoginValidationResult? in
                guard let self = self else { return nil }
                
                self.userAuthRepository.storeLoggedInUser(email)
                
                return .validData
            }
        
        return userDoesNotExists
            .merge(with: passwordNotFound)
            .merge(with: passwordDoesntMatch)
            .merge(with: storeLoggedInUser)
            .eraseToAnyPublisher()
    }
}
