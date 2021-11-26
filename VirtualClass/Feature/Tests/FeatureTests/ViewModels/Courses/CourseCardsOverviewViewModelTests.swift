//
//  CourseCardsOverviewViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK
import XCTest
@testable import Courses

final class CourseCardsOverviewViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_load_courses_success() {
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
        let coursesPublisher = Just(courses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()
        let getCoursesUseCase = GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CourseCardsOverviewViewModel(getCoursesUseCase: getCoursesUseCase)
        
        let expectation = expectation(description: "Courses should have been loaded")
        
        sut.$studiedClasses
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
        
        sut.reloadData.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_courses_failure() {
        let coursesPublisher = Fail<Set<GenericCourse>, GetCoursesForUserError>(error: .init(cause: .emailNotFound))
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CourseCardsOverviewViewModel(getCoursesUseCase: getCoursesUseCase)
        
        let expectation = expectation(description: "Error loading courses should have been propagated")
        
        sut.$errorLoadingData
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { result in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadData.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_card_tap_handle() {
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
        let coursesPublisher = Just(courses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()
        let getCoursesUseCase = GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CourseCardsOverviewViewModel(getCoursesUseCase: getCoursesUseCase)
        
        let expectation = expectation(description: "Card tap should have been handled.")
        
        sut.classCardTap
            .sink(
                receiveValue: { result in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.classCardTapSubject.send(
            GenericCourse(
                ident: "ident",
                name: "",
                description: "",
                credits: 4,
                lessons: [],
                classRoom: GenericClassRoom(id: UUID(), name: ""),
                faculty: .facultyOfAccounting,
                teachers: []
            )
        )
                
        waitForExpectations(timeout: 0.1)
    }
    
    func test_add_course_tap_handle() {
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
        let coursesPublisher = Just(courses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()
        let getCoursesUseCase = GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: coursesPublisher)
        
        let sut = CourseCardsOverviewViewModel(getCoursesUseCase: getCoursesUseCase)
        
        let expectation = expectation(description: "Add courses tap should have been handled.")
        
        sut.addClassButtonTap
            .sink(
                receiveValue: { result in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.adddClassSubject.send(())
                
        waitForExpectations(timeout: 0.1)
    }
}
