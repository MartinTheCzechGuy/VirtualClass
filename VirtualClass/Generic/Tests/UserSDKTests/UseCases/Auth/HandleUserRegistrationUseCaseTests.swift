//
//  HandleUserRegistrationUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//


import Combine
import Foundation
import XCTest
@testable import UserSDK

final class HandleUserRegistrationUseCaseTests: XCTestCase {
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_register_success() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
            )
        )
        
        let isEmailUsedPublisher = Just(false).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let profileCreatedPublisher = Just(()).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have register new user.")
        
        sut.register(form: registrationForm)
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
    
    func test_register_fail_error_creating_profile() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
            )
        )
        
        let isEmailUsedPublisher = Just(false).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let profileCreatedPublisher = Fail<Void, UserRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed due to error while creating user profile.")
        
        sut.register(form: registrationForm)
            .sink(
                receiveValue: { result in
                    guard case .errorStoringCredentials = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_register_fail_error_storing_credentials() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                storeResult: .failure(.storageError(nil))
            )
        )
        
        let isEmailUsedPublisher = Just(false).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let profileCreatedPublisher = Empty<Void, UserRepositoryError>().eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed due to error while storing credentials")
        
        sut.register(form: registrationForm)
            .sink(
                receiveValue: { result in
                    guard case .errorStoringCredentials = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_register_fail_taken_email() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let isEmailUsedPublisher = Just(true).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let profileCreatedPublisher = Empty<Void, UserRepositoryError>().eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed since the email is already taken.")
        
        sut.register(form: registrationForm)
            .sink(
                receiveValue: { result in
                    guard case .emailAlreadyUsed = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_register_fail_error_checking_email_availability() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let isEmailUsedPublisher = Fail<Bool, UserRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
        let profileCreatedPublisher = Empty<Void, UserRepositoryError>().eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: true),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed due to error while checking email availibility.")
        
        sut.register(form: registrationForm)
            .sink(
                receiveValue: { result in
                    guard case .errorStoringCredentials = result else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_register_fail_invalid_email() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let isEmailUsedPublisher = Empty<Bool, UserRepositoryError>().eraseToAnyPublisher()
        let profileCreatedPublisher = Empty<Void, UserRepositoryError>().eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: false),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: true),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed due to invalid email format.")
        
        sut.register(form: registrationForm)
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
    
    func test_register_fail_invalid_password() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let isEmailUsedPublisher = Empty<Bool, UserRepositoryError>().eraseToAnyPublisher()
        let profileCreatedPublisher = Empty<Void, UserRepositoryError>().eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: false),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: false),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed due to invalid password format.")
        
        sut.register(form: registrationForm)
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
    
    func test_register_fail_passwords_does_not_match() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock()
        )
        
        let isEmailUsedPublisher = Empty<Bool, UserRepositoryError>().eraseToAnyPublisher()
        let profileCreatedPublisher = Empty<Void, UserRepositoryError>().eraseToAnyPublisher()
        
        let sut = HandleUserRegistrationUseCase(
            checkValidEmailUseCase: CheckValidEmailUseCaseStub(isValid: false),
            checkValidPasswordUseCase: CheckValidPasswordUseCaseStub(isValid: false),
            isEmailUsedUseCase: IsEmailUsedUseCaseStub(result: isEmailUsedPublisher),
            userAuthRepository: authRepository,
            createUserProfileUseCase: CreateStudentProfileUseCaseStub(result: profileCreatedPublisher)
        )
        
        let registrationForm = RegistrationFormData(
            email: "email",
            password1: "password",
            password2: "password1",
            name: "name"
        )
        
        let expectation = expectation(description: "Should have failed due to non matching passwords.")
        
        sut.register(form: registrationForm)
            .sink(
                receiveValue: { result in
                    guard case .passwordsDontMatch = result else {
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
