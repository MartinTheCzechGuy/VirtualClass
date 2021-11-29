//
//  RemoveCourseFromStudiedUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class RemoveCourseFromStudiedUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_remove_course_from_studied_success() {
        let studentRepository = StudentRepositoryStub(results: .mock(removeCourseResult: Just(()).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()))
        let sut = RemoveCourseFromStudiedUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have successfully remove the course.")
        
        sut.remove(courseIdent: "ident")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_removing_course_propagated() {
        let studentRepository = StudentRepositoryStub(results: .mock(removeCourseResult: Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()))
        let sut = RemoveCourseFromStudiedUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.remove(courseIdent: "ident")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
            },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_loading_email_propagated() {
        let studentRepository = StudentRepositoryStub(results: .mock())
        let sut = RemoveCourseFromStudiedUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseFailingStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")

        sut.remove(courseIdent: "ident")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
            },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
