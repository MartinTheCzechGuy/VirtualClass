//
//  RegistrationViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import XCTest
@testable import Auth

final class RegistrationViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_handle_successful_registration() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .validData)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Should have receive a success value")
        
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
        
        sut.$registrationInvalidStatus
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
        
        sut.registerTap.send(RegistrationData(email: "email", password1: "password", password2: "password", name: "name"))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_non_matching_passwords_evaluated_correctly() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .passwordsDontMatch)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Not matching password should have been evaluated correctly.")
        
        sut.$registrationInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { value in
                    guard case .nonMatchingPasswords = value else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.registerTap.send(RegistrationData(email: "email", password1: "password", password2: "password", name: "name"))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_invalid_password_evaluated_correctly() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .invalidPassword)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Invalid password should have been evaluated correctly.")
        
        sut.$registrationInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { value in
                    guard case .invalidPassword = value else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.registerTap.send(RegistrationData(email: "email", password1: "password", password2: "password", name: "name"))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_invalid_email_evaluated_correctly() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .invalidEmail)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Invalid email should have been evaluated correctly.")
        
        sut.$registrationInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { value in
                    guard case .invalidEmail = value else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.registerTap.send(RegistrationData(email: "email", password1: "password", password2: "password", name: "name"))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_taken_email_evaluated_correctly() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .emailAlreadyUsed)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Taken email should have been evaluated correctly.")
        
        sut.$registrationInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { value in
                    guard case .emailAlreadytaken = value else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.registerTap.send(RegistrationData(email: "email", password1: "password", password2: "password", name: "name"))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_storing_credentials_evaluated_correctly() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .errorStoringCredentials)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Error while storing credentials should have been evaluated correctly.")
        
        sut.$registrationInvalidStatus
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { value in
                    guard case .errorStoringCredentials = value else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.navigateToDashboard
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { status in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.registerTap.send(RegistrationData(email: "email", password1: "password", password2: "password", name: "name"))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_go_back_tap_handled() {
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .errorStoringCredentials)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
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
        let handleRegistrationUseCase = HandleRegistrationUseCaseStub(registrationResult: .errorStoringCredentials)
        
        let sut = RegistrationViewModel(handleRegistrationUseCase: handleRegistrationUseCase)
        
        let expectation = expectation(description: "Already have account tap should be handled")
        
        sut.navigateToSignIn
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.alreadyHaveAccountTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
