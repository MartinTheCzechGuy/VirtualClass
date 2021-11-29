//
//  GetActiveCoursesUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetActiveCoursesUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_courses_loaded_successfully() {
        let student = GenericStudent(
            id: UUID(),
            name: "name",
            email: "email",
            activeCourses: [
                GenericCourse(
                    ident: "course ident",
                    name: "",
                    description: "",
                    credits: 4,
                    lessons: [],
                    classRoom: .init(id: UUID(), name: ""),
                    faculty: .facultyOfManagement,
                    teachers: []
                )
            ],
            completedCourses: []
        )
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentResult: Just(student).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
            )
        )
        
        let sut = GetActiveCoursesUseCase(repository: studentRepository)
        
        let expectation = expectation(description: "Should have received courses.")
        
        sut.courses(forUserWithEmail: "user email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { courses in
                    XCTAssertEqual(courses.count, 1)
                    
                    guard let course = courses.first else {
                        XCTFail()
                        
                        return
                    }
                    
                    XCTAssertEqual(course.ident, student.activeCourses.first?.ident)
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }

    func test_no_user_found_mapped_into_empty_array() {
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentResult: Just(nil).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
            )
        )
        let sut = GetActiveCoursesUseCase(repository: studentRepository)
        
        let expectation = expectation(description: "Should have received empty courses list.")
        
        sut.courses(forUserWithEmail: "user email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { courses in
                    XCTAssertEqual(courses.count, 0)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetching_user_error_propagated() {
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentResult: Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()
            )
        )
        let sut = GetActiveCoursesUseCase(repository: studentRepository)
        
        let expectation = expectation(description: "Should have received an error")
        
        sut.courses(forUserWithEmail: "user email")
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
