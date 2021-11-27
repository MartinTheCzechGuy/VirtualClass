//
//  UpdateStudentProfileUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class UpdateStudentProfileUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_user_profile_updated() {
        let student = GenericUserProfile(
            id: UUID(),
            name: "name",
            email: "email1"
        )
        
        let updateResultPublisher = Just(()).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                updateResult: updateResultPublisher
            )
        )
        
        let sut = UpdateStudentProfileUseCase(userRepository: studentRepository)
        
        let expectation = expectation(description: "Should have receive a success result.")
        
        sut.update(student)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail()
                    case .finished:
                        return
                    }
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_updating_user_profile() {
        let student = GenericUserProfile(
            id: UUID(),
            name: "name",
            email: "email1"
        )
        let updateResultPublisher = Fail<Void, UserRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
        
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                updateResult: updateResultPublisher
            )
        )
        
        let sut = UpdateStudentProfileUseCase(userRepository: studentRepository)
        
        let expectation = expectation(description: "Should have receive an error.")
        
        sut.update(student)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        expectation.fulfill()
                    case .finished:
                        XCTFail()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
