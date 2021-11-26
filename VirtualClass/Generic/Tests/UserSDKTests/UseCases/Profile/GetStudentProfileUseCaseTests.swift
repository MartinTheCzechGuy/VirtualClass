//
//  GetStudentProfileUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetStudentProfileUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_fetch_profile_successfully() {
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
                loadStudentResult: Just(student).setFailureType(to: UserRepositoryError.self).eraseToAnyPublisher()
            )
        )
        let sut = GetStudentProfileUseCase(
            getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseStub(),
            userProfileRepository: studentRepository
        )
        
        let expectation = expectation(description: "Should have receive a profile")
        
        sut.userProfile
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    
                    XCTFail()
                },
                  receiveValue: { fetchedProfile in
                      XCTAssertEqual(student.id, fetchedProfile?.id)
                      
                      expectation.fulfill()
                  }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_fetching_profile() {
        let studentRepository = StudentRepositoryStub(
            results: .mock(
                loadStudentResult: Fail<GenericStudent?, UserRepositoryError>(error: .storageError(nil)).eraseToAnyPublisher()
            )
        )
        let sut = GetStudentProfileUseCase(
            getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseStub(),
            userProfileRepository: studentRepository
        )
        
        let expectation = expectation(description: "Should have receive an error")
        
        sut.userProfile
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                  receiveValue: { fetchedProfile in
                      XCTFail()
                  }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_loading_email() {
        let studentRepository = StudentRepositoryStub(
            results: .mock()
        )
        let sut = GetStudentProfileUseCase(
            getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseFailingStub(),
            userProfileRepository: studentRepository
        )
        
        let expectation = expectation(description: "Should have receive an error")
        
        sut.userProfile
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                  receiveValue: { fetchedProfile in
                      XCTFail()
                  }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
