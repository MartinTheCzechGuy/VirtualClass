//
//  HandleUserLoginUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class HandleUserLoginUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_login_success() {
        let password = "password"

        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Just(true).setFailureType(to: AuthRepositoryError.self).eraseToAnyPublisher(),
                storedPasswordResult: .success(password)
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have login the user.")
        
        sut.login(email: "email", password: password)
            .sink(
                receiveValue: { result in
                    guard case .validData = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_passwords_does_not_match() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Just(true).setFailureType(to: AuthRepositoryError.self).eraseToAnyPublisher(),
                storedPasswordResult: .success("password1")
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have failed matching the entered and stored password.")
        
        sut.login(email: "email", password: "password2")
            .sink(
                receiveValue: { result in
                    guard case .invalidCredentials = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_password_not_found() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Just(true).setFailureType(to: AuthRepositoryError.self).eraseToAnyPublisher(),
                storedPasswordResult: .success(nil)
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have failed to load a stored password.")
        
        sut.login(email: "email", password: "password2")
            .sink(
                receiveValue: { result in
                    guard case .errorLoadingData = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_account_not_found() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Just(false).setFailureType(to: AuthRepositoryError.self).eraseToAnyPublisher()
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have failed searching for an account with entered email.")
        
        sut.login(email: "email", password: "password2")
            .sink(
                receiveValue: { result in
                    guard case .accountDoesNotExist = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_evaluate_invalid_email() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: false),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have evaluate the email as invalid.")
        
        sut.login(email: "email", password: "password2")
            .sink(
                receiveValue: { result in
                    guard case .invalidEmail = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_evaluate_invalid_password() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: false),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: false),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have evaluate the password as invalid.")
        
        sut.login(email: "email", password: "password2")
            .sink(
                receiveValue: { result in
                    guard case .invalidPassword = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_no_stored_password_found() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Just(true).setFailureType(to: AuthRepositoryError.self).eraseToAnyPublisher(),
                storedPasswordResult: .success(nil)
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have failed loading stored password.")
        
        sut.login(email: "email", password: "password")
            .sink(
                receiveValue: { result in
                    guard case .errorLoadingData = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_checking_existing_user() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Fail(error: AuthRepositoryError.storageError(nil)).eraseToAnyPublisher()
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have non existing account result.")
        
        sut.login(email: "email", password: "password")
            .sink(
                receiveValue: { result in
                    guard case .accountDoesNotExist = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_loading_stored_password() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                isExistingUserResult: Just(true).setFailureType(to: AuthRepositoryError.self).eraseToAnyPublisher(),
                storedPasswordResult: .failure(.storageError(nil))
            )
        )
        
        let sut = HandleLoginUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            userAuthRepository: authRepository
        )
        
        let expectation = expectation(description: "Should have failed loading stored passowrd.")
        
        sut.login(email: "email", password: "password")
            .sink(
                receiveValue: { result in
                    guard case .errorLoadingData = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
