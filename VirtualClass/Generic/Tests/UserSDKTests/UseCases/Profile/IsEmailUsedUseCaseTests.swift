//
//  IsEmailUsedUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class IsEmailUsedUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_an_available_email_address() {
        let students: [GenericStudent] = [
            GenericStudent(
                id: UUID(),
                name: "name",
                email: "email1",
                activeCourses: [],
                completedCourses: []
            ),
            GenericStudent(
                id: UUID(),
                name: "name",
                email: "email2",
                activeCourses: [],
                completedCourses: []
            )
        ]
        
        let studentsPublisher = Just(students).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
        
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentsResult: studentsPublisher
            )
        )
        
        let sut = IsEmailUsedUseCase(userRepository: studentRepository)
        
        let expectation = expectation(description: "Email should be evaluated as available.")
        
        sut.isAlreadyUsed("email3")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail()
                    case .finished:
                        return
                    }
                },
                receiveValue: { isAlreadyUsed in
                    guard !isAlreadyUsed else {
                        XCTFail()
                        return
                    }
            
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_already_taken_email_address() {
        let students: [GenericStudent] = [
            GenericStudent(
                id: UUID(),
                name: "name",
                email: "email1",
                activeCourses: [],
                completedCourses: []
            ),
            GenericStudent(
                id: UUID(),
                name: "name",
                email: "email2",
                activeCourses: [],
                completedCourses: []
            )
        ]
        
        let studentsPublisher = Just(students).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
        
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentsResult: studentsPublisher
            )
        )
        
        let sut = IsEmailUsedUseCase(userRepository: studentRepository)
        
        let expectation = expectation(description: "Email should be evaluated as not available.")
        
        sut.isAlreadyUsed("email2")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail()
                    case .finished:
                        return
                    }
                },
                receiveValue: { isAlreadyUsed in
                    guard isAlreadyUsed else {
                        XCTFail()
                        return
                    }
            
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_propagated() {
        let studentsPublisher = Fail<[GenericStudent], StudentRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
        
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentsResult: studentsPublisher
            )
        )
        
        let sut = IsEmailUsedUseCase(userRepository: studentRepository)
        
        let expectation = expectation(description: "Should have receive an error")
        
        sut.isAlreadyUsed("email2")
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
