//
//  GetCompletedCoursesForLoggedInUserUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetCompletedCoursesForLoggedInUserUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_courses_loaded_successfully() {
        let courses: Set<GenericCourse> = [
            GenericCourse(
                ident: "ident",
                name: "name",
                description: "",
                credits: 4,
                lessons: [],
                classRoom: .init(id: UUID(), name: ""),
                faculty: .facultyOfManagement,
                teachers: []
            )
        ]
        
        let coursesPublisher = Just(courses).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
        
        let sut = GetCompletedCoursesForLoggedInUserUseCase(
            getCoursesUseCase: GetCompletedCoursesUseCaseStub(courses: coursesPublisher),
            getLogedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received courses.")
        
        sut.courses
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { courses in
                    XCTAssertEqual(courses.count, 1)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }

    func test_fetching_courses_error_propagated() {
        let sut = GetCompletedCoursesForLoggedInUserUseCase(
            getCoursesUseCase: GetCompletedCoursesUseCaseStub(courses: Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()),
            getLogedInUserUseCase: GetLoggedInUserUseCaseStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.courses
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
            },
                receiveValue: { courses in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_no_email_found_error_propagated() {
        let sut = GetCompletedCoursesForLoggedInUserUseCase(
            getCoursesUseCase: GetCompletedCoursesUseCaseStub(
                courses: Empty().setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
            ),
            getLogedInUserUseCase: GetLoggedInUserUseCaseFailingStub()
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.courses
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
            },
                receiveValue: { courses in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
