//
//  CompletedCoursesViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK
import XCTest
@testable import Courses

final class CompletedCoursesViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_fetch_courses_on_reload() {
        let courses: Set<GenericCourse> = [
            GenericCourse(
                ident: "ident",
                name: "name",
                description: "desc",
                credits: 5,
                lessons: [Date()],
                classRoom: GenericClassRoom(id: UUID(), name: "name"),
                faculty: .facultyOfAccounting,
                teachers: [
                    GenericTeacher(id: UUID(), name: "name")
                ]
            )
        ]
        let coursesPublisher = Just(courses)
            .setFailureType(to: GetCompletedCoursesError.self)
            .eraseToAnyPublisher()
        let useCase = GetCompletedCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CompletedCoursesViewModel(getCompletedCoursesUseCase: useCase)
        
        let expectation = expectation(description: "Courses should have been fetched.")
        
        sut.$completedCourses
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { result in
                    XCTAssertEqual(result.first?.ident, courses.first?.ident)
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadDataSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetch_courses_on_reload_failure() {
        let coursesPublisher = Fail<Set<GenericCourse>, GetCompletedCoursesError>(error: .init(cause: .errorLoadingCourses))
            .eraseToAnyPublisher()
        let useCase = GetCompletedCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CompletedCoursesViewModel(getCompletedCoursesUseCase: useCase)
        
        let expectation = expectation(description: "Error fetching courses should have been propagated.")
        
        sut.$showError
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { result in
                    XCTAssertTrue(result)
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadDataSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_go_back_tap_handle() {
        let coursesPublisher = Empty<Set<GenericCourse>, GetCompletedCoursesError>()
            .eraseToAnyPublisher()
        let useCase = GetCompletedCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CompletedCoursesViewModel(getCompletedCoursesUseCase: useCase)
        
        let expectation = expectation(description: "Back tap should have been handled.")
        
        sut.navigateBackTap
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.goBackTapSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
