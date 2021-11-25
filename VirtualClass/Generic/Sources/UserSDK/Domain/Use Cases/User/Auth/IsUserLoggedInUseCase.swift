//
//  IsUserLoggedInUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public protocol IsUserLoggedInUseCaseType {
    var isUserLogged: Bool { get }
}

final class IsUserLoggedInUseCase {
    private let authRepository: UserAuthRepositoryType
    
    init(authRepository: UserAuthRepositoryType) {
        self.authRepository = authRepository
    }
}

extension IsUserLoggedInUseCase: IsUserLoggedInUseCaseType {
    var isUserLogged: Bool {
        guard let email = authRepository.loggedInUserEmail else {
            return false
        }
                
        let passwordResult = authRepository.storedPassword(for: email)
        
        switch passwordResult {
        case .success(let optionalPassword):
            return optionalPassword != nil
        case .failure:
            return false
        }
    }
}
