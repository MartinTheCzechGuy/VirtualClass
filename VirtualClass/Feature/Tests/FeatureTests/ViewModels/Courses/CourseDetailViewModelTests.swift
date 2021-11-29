//
//  CourseDetailViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK
import XCTest
@testable import Courses

final class CourseDetailViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_remove_course_success() {
        let completeCoursePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let removeCoursePublisher = Just(())
            .setFailureType(to: StudentRepositoryError.self)
            .eraseToAnyPublisher()
        let removeCourseUseCase = RemoveCourseFromStudiedUseCaseStub(result: removeCoursePublisher)
        let completeCourseUseCase = MarkCourseCompleteUseCaseStub(result: completeCoursePublisher)
        let courseDetail = CourseDetailModel(
            ident: "ident",
            name: "name",
            description: "desc",
            lecturers: [],
            lessons: [],
            credits: 4
        )
        
        let sut = CourseDetailViewModel(
            removeCourseFromStudiedUseCase: removeCourseUseCase,
            markCourseCompleteUseCase: completeCourseUseCase,
            courseDetail: courseDetail
        )
        
        let expectation = expectation(description: "Should remove the course.")
        
        sut.goBackTap
            .sink(receiveValue: { expectation.fulfill() })
            .store(in: &bag)
        
        sut.removeCourseTap.send("ident")
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_remove_course_failure() {
        let completeCoursePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let removeCoursePublisher = Fail<Void, StudentRepositoryError>(error: .databaseError(nil))
            .eraseToAnyPublisher()
        let removeCourseUseCase = RemoveCourseFromStudiedUseCaseStub(result: removeCoursePublisher)
        let completeCourseUseCase = MarkCourseCompleteUseCaseStub(result: completeCoursePublisher)
        let courseDetail = CourseDetailModel(
            ident: "ident",
            name: "name",
            description: "desc",
            lecturers: [],
            lessons: [],
            credits: 4
        )
        
        let sut = CourseDetailViewModel(
            removeCourseFromStudiedUseCase: removeCourseUseCase,
            markCourseCompleteUseCase: completeCourseUseCase,
            courseDetail: courseDetail
        )
        
        let expectation = expectation(description: "Should propagate the error result.")
        
        sut.$errorMessage
            .dropFirst()
            .sink(receiveValue: { _ in expectation.fulfill() })
            .store(in: &bag)
        
        sut.removeCourseTap.send("ident")
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_mark_course_complete_success() {
        let completeCoursePublisher = Just(())
            .setFailureType(to: StudentRepositoryError.self)
            .eraseToAnyPublisher()
        let removeCoursePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let removeCourseUseCase = RemoveCourseFromStudiedUseCaseStub(result: removeCoursePublisher)
        let completeCourseUseCase = MarkCourseCompleteUseCaseStub(result: completeCoursePublisher)
        let courseDetail = CourseDetailModel(
            ident: "ident",
            name: "name",
            description: "desc",
            lecturers: [],
            lessons: [],
            credits: 4
        )
        
        let sut = CourseDetailViewModel(
            removeCourseFromStudiedUseCase: removeCourseUseCase,
            markCourseCompleteUseCase: completeCourseUseCase,
            courseDetail: courseDetail
        )
        
        let expectation = expectation(description: "Should mark the course complete.")
        
        sut.goBackTap
            .sink(receiveValue: { expectation.fulfill() })
            .store(in: &bag)
        
        sut.markCourseCompleteTap.send("ident")
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_mark_course_complete_failure() {
        let completeCoursePublisher = Fail<Void, StudentRepositoryError>(error: .databaseError(nil))
            .eraseToAnyPublisher()
        let removeCoursePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let removeCourseUseCase = RemoveCourseFromStudiedUseCaseStub(result: removeCoursePublisher)
        let completeCourseUseCase = MarkCourseCompleteUseCaseStub(result: completeCoursePublisher)
        let courseDetail = CourseDetailModel(
            ident: "ident",
            name: "name",
            description: "desc",
            lecturers: [],
            lessons: [],
            credits: 4
        )
        
        let sut = CourseDetailViewModel(
            removeCourseFromStudiedUseCase: removeCourseUseCase,
            markCourseCompleteUseCase: completeCourseUseCase,
            courseDetail: courseDetail
        )
        
        let expectation = expectation(description: "Should propagate the error result.")
        
        sut.$errorMessage
            .dropFirst()
            .sink(receiveValue: { _ in expectation.fulfill() })
            .store(in: &bag)
        
        sut.markCourseCompleteTap.send("ident")
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_back_tap_handled() {
        let completeCoursePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let removeCoursePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let removeCourseUseCase = RemoveCourseFromStudiedUseCaseStub(result: removeCoursePublisher)
        let completeCourseUseCase = MarkCourseCompleteUseCaseStub(result: completeCoursePublisher)
        let courseDetail = CourseDetailModel(
            ident: "ident",
            name: "name",
            description: "desc",
            lecturers: [],
            lessons: [],
            credits: 4
        )
        
        let sut = CourseDetailViewModel(
            removeCourseFromStudiedUseCase: removeCourseUseCase,
            markCourseCompleteUseCase: completeCourseUseCase,
            courseDetail: courseDetail
        )
        
        let expectation = expectation(description: "Back tap should be handled.")
        
        sut.goBackTap
            .sink(receiveValue: { _ in expectation.fulfill() })
            .store(in: &bag)
        
        sut.goBackSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
