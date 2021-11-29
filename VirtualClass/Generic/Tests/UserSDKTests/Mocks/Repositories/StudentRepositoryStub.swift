//
//  StudentRepositoryStub.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
import Foundation
@testable import UserSDK

final class StudentRepositoryStub: StudentRepositoryType {

    struct ResultBundle {
        let createResult: AnyPublisher<Void, StudentRepositoryError>
        let updateResult: AnyPublisher<Void, StudentRepositoryError>
        let loadStudentResult: AnyPublisher<GenericStudent?, StudentRepositoryError>
        let loadStudentsResult: AnyPublisher<[GenericStudent], StudentRepositoryError>
        let removeCourseResult: AnyPublisher<Void, StudentRepositoryError>
        let markCompleteResult: AnyPublisher<Void, StudentRepositoryError>
        let addCourseResult: AnyPublisher<Void, StudentRepositoryError>
        let activeCoursesResult: AnyPublisher<Set<GenericCourse>, StudentRepositoryError>
        
        static func mock(
            createResult: AnyPublisher<Void, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            updateResult: AnyPublisher<Void, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            loadStudentResult: AnyPublisher<GenericStudent?, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            loadStudentsResult: AnyPublisher<[GenericStudent], StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            removeCourseResult: AnyPublisher<Void, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            markCompleteResult: AnyPublisher<Void, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            addCourseResult: AnyPublisher<Void, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            activeCoursesResult: AnyPublisher<Set<GenericCourse>, StudentRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher()
        ) -> ResultBundle {
            .init(
                createResult: createResult,
                updateResult: updateResult,
                loadStudentResult: loadStudentResult,
                loadStudentsResult: loadStudentsResult,
                removeCourseResult: removeCourseResult,
                markCompleteResult: markCompleteResult,
                addCourseResult: addCourseResult,
                activeCoursesResult: activeCoursesResult
            )
        }
    }
    
    private let results: ResultBundle
    
    init(results: ResultBundle) {
        self.results = results
    }
    
    func create(name: String, email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        results.createResult
    }
    
    func update(_ user: GenericUserProfile) -> AnyPublisher<Void, StudentRepositoryError> {
        results.updateResult
    }
    
    func load(userWithID id: UUID) -> AnyPublisher<GenericStudent?, StudentRepositoryError> {
        results.loadStudentResult
    }
    
    func load(userWithEmail email: String) -> AnyPublisher<GenericStudent?, StudentRepositoryError> {
        results.loadStudentResult
    }
    
    func loadAll() -> AnyPublisher<[GenericStudent], StudentRepositoryError> {
        results.loadStudentsResult
    }
    
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        results.removeCourseResult
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        results.markCompleteResult
    }
    
    func activeCourses() -> AnyPublisher<Set<GenericCourse>, StudentRepositoryError> {
        results.activeCoursesResult
    }
    
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        results.addCourseResult
    }
}
