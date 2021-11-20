//
//  StudentRepository.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import BasicLocalStorage
import Combine
import Database
import Foundation
import SecureStorage
import SwiftUI

public enum UserRepositoryError: Error {
    case storageError(Error?)
    case databaseError(Error?)
}

final class StudentRepository {
    
    private let database: StudentDBRepositoryType
    private let keyValueLocalStorage: LocalKeyValueStorage
    private let secureStorage: SecureStorage
    
    init(
        database: StudentDBRepositoryType,
        keyValueLocalStorage: LocalKeyValueStorage,
        secureStorage: SecureStorage
    ) {
        self.database = database
        self.keyValueLocalStorage = keyValueLocalStorage
        self.secureStorage = secureStorage
    }
}

extension StudentRepository: StudentRepositoryType {
    
    func create(name: String, email: String) -> Result<Void, UserRepositoryError> {
        database.create(domainModel: Student(id: UUID(), name: name, email: email, activeCourses: [], completedCourses: []))
            .mapError(UserRepositoryError.databaseError)
    }
    
    func update(_ user: GenericStudent) -> Result<Void, UserRepositoryError> {
        var courses = Set<Course>()
        user.activeCourses.forEach { courses.insert(
            Course(
                ident: $0.ident,
                name: $0.name,
                description: $0.description,
                credits: $0.credits,
                lessons: [],
                classRoom: .init(id: UUID(), name: "tada"),
                faculty: .facultyOne,
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
                faculty: .facultyOne,
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
    }
    
    func load(userWithID id: UUID) -> Result<GenericStudent?, UserRepositoryError> {
        database.load(withID: id)
            .mapUserToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func load(userWithEmail email: String) -> Result<GenericStudent?, UserRepositoryError> {
        database.load(withEmail: email)
            .mapUserToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func loadAll() -> Result<[GenericStudent], UserRepositoryError> {
        database.loadAll()
            .mapUsersToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func takenEmails() -> Result<[String], UserRepositoryError> {
        database.loadAll()
            .mapError(UserRepositoryError.databaseError)
            .map { usersArray -> [String] in
                usersArray.map { $0.email }
            }
    }
    
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> Result<Void, UserRepositoryError> {
        database.removeCourse(forUserWithEmail: email, courseIdent: ident)
            .mapError(UserRepositoryError.databaseError)
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> Result<Void, UserRepositoryError> {
        database.markComplete(courseIdent: ident, forUserWithEmail: email)
            .mapError(UserRepositoryError.databaseError)
    }
    
    func activeCourses() -> Result<Set<GenericCourse>, UserRepositoryError> {
        database.loadAll()
            .mapToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> Result<Void, UserRepositoryError> {
        database.addCoursesAmongActive(idents: idents, forStudentWithEmail: email)
            .mapError(UserRepositoryError.databaseError)
    }
}

extension Result where Success == Student? {
    func mapUserToDomain() -> Result<GenericStudent?, Failure> {
        map { domainModel in
            guard let domainModel = domainModel else {
                return nil
            }
            
            var activeCourses = Set<GenericCourse>()
            
            domainModel.activeCourses.forEach {
                var teachers: Set<GenericTeacher> = []
                
                $0.teachers.forEach { externalTeacher in
                    teachers.insert(
                        GenericTeacher(
                            id: externalTeacher.id,
                            name: externalTeacher.name,
                            email: externalTeacher.email
                        )
                    )
                }
                
                activeCourses.insert(
                    GenericCourse(
                        ident: $0.id,
                        name: $0.name,
                        description: $0.description,
                        credits: $0.credits,
                        lessons: $0.lessons,
                        classRoom: GenericClassRoom(id: $0.classRoom.id, name: $0.classRoom.name),
                        faculty: $0.faculty == .facultyOne ? .facultyOne : .facultyTwo,
                        teachers: teachers
                    )
                )
            }
            
            var completedCourses = Set<GenericCourse>()
            
            domainModel.completedCourses.forEach {
                var teachers: Set<GenericTeacher> = []
                
                $0.teachers.forEach { externalTeacher in
                    teachers.insert(
                        GenericTeacher(
                            id: externalTeacher.id,
                            name: externalTeacher.name,
                            email: externalTeacher.email
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
                        faculty: $0.faculty == .facultyOne ? .facultyOne : .facultyTwo,
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
                        GenericTeacher(id: $0.id, name: $0.name, email: $0.email)
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
                        faculty: $0.faculty == .facultyOne ? .facultyOne : .facultyTwo,
                        teachers: teachers
                    )
                )
            }
            
            return courses
        }
    }
}
