//
//  GetLecturesUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetLecturesUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_load_lectures_successfully() {
        let date = Date() + 200
        
        let activeCourses: Set<GenericCourse> = [
            GenericCourse(
                ident: "ident",
                name: "name",
                description: "",
                credits: 4,
                lessons: [date],
                classRoom: .init(id: UUID(), name: ""),
                faculty: .facultyOfManagement,
                teachers: []
            ),
            GenericCourse(
                ident: "ident2",
                name: "name 2",
                description: "",
                credits: 6,
                lessons: [],
                classRoom: .init(id: UUID(), name: "name"),
                faculty: .facultyOfEconomics,
                teachers: []
            )
        ]
        let coursesPublisher = Just(activeCourses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()
        
        let sut = GetLecturesUseCase(coursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher))
        
        let expectation = expectation(description: "Should have successfully load events.")
        
        sut.lectures(on: date)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { lectures in
                    XCTAssertEqual(lectures.count, 1)
                    XCTAssertEqual(lectures.first?.classIdent, "ident")
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_empty_lectures_successfully() {
        let activeCourses: Set<GenericCourse> = [
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
        let coursesPublisher = Just(activeCourses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()
        
        let sut = GetLecturesUseCase(coursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher))
        
        let expectation = expectation(description: "Should have load empty array of events.")
        
        sut.lectures(on: Date())
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { lectures in
                    XCTAssertTrue(lectures.isEmpty)
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    
    func test_propagate_error_loading_courses() {
        let coursesPublisher = Fail<Set<GenericCourse>,GetCoursesForUserError>(error: .init(cause: .emailNotFound)).eraseToAnyPublisher()
        
        let sut = GetLecturesUseCase(coursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher))
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.lectures(on: Date())
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
            },
                receiveValue: { lectures in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
