//
//  StudentRepository.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Combine
import Database
import Foundation
import SwiftUI

public enum StudentRepositoryError: Error {
    case storageError(Error?)
    case databaseError(Error?)
}

final class StudentRepository {
    
    private let database: StudentDBRepositoryType
    
    init(database: StudentDBRepositoryType) {
        self.database = database
    }
}

extension StudentRepository: StudentRepositoryType {
    
    func create(name: String, email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        database.create(domainModel: Student(id: UUID(), name: name, email: email, activeCourses: [], completedCourses: []))
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func update(_ user: GenericUserProfile) -> AnyPublisher<Void, StudentRepositoryError> {
        database.update(
            UserProfile(
                id: user.id,
                name: user.name,
                email: user.email
            )
        )
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func load(userWithID id: UUID) -> AnyPublisher<GenericStudent?, StudentRepositoryError> {
        database.load(withID: id)
            .map(mapToDomain(student:))
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func load(userWithEmail email: String) -> AnyPublisher<GenericStudent?, StudentRepositoryError> {
        database.load(withEmail: email)
            .map(mapToDomain(student:))
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func loadAll() -> AnyPublisher<[GenericStudent], StudentRepositoryError> {
        database.loadStudents()
            .mapOptionalElement(mapToDomain(student:))
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        database.removeCourse(forUserWithEmail: email, courseIdent: ident)
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        database.markComplete(courseIdent: ident, forUserWithEmail: email)
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func activeCourses() -> AnyPublisher<Set<GenericCourse>, StudentRepositoryError> {
        database.loadCourses()
            .map(mapToDomain(courses:))
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError> {
        database.addCoursesAmongActive(idents: idents, forStudentWithEmail: email)
            .mapError(StudentRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
}

// MARK: - Helper mappers

extension StudentRepositoryType {
    func mapToDomain(student: Student?) -> GenericStudent? {
        guard let domainModel = student else {
            return nil
        }
        
        var activeCourses = Set<GenericCourse>()
        
        domainModel.activeCourses.forEach {
            var teachers: Set<GenericTeacher> = []
            
            $0.teachers.forEach { externalTeacher in
                teachers.insert(
                    GenericTeacher(
                        id: externalTeacher.id,
                        name: externalTeacher.name
                    )
                )
            }
            
            var faculty: GenericFaculty
            switch $0.faculty {
            case .facultyOfEconomics:
                faculty = .facultyOfEconomics
            case .facultyOfInformatics:
                faculty = .facultyOfInformatics
            case .facultyOfAccounting:
                faculty = .facultyOfAccounting
            case .facultyOfManagement:
                faculty = .facultyOfManagement
            }
            
            activeCourses.insert(
                GenericCourse(
                    ident: $0.id,
                    name: $0.name,
                    description: $0.description,
                    credits: $0.credits,
                    lessons: $0.lessons,
                    classRoom: GenericClassRoom(id: $0.classRoom.id, name: $0.classRoom.name),
                    faculty: faculty,
                    teachers: teachers
                )
            )
        }
        
        var completedCourses = Set<GenericCourse>()
        
        domainModel.completedCourses.forEach {
            var teachers: Set<GenericTeacher> = []
            
            var faculty: GenericFaculty
            switch $0.faculty {
            case .facultyOfEconomics:
                faculty = .facultyOfEconomics
            case .facultyOfInformatics:
                faculty = .facultyOfInformatics
            case .facultyOfAccounting:
                faculty = .facultyOfAccounting
            case .facultyOfManagement:
                faculty = .facultyOfManagement
            }
            
            $0.teachers.forEach { externalTeacher in
                teachers.insert(
                    GenericTeacher(
                        id: externalTeacher.id,
                        name: externalTeacher.name
                    )
                )
            }
            
            completedCourses.insert(
                GenericCourse(
                    ident: $0.id,
                    name: $0.name,
                    description: $0.description,
                    credits: $0.credits,
                    lessons: $0.lessons,
                    classRoom: GenericClassRoom(id: $0.classRoom.id, name: $0.classRoom.name),
                    faculty: faculty,
                    teachers: teachers
                )
            )
        }
        
        return GenericStudent(
            id: domainModel.id,
            name: domainModel.name,
            email: domainModel.email,
            activeCourses: activeCourses,
            completedCourses: completedCourses
        )
    }
    
    func mapToDomain(courses entities: Set<Course>) -> Set<GenericCourse> {
        var result: Set<GenericCourse> = []
        
        entities.forEach { course in
            var faculty: GenericFaculty
            switch course.faculty {
            case .facultyOfEconomics:
                faculty = .facultyOfEconomics
            case .facultyOfInformatics:
                faculty = .facultyOfInformatics
            case .facultyOfAccounting:
                faculty = .facultyOfAccounting
            case .facultyOfManagement:
                faculty = .facultyOfManagement
            }
            
            var teachers = Set<GenericTeacher>()
            
            course.teachers.forEach {
                teachers.insert(
                    GenericTeacher(id: $0.id, name: $0.name)
                )
            }
            
            result.insert (
                GenericCourse(
                    ident: course.ident,
                    name: course.name,
                    description: course.description,
                    credits: course.credits,
                    lessons: course.lessons,
                    classRoom: GenericClassRoom(id: course.classRoom.id, name: course.classRoom.name),
                    faculty: faculty,
                    teachers: teachers
                )
            )
        }
        
        return result
    }
}
