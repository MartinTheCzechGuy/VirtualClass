//
//  CreateStudentProfileUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class CreateStudentProfileUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_create_profile_success() {
        let createPubsliher = Just(()).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                createResult: createPubsliher
            )
        )
        
        let sut = CreateStudentProfileUseCase(userProfileRepository: studentRepository)
        
        let expectation = expectation(description: "Should have received success.")
        
        sut.register(name: "name", email: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    
                    XCTFail()
                }, receiveValue: { _ in
                expectation.fulfill()
            }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_create_profile_failure() {
        let createPubsliher = Fail<Void, UserRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                createResult: createPubsliher
            )
        )
        
        let sut = CreateStudentProfileUseCase(userProfileRepository: studentRepository)
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.register(name: "name", email: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                }, receiveValue: { _ in
                XCTFail()
            }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
