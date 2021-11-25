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
        let createResult: AnyPublisher<Void, UserRepositoryError>
        let updateResult: AnyPublisher<Void, UserRepositoryError>
        let loadStudentResult: AnyPublisher<GenericStudent?, UserRepositoryError>
        let loadStudentsResult: AnyPublisher<[GenericStudent], UserRepositoryError>
        let removeCourseResult: AnyPublisher<Void, UserRepositoryError>
        let markCompleteResult: AnyPublisher<Void, UserRepositoryError>
        let addCourseResult: AnyPublisher<Void, UserRepositoryError>
        let activeCoursesResult: AnyPublisher<Set<GenericCourse>, UserRepositoryError>
        
        static func mock(
            createResult: AnyPublisher<Void, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            updateResult: AnyPublisher<Void, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            loadStudentResult: AnyPublisher<GenericStudent?, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            loadStudentsResult: AnyPublisher<[GenericStudent], UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            removeCourseResult: AnyPublisher<Void, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            markCompleteResult: AnyPublisher<Void, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            addCourseResult: AnyPublisher<Void, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher(),
            activeCoursesResult: AnyPublisher<Set<GenericCourse>, UserRepositoryError> = Empty(completeImmediately: false).eraseToAnyPublisher()
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
    
    func create(name: String, email: String) -> AnyPublisher<Void, UserRepositoryError> {
        results.createResult
    }
    
    func update(_ user: GenericStudent) -> AnyPublisher<Void, UserRepositoryError> {
        results.updateResult
    }
    
    func load(userWithID id: UUID) -> AnyPublisher<GenericStudent?, UserRepositoryError> {
        results.loadStudentResult
    }
    
    func load(userWithEmail email: String) -> AnyPublisher<GenericStudent?, UserRepositoryError> {
        results.loadStudentResult
    }
    
    func loadAll() -> AnyPublisher<[GenericStudent], UserRepositoryError> {
        results.loadStudentsResult
    }
    
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError> {
        results.removeCourseResult
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError> {
        results.markCompleteResult
    }
    
    func activeCourses() -> AnyPublisher<Set<GenericCourse>, UserRepositoryError> {
        results.activeCoursesResult
    }
    
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError> {
        results.addCourseResult
    }
}
