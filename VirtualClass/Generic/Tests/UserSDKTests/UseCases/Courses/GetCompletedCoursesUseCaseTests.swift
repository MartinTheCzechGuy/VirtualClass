//
//  GetCompletedCoursesUseCaseTests.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetCompletedCoursesUseCaseTests: XCTestCase {
    
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
            activeCourses: [],
            completedCourses: [
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
            ]
        )
        
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentResult: Just(student).setFailureType(to: StudentRepositoryError.self).eraseToAnyPublisher()
            )
        )
        
        let sut = GetCompletedCoursesUseCase(repository: studentRepository)
        
        let expectation = expectation(description: "Should have received courses.")
        
        sut.courses(userWithEmail: "user email")
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
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentResult: Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()
            )
        )
        
        let sut = GetCompletedCoursesUseCase(repository: studentRepository)
        
        let expectation = expectation(description: "Should have received an error.")
        
        sut.courses(userWithEmail: "user email")
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
