//
//  GetLoggedInUserUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Foundation
import BasicLocalStorage

protocol GetLoggedInUserUseCaseType {
    var email: String? { get }
}

final class GetLoggedInUserUseCase {
    private let authRepository: AuthRepositoryType
    
    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }
}

extension GetLoggedInUserUseCase: GetLoggedInUserUseCaseType {
    var email: String? {
        authRepository.loggedInUserEmail
    }
}
