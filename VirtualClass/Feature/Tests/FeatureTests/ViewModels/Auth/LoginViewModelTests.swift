//
//  LoginViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import XCTest
@testable import Auth

final class LoginViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_handle_successful_login() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .validData)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Login handled")
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.$loginInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        
        sut.loginTap.send((email: "email", password: "password"))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_invalid_password() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .invalidPassword)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Invalid password handled")
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.$loginInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    guard case .invalidPassword = status else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        
        sut.loginTap.send((email: "email", password: "password"))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_invalid_email() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .invalidEmail)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Invalid email handled")
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.$loginInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    guard case .invalidEmail = status else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        
        sut.loginTap.send((email: "email", password: "password"))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_invalid_credentials() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .invalidCredentials)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Invalid credentials handled")
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.$loginInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    guard case .invalidCredentials = status else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        
        sut.loginTap.send((email: "email", password: "password"))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_error_loading_data() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .errorLoadingData)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Error loading credentials handled")
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.$loginInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    guard case .errorStoringCredentials = status else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        
        sut.loginTap.send((email: "email", password: "password"))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_unknown_email() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .accountDoesNotExist)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Unknown email handled")
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.$loginInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    guard case .unknownEmail = status else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        
        sut.loginTap.send((email: "email", password: "password"))
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_go_back_tap_handled() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .invalidPassword)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Go back tap should be handled")
        
        sut.navigateToWelcomeScreen
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.goBackTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_already_have_account_tap_handled() {
        let handleLoginUseCase = HandleLoginUseCaseStub(loginResult: .invalidPassword)
        
        let sut = LoginViewModel(handleLoginUseCase: handleLoginUseCase)
        
        let expectation = expectation(description: "Already have account tap should be handled")
        
        sut.navigateToRegistration
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.registerNewAccountTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
