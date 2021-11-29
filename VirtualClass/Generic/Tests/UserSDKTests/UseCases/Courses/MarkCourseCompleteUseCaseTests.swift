//
//  MarkCourseCompleteUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class MarkCourseCompleteUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_course_marked_complete_success() {
        let studentRepository = StudentRepositoryStub(results: .mock(markCompleteResult: Just(()).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()))
        
        let sut = MarkCourseCompleteUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have successfully mark the course completed.")
        
        sut.complete(courseIdent: "ident")
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
    
    func test_error_marking_the_course_propagated() {
        let studentRepository = StudentRepositoryStub(results: .mock(markCompleteResult: Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()))
        
        let sut = MarkCourseCompleteUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.complete(courseIdent: "ident")
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
        let studentRepository = StudentRepositoryStub(results: .mock(markCompleteResult: Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()))
        
        let sut = MarkCourseCompleteUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")

        sut.complete(courseIdent: "ident")
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
