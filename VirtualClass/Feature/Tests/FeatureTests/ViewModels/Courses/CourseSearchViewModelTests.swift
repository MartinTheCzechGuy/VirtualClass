//
//  CourseSearchViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK
import XCTest
@testable import Courses

final class CourseSearchViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_load_all_available_courses_on_reload() {
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
            .setFailureType(to: GetCoursesToEnrollError.self)
            .eraseToAnyPublisher()
        let addPublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "Should have load available courses")
        
        sut.$searchResult
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
    
    func test_error_loading_all_available_courses_propagated() {
        let coursesPublisher = Fail<Set<GenericCourse>, GetCoursesToEnrollError>(error: .init(cause: .erorLoadingAvailableCourses))
            .eraseToAnyPublisher()
        let addPublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "The error from loading courses should have been propagated.")
        
        sut.$showError
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadDataSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_find_specific_courses_success() {
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
            ),
            GenericCourse(
                ident: "ident42",
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
            .setFailureType(to: GetCoursesToEnrollError.self)
            .eraseToAnyPublisher()
        let addPublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "Should have load specific course")
        
        sut.$searchResult
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { result in
                    XCTAssertEqual(result.count, 1)
                    XCTAssertEqual(result.first?.ident, "ident42")
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        // In order to avoid the debounce on the chain in VM
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sut.searchedCourse = "ident42"
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func test_find_specific_courses_error() {
        let coursesPublisher = Fail<Set<GenericCourse>, GetCoursesToEnrollError>(error: .init(cause: .erorLoadingAvailableCourses))
            .eraseToAnyPublisher()
        let addPublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "The error from loading courses should have been propagated.")

        sut.$showError
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        // In order to avoid the debounce on the chain in VM
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sut.searchedCourse = "ident42"
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func test_add_selected_courses_success() {
        let coursesPublisher = Empty<Set<GenericCourse>, GetCoursesToEnrollError>()
            .eraseToAnyPublisher()
        let addPublisher = Just(())
            .setFailureType(to: StudentRepositoryError.self)
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "Should have add selected courses")
        
        sut.classedAddedSuccessfully
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.addSelectedTapSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_add_selected_courses_failure() {
        let coursesPublisher = Empty<Set<GenericCourse>, GetCoursesToEnrollError>()
            .eraseToAnyPublisher()
        let addPublisher = Fail<Void, StudentRepositoryError>(error: .databaseError(nil))
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "Should have propagate the error.")
        
        sut.$showError
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.addSelectedTapSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_back_tap_handled() {
        let coursesPublisher = Empty<Set<GenericCourse>, GetCoursesToEnrollError>()
            .eraseToAnyPublisher()
        let addPublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getCoursesUseCase = GetCoursesToEnrollUseCaseStub(coursesResult: coursesPublisher)
        let addCourseUseCase = AddToUserActiveCoursesUseCaseStub(result: addPublisher)
        let sut = CourseSearchViewModel(findPossibleToEnrollCoursesUseCase: getCoursesUseCase, addCoursesUseCase: addCourseUseCase)
        
        let expectation = expectation(description: "Back tap should be handled.")
        
        sut.goBackTap
            .sink(
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.goBackTapSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
