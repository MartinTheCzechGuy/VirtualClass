//
//  UserAuthRepositoryStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
@testable import UserSDK

final class UserAuthRepositoryStub: UserAuthRepositoryType {
    
    struct ResultBundle {
        let storeResult: Result<Void, UserAuthRepositoryError>
        let isExistingUserResult: AnyPublisher<Bool, UserAuthRepositoryError>
        let loggedInUserEmail: String?
        let storedPasswordResult: Result<String?, UserAuthRepositoryError>
        
        static func mock(
            storeResult: Result<Void, UserAuthRepositoryError> = .success(()),
            isExistingUserResult: AnyPublisher<Bool, UserAuthRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            loggedInUserEmail: String? = nil,
            storedPasswordResult: Result<String?, UserAuthRepositoryError> = .success(nil)
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
    
    func store(credentials: Credentials) -> Result<Void, UserAuthRepositoryError> {
        results.storeResult
    }
    
    func isExistingUser(withEmail email: String) -> AnyPublisher<Bool, UserAuthRepositoryError> {
        results.isExistingUserResult
    }
    
    var loggedInUserEmail: String? {
        results.loggedInUserEmail
    }
    
    func storedPassword(for email: String) -> Result<String?, UserAuthRepositoryError> {
        results.storedPasswordResult
    }
    
    func logout() {
        return
    }
    
    func storeLoggedInUser(_ email: String) {
        return
    }
}
