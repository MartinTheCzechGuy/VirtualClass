//
//  IsUserLoggedInUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation
import CombineExt

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
            print("IsUserLoggedInUseCase - no email found")
            return false
        }
        
        print("IsUserLoggedInUseCase - email found, checking password")
        
        let passwordResult = authRepository.storedPassword(for: email)
        
        switch passwordResult {
        case .success(let optionalPassword):
            print("IsUserLoggedInUseCase - found \(String(describing: optionalPassword))")
            return optionalPassword != nil
        case .failure:
            print("IsUserLoggedInUseCase - error loading password")
            return false
        }
    }
}
