//
//  GetCoursesToEnrollUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetCoursesToEnrollUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_load_all_available_courses() {
        let sharedCourse = GenericCourse(
            ident: "ident",
            name: "name",
            description: "",
            credits: 4,
            lessons: [],
            classRoom: .init(id: UUID(), name: ""),
            faculty: .facultyOfManagement,
            teachers: []
        )
        
        let activeCourses: Set<GenericCourse> = [
            GenericCourse(
                ident: "ident2",
                name: "name 2",
                description: "",
                credits: 6,
                lessons: [],
                classRoom: .init(id: UUID(), name: "name"),
                faculty: .facultyOfEconomics,
                teachers: []
            ),
            sharedCourse
        ]
        
        let userCourses: Set<GenericCourse> = [
            sharedCourse
        ]
        
        let activeCoursesPublisher = Just(activeCourses).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let userCoursesPublisher = Just(userCourses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()

        let sut = GetCoursesToEnrollUseCase(
            studentRepository: StudentRepositoryStub(results: .mock(activeCoursesResult: activeCoursesPublisher)),
            getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: userCoursesPublisher)
        )
        
        let expectation = expectation(description: "Should have received only the not shared course.")
        
        sut.allAvailable
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { courses in
                    XCTAssertEqual(courses.count, 1)
                    XCTAssertEqual(courses.first?.ident, "ident2")
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_all_available_courses_error_propagated() {
        let activeCoursesPublisher = Fail<Set<GenericCourse>, UserRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
        let userCoursesPublisher = Empty<Set<GenericCourse>, GetCoursesForUserError>().eraseToAnyPublisher()

        let sut = GetCoursesToEnrollUseCase(
            studentRepository: StudentRepositoryStub(results: .mock(activeCoursesResult: activeCoursesPublisher)),
            getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: userCoursesPublisher)
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.allAvailable
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
    
    func test_load_active_courses_error_propagated() {
        let activeCoursesPublisher = Just(Set<GenericCourse>()).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let userCoursesPublisher = Fail<Set<GenericCourse>, GetCoursesForUserError>(error: .init(cause: .emailNotFound)).eraseToAnyPublisher()

        let sut = GetCoursesToEnrollUseCase(
            studentRepository: StudentRepositoryStub(results: .mock(activeCoursesResult: activeCoursesPublisher)),
            getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: userCoursesPublisher)
        )
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.allAvailable
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
    
    func test_load_specific_available_course_succes() {
        let sharedCourse = GenericCourse(
            ident: "ident",
            name: "name",
            description: "",
            credits: 4,
            lessons: [],
            classRoom: .init(id: UUID(), name: ""),
            faculty: .facultyOfManagement,
            teachers: []
        )
        
        let activeCourses: Set<GenericCourse> = [
            GenericCourse(
                ident: "ident3",
                name: "name 3",
                description: "",
                credits: 6,
                lessons: [],
                classRoom: .init(id: UUID(), name: "name"),
                faculty: .facultyOfEconomics,
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
            ),
            sharedCourse
        ]
        
        let userCourses: Set<GenericCourse> = [
            sharedCourse
        ]
        
        let activeCoursesPublisher = Just(activeCourses).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let userCoursesPublisher = Just(userCourses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()

        let sut = GetCoursesToEnrollUseCase(
            studentRepository: StudentRepositoryStub(results: .mock(activeCoursesResult: activeCoursesPublisher)),
            getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: userCoursesPublisher)
        )
        
        let expectation = expectation(description: "Should have received only the not shared course.")
        
        sut.find(ident: "ident3")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { courses in
                    XCTAssertEqual(courses.count, 1)
                    XCTAssertEqual(courses.first?.ident, "ident3")
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_specific_available_course_empty_set() {
        let sharedCourse = GenericCourse(
            ident: "ident",
            name: "name",
            description: "",
            credits: 4,
            lessons: [],
            classRoom: .init(id: UUID(), name: ""),
            faculty: .facultyOfManagement,
            teachers: []
        )
        
        let activeCourses: Set<GenericCourse> = [
            sharedCourse
        ]
        
        let userCourses: Set<GenericCourse> = [
            sharedCourse
        ]
        
        let activeCoursesPublisher = Just(activeCourses).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
        let userCoursesPublisher = Just(userCourses).setFailureType(to: GetCoursesForUserError.self).eraseToAnyPublisher()

        let sut = GetCoursesToEnrollUseCase(
            studentRepository: StudentRepositoryStub(results: .mock(activeCoursesResult: activeCoursesPublisher)),
            getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseStub(coursesResult: userCoursesPublisher)
        )
        
        let expectation = expectation(description: "Should have received empty set.")
        
        sut.find(ident: "not existing course")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
            },
                receiveValue: { courses in
                    XCTAssertTrue(courses.isEmpty)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
