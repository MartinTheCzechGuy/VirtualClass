//
//  IsUserLoggedInUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class IsUserLoggedInUseCaseTests: XCTestCase {
    func test_user_is_logged_in() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                loggedInUserEmail: "email",
                storedPasswordResult: .success("tada")
            )
        )
        
        let sut = IsUserLoggedInUseCase(authRepository: authRepository)
        
        XCTAssertTrue(sut.isUserLogged)
    }
    
    func test_user_is_not_logged_in_missing_email() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                loggedInUserEmail: nil
            )
        )
        
        let sut = IsUserLoggedInUseCase(authRepository: authRepository)
        
        XCTAssertFalse(sut.isUserLogged)
    }
    
    func test_user_is_not_logged_in_missing_password() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                loggedInUserEmail: "email",
                storedPasswordResult: .success(nil)
            )
        )
        
        let sut = IsUserLoggedInUseCase(authRepository: authRepository)
        
        XCTAssertFalse(sut.isUserLogged)
    }
    
    func test_user_is_not_logged_in_error_loading_password() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                loggedInUserEmail: "email",
                storedPasswordResult: .failure(.storageError(nil))
            )
        )
        
        let sut = IsUserLoggedInUseCase(authRepository: authRepository)
        
        XCTAssertFalse(sut.isUserLogged)
    }
}
