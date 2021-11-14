//
//  HandleLogOutUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

public protocol HandleLogOutUseCaseType {
    func logout() -> Result<Void, UserAuthRepositoryError>
}

final class HandleLogOutUseCase {
    private let userAuthRepository: UserAuthRepositoryType
    
    init(userAuthRepository: UserAuthRepositoryType) {
        self.userAuthRepository = userAuthRepository
    }
}

extension HandleLogOutUseCase: HandleLogOutUseCaseType {
    func logout() -> Result<Void, UserAuthRepositoryError> {
        userAuthRepository.logout()
    }
}
