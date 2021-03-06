//
//  HandleLogOutUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

public protocol HandleLogOutUseCaseType {
    func logout()
}

final class HandleLogOutUseCase {
    private let userAuthRepository: AuthRepositoryType
    
    init(userAuthRepository: AuthRepositoryType) {
        self.userAuthRepository = userAuthRepository
    }
}

extension HandleLogOutUseCase: HandleLogOutUseCaseType {
    func logout() {
        userAuthRepository.logout()
    }
}
