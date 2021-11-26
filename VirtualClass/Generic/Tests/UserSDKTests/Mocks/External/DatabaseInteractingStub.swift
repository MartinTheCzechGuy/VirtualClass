//
//  DatabaseInteractingStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Database
import Foundation

@testable import UserSDK

final class DatabaseInteractingStub {
    struct ResultBundle {
        let createResult: AnyPublisher<Void, DatabaseError>
        let createOrUpdateResult: Result<Void, DatabaseError>
        let updateResult: AnyPublisher<Void, DatabaseError>
        let loadByIdResult: AnyPublisher<Student?, DatabaseError>
        let loadByEmailResult: AnyPublisher<Student?, DatabaseError>
        let loadStudentsResult: AnyPublisher<[Student], DatabaseError>
        let loadCoursesResult: AnyPublisher<Set<Course>, DatabaseError>
        let deleteResult: AnyPublisher<Void, DatabaseError>
        let removeCourseResult: AnyPublisher<Void, DatabaseError>
        let markCompleteResult: AnyPublisher<Void, DatabaseError>
        let addCoursesAmongActiveResult: AnyPublisher<Void, DatabaseError>
        
        static func mock(
            createResult: AnyPublisher<Void, DatabaseError>,
            createOrUpdateResult: Result<Void, DatabaseError>,
            updateResult: AnyPublisher<Void, DatabaseError>,
            loadByIdResult: AnyPublisher<Student?, DatabaseError>,
            loadByEmailResult: AnyPublisher<Student?, DatabaseError>,
            loadStudentsResult: AnyPublisher<[Student], DatabaseError>,
            loadCoursesResult: AnyPublisher<Set<Course>, DatabaseError>,
            deleteResult: AnyPublisher<Void, DatabaseError>,
            removeCourseResult: AnyPublisher<Void, DatabaseError>,
            markCompleteResult: AnyPublisher<Void, DatabaseError>,
            addCoursesAmongActiveResult: AnyPublisher<Void, DatabaseError>
        ) -> ResultBundle {
            .init(
                createResult: createResult,
                createOrUpdateResult: createOrUpdateResult,
                updateResult: updateResult,
                loadByIdResult: loadByIdResult,
                loadByEmailResult: loadByEmailResult,
                loadStudentsResult: loadStudentsResult,
                loadCoursesResult: loadCoursesResult,
                deleteResult: deleteResult,
                removeCourseResult: removeCourseResult,
                markCompleteResult: markCompleteResult,
                addCoursesAmongActiveResult: addCoursesAmongActiveResult
            )
        }
    }
    
    private let results: ResultBundle
    
    init(results: ResultBundle) {
        self.results = results
    }
}

extension DatabaseInteractingStub: DatabaseInteracting {
    func create(domainModel: Student) -> AnyPublisher<Void, DatabaseError> {
        results.createResult
    }
    
    func createOrUpdate(domainModel: Student) -> Result<Void, DatabaseError> {
        results.createOrUpdateResult
    }
    
    func update(_ domainModel: Student) -> AnyPublisher<Void, DatabaseError> {
        results.updateResult
    }
    
    func load(withID id: UUID) -> AnyPublisher<Student?, DatabaseError> {
        results.loadByIdResult
    }
    
    func load(withEmail email: String) -> AnyPublisher<Student?, DatabaseError> {
        results.loadByEmailResult
    }
    
    func loadStudents() -> AnyPublisher<[Student], DatabaseError> {
        results.loadStudentsResult
    }
    
    func loadCourses() -> AnyPublisher<Set<Course>, DatabaseError> {
        results.loadCoursesResult
    }
    
    func delete(studentWithID id: UUID) -> AnyPublisher<Void, DatabaseError> {
        results.deleteResult
    }
    
    func removeCourse(forUserWithEmail email: String, courseIdent ident: String) -> AnyPublisher<Void, DatabaseError> {
        results.removeCourseResult
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, DatabaseError> {
        results.markCompleteResult
    }
    
    func addCoursesAmongActive(idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, DatabaseError> {
        results.addCoursesAmongActiveResult
    }
}
