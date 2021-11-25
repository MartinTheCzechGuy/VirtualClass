//
//  AddToUserActiveCoursesUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class AddToUserActiveCoursesUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_course_added_success_propagated() {
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                addCourseResult: Just(()).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
            )
        )
        let sut = AddToUserActiveCoursesUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received a success value.")
        
        sut.add(idents: [])
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { _ in expectation.fulfill() }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_adding_courses_propagated() {
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                addCourseResult: Fail(error: UserRepositoryError.databaseError(nil)).eraseToAnyPublisher()
            )
        )
        let sut = AddToUserActiveCoursesUseCase(
            studentRepository: studentRepository,
            getLoggedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.add(idents: [])
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail()
                    case .failure:
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in XCTFail() }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
