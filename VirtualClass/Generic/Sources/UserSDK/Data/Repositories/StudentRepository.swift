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

public enum UserRepositoryError: Error {
    case storageError(Error?)
    case databaseError(Error?)
}

final class StudentRepository {
    
    private let database: DatabaseInteracting
    
    init(database: DatabaseInteracting) {
        self.database = database
    }
}

extension StudentRepository: StudentRepositoryType {
    
    func create(name: String, email: String) -> AnyPublisher<Void, UserRepositoryError> {
        database.create(domainModel: Student(id: UUID(), name: name, email: email, activeCourses: [], completedCourses: []))
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func update(_ user: GenericStudent) -> AnyPublisher<Void, UserRepositoryError> {
        var courses = Set<Course>()
        
#warning("TODO 😉 - proč je tady nějaký custom mapování")
        
        user.activeCourses.forEach { courses.insert(
            Course(
                ident: $0.ident,
                name: $0.name,
                description: $0.description,
                credits: $0.credits,
                lessons: [],
                classRoom: .init(id: UUID(), name: "tada"),
                faculty: .facultyOfEconomics,
                teachers: [],
                students: []
            )
        )
        }
        
        var completedCourses = Set<Course>()
        user.completedCourses.forEach { completedCourses.insert(
            Course(
                ident: $0.ident,
                name: $0.name,
                description: $0.description,
                credits: $0.credits,
                lessons: [],
                classRoom: .init(id: UUID(), name: "tada"),
                faculty: .facultyOfEconomics,
                teachers: [],
                students: []
            )
        )
        }
        
        return database.update(
            Student(
                id: user.id,
                name: user.name,
                email: user.email,
                activeCourses: courses,
                completedCourses: completedCourses
            )
        )
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func load(userWithID id: UUID) -> AnyPublisher<GenericStudent?, UserRepositoryError> {
        database.load(withID: id)
            .mapToDomain()
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func load(userWithEmail email: String) -> AnyPublisher<GenericStudent?, UserRepositoryError> {
        database.load(withEmail: email)
            .mapToDomain()
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func loadAll() -> AnyPublisher<[GenericStudent], UserRepositoryError> {
        database.loadStudents()
            .mapToDomain()
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError> {
        database.removeCourse(forUserWithEmail: email, courseIdent: ident)
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError> {
        database.markComplete(courseIdent: ident, forUserWithEmail: email)
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func activeCourses() -> AnyPublisher<Set<GenericCourse>, UserRepositoryError> {
        database.loadCourses()
            .mapToDomain()
            .map { Set($0) }
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
    
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError> {
        database.addCoursesAmongActive(idents: idents, forStudentWithEmail: email)
            .mapError(UserRepositoryError.databaseError)
            .eraseToAnyPublisher()
    }
}

#warning("TODO 😉 - tady udělej pořádek pro kristovy rány")

public func mapToDomainnn(student: Student?) -> GenericStudent? {
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

extension Result where Success == Student? {
    func mapUserToDomain() -> Result<GenericStudent?, Failure> {
        map(mapToDomainnn(student:))
    }
}

extension Publisher where Output == Student? {
    func mapToDomain() -> AnyPublisher<GenericStudent?, Failure> {
        map(mapToDomainnn(student:))
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == [Student] {
    func mapToDomain() -> AnyPublisher<[GenericStudent], Failure> {
        mapOptionalElement(mapToDomainnn(student:))
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Set<Course> {
    func mapToDomain() -> AnyPublisher<[GenericCourse], Failure> {
        mapOptionalElement { course in
            
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
            
            return GenericCourse(
                ident: course.ident,
                name: course.name,
                description: course.description,
                credits: course.credits,
                lessons: course.lessons,
                classRoom: GenericClassRoom(id: course.classRoom.id, name: course.classRoom.name),
                faculty: faculty,
                teachers: teachers
            )
        }
        .eraseToAnyPublisher()
    }
}


extension Result where Success == [Student] {
    func mapUsersToDomain() -> Result<[GenericStudent], Failure> {
        map {
            $0.map { domainModel in
                var courses = Set<GenericCourse>()
                //                $0.classes.forEach { classes.insert(Class(id: $0.id, name: $0.name)) }
                
                return GenericStudent(
                    id: domainModel.id,
                    name: domainModel.name,
                    email: domainModel.email,
                    activeCourses: [],
                    completedCourses: []
                )
            }
        }
    }
}

extension Result where Success == Set<Course> {
    func mapToDomain() -> Result<Set<GenericCourse>, Failure> {
        map { externalCourses in
            var courses = Set<GenericCourse>()
            
            externalCourses.forEach {
                var teachers = Set<GenericTeacher>()
                
                $0.teachers.forEach {
                    teachers.insert(
                        GenericTeacher(id: $0.id, name: $0.name)
                    )
                }
                
                courses.insert(
                    GenericCourse(
                        ident: $0.ident,
                        name: $0.name,
                        description: $0.description,
                        credits: $0.credits,
                        lessons: $0.lessons,
                        classRoom: GenericClassRoom(id: $0.classRoom.id, name: $0.classRoom.name),
                        faculty: .facultyOfEconomics,
                        teachers: teachers
                    )
                )
            }
            
            return courses
        }
    }
}
