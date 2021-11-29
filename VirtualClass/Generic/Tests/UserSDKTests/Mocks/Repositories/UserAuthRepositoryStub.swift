//
//  UserAuthRepositoryStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
@testable import UserSDK

final class UserAuthRepositoryStub: AuthRepositoryType {
    
    struct ResultBundle {
        let storeResult: Result<Void, AuthRepositoryError>
        let isExistingUserResult: AnyPublisher<Bool, AuthRepositoryError>
        let loggedInUserEmail: String?
        let storedPasswordResult: Result<String?, AuthRepositoryError>
        
        static func mock(
            storeResult: Result<Void, AuthRepositoryError> = .success(()),
            isExistingUserResult: AnyPublisher<Bool, AuthRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            loggedInUserEmail: String? = nil,
            storedPasswordResult: Result<String?, AuthRepositoryError> = .success(nil)
        ) -> ResultBundle {
            .init(
                storeResult: storeResult,
                isExistingUserResult: isExistingUserResult,
                loggedInUserEmail: loggedInUserEmail,
                storedPasswordResult: storedPasswordResult
            )
        }
    }
    
    private let results: ResultBundle
    
    init(results: ResultBundle) {
        self.results = results
    }
    
    func store(credentials: Credentials) -> Result<Void, AuthRepositoryError> {
        results.storeResult
    }
    
    func isExistingUser(withEmail email: String) -> AnyPublisher<Bool, AuthRepositoryError> {
        results.isExistingUserResult
    }
    
    var loggedInUserEmail: String? {
        results.loggedInUserEmail
    }
    
    func storedPassword(for email: String) -> Result<String?, AuthRepositoryError> {
        results.storedPasswordResult
    }
    
    func logout() {
        return
    }
    
    func storeLoggedInUser(_ email: String) {
        return
    }
}
