//
//  CourseDBRepository.swift
//
//
//  Created by Martin on 15.11.2021.
//

import Combine
import Foundation
import GRDB

final class CourseDBRepository {
    private var databaseConnection: DatabasePool?
    
    private let dbManager: SQLDBManaging
    
    private let classRoomConverter: ClassRoomConverter
    private let teacherConverter: TeacherConverter
    
    init(
        dbManager: SQLDBManaging,
        classRoomConverter: ClassRoomConverter,
        teacherConverter: TeacherConverter
    ) {
        self.dbManager = dbManager
        self.classRoomConverter = classRoomConverter
        self.teacherConverter = teacherConverter
        
        dbManager.databasePool(setup: SQLDBSetup()) { result in
            switch result {
            case .success(let databasePool):
                self.databaseConnection = databasePool
            case .failure(let error):
                fatalError("Failed to initialize the database: \(error)")
            }
        }
    }
}

extension CourseDBRepository: DatabaseInteracting {
    
    // MARK: - Create
    
    func create(domainModel: Student) -> AnyPublisher<Void, DatabaseError> {
        databaseConnection!.writePublisher { db in
            try StudentEntity(id: domainModel.id, name: domainModel.name, email: domainModel.email).save(db)
                        
            try domainModel.activeCourses.forEach {
                try CoursesStudiedBy(
                    id: UUID(),
                    courseIdent: $0.ident,
                    studentId: domainModel.id
                )
                    .save(db)
            }
            
            try domainModel.completedCourses.forEach {
                try CoursesCompletedBy(
                    id: UUID(),
                    courseIdent: $0.ident,
                    studentId: domainModel.id
                )
                    .save(db)
            }
            
            return ()
        }
        .mapError { DatabaseError(cause: .savingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Update
    
    func update(_ domainModel: UserProfile) -> AnyPublisher<Void, DatabaseError> {
        databaseConnection!.writePublisher { db -> Void in
            guard var entity = try? StudentEntity.filter(id: domainModel.id).fetchOne(db) else {
                throw DatabaseError(cause: .loadingEntityError, underlyingError: nil)
            }
            
            entity.name = domainModel.name
            entity.email = domainModel.email
            
            return try entity.update(db)
        }
        .mapError { DatabaseError(cause: .updatingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func removeCourse(forUserWithEmail email: String, courseIdent ident: String) -> AnyPublisher<Void, DatabaseError> {
        databaseConnection!.writePublisher { db -> Int in
            let student = StudentEntity
                .filter(Column(StudentTableRow.email) == email)
                .selectID()
            
            guard let studentId = try? student.fetchOne(db) else {
                throw DatabaseError(cause: .loadingEntityError, underlyingError: nil)
            }
            
            return try CoursesStudiedBy
                .filter(Column(CoursesStudiedByTableRow.courseId) == ident && Column(CoursesStudiedByTableRow.studentId) == studentId)
                .deleteAll(db)
        }
        .map { _ in return }
        .mapError { DatabaseError(cause: .updatingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, DatabaseError> {
        databaseConnection!.writePublisher { db -> CoursesCompletedBy in
            let student = StudentEntity
                .filter(Column(StudentTableRow.email) == email)
                .selectID()
            
            guard let studentId = try? student.fetchOne(db) else {
                throw DatabaseError(cause: .loadingEntityError, underlyingError: nil)
            }
            
            try CoursesStudiedBy
                .filter(Column(CoursesStudiedByTableRow.courseId) == ident && Column(CoursesStudiedByTableRow.studentId) == studentId)
                .deleteAll(db)
            
            return try CoursesCompletedBy(id: UUID(), courseIdent: ident, studentId: studentId).inserted(db)
        }
        .map { _ in return }
        .mapError { DatabaseError(cause: .updatingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
        
    }
    
    func addCoursesAmongActive(idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, DatabaseError> {
        databaseConnection!.writePublisher { db -> Void in
            let student = StudentEntity
                .filter(Column(StudentTableRow.email) == email)
                .selectID()
            
            guard let studentId = try? student.fetchOne(db) else {
                throw DatabaseError(cause: .loadingEntityError, underlyingError: nil)
            }
            
            try idents.forEach { try CoursesStudiedBy(id: UUID(), courseIdent: $0, studentId: studentId).insert(db) }
            
            return ()
        }
        .mapError { DatabaseError(cause: .updatingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Read
    
    func load(withID id: UUID) -> AnyPublisher<Student?, DatabaseError> {
        databaseConnection!.readPublisher { db -> CompleteStudentEntity? in
            guard let student = try StudentWithCoursesEntity.with(id: id)
                    .fetchOne(db) else {
                        throw DatabaseError(cause: .deletingEntityError)
                    }
            
            let activeCourses = try student
                .activeCourses
                .map(\.ident)
                .compactMap {
                    try CompleteCourseEntity.with(ident: $0).fetchOne(db)
                }
            
            let completedCourses = try student
                .completedCourses
                .map(\.ident)
                .compactMap {
                    try CompleteCourseEntity.with(ident: $0).fetchOne(db)
                }
            
            return CompleteStudentEntity(
                id: student.profile.id,
                name: student.profile.name,
                email: student.profile.email,
                activeCourses: activeCourses,
                completedCourses: completedCourses
            )
        }
        .tryMap { [weak self] entity in
            guard let self = self, let entity = entity else {
                throw DatabaseError(cause: .objectConversionError, underlyingError: nil)
            }
            
            return self.mapToDomain(entity)
        }
        .mapError { DatabaseError(cause: .savingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func load(withEmail email: String) -> AnyPublisher<Student?, DatabaseError> {
        databaseConnection!.readPublisher { db -> CompleteStudentEntity? in
            guard let student = try StudentWithCoursesEntity.with(email: email)
                    .fetchOne(db) else {
                        throw DatabaseError(cause: .deletingEntityError)
                    }
            
            let activeCourses = try student
                .activeCourses
                .map(\.ident)
                .compactMap {
                    try CompleteCourseEntity.with(ident: $0).fetchOne(db)
                }
            
            let completedCourses = try student
                .completedCourses
                .map(\.ident)
                .compactMap {
                    try CompleteCourseEntity.with(ident: $0).fetchOne(db)
                }
            
            return CompleteStudentEntity(
                id: student.profile.id,
                name: student.profile.name,
                email: student.profile.email,
                activeCourses: activeCourses,
                completedCourses: completedCourses
            )
        }
        .tryMap { [weak self] entity in
            guard let self = self, let entity = entity else {
                throw DatabaseError(cause: .objectConversionError, underlyingError: nil)
            }
            
            return self.mapToDomain(entity)
        }
        .mapError { DatabaseError(cause: .savingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func loadStudents() -> AnyPublisher<[Student], DatabaseError> {
        databaseConnection!.readPublisher { db -> [CompleteStudentEntity] in
            let students = try StudentWithCoursesEntity.all().fetchAll(db)
            
            return try students.map { student in
                let activeCourses = try student
                    .activeCourses
                    .map(\.ident)
                    .compactMap {
                        try CompleteCourseEntity.with(ident: $0).fetchOne(db)
                    }
                
                let completedCourses = try student
                    .completedCourses
                    .map(\.ident)
                    .compactMap {
                        try CompleteCourseEntity.with(ident: $0).fetchOne(db)
                    }
                
                return CompleteStudentEntity(
                    id: student.profile.id,
                    name: student.profile.name,
                    email: student.profile.email,
                    activeCourses: activeCourses,
                    completedCourses: completedCourses
                )
            }
        }
        .mapElement(mapToDomain)
        .mapError { DatabaseError(cause: .loadingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func loadCourses() -> AnyPublisher<Set<Course>, DatabaseError> {
        databaseConnection!.readPublisher { db -> [CompleteCourseEntity] in
            let request = CourseEntity
                .including(required: CourseEntity.faculty)
                .including(required: CourseEntity.classRoom)
                .including(required: CourseEntity.teachers)
                .including(required: CourseEntity.students)
            
            return try CompleteCourseEntity.fetchAll(db, request)
        }
        .map(mapToDomain(_:))
        .mapError { DatabaseError(cause: .loadingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Delete
    
    func delete(studentWithID id: UUID) -> AnyPublisher<Void, DatabaseError> {
        databaseConnection!.writePublisher { db in
            try StudentEntity
                .filter(id: id)
                .deleteAll(db)
        }
        .mapError { DatabaseError(cause: .deletingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
}

// MARK: - Helper mappers

extension CourseDBRepository {
    private func mapToDomain(_ entity: CompleteStudentEntity) -> Student {
        Student(
            id: entity.id,
            name: entity.name,
            email: entity.email,
            activeCourses: mapToDomain(entity.activeCourses),
            completedCourses: mapToDomain(entity.completedCourses)
        )
    }
    
    private func mapToDomain(_ entities: [CompleteCourseEntity]) -> Set<Course> {
        Set(
            entities.map { entity in
                
                var faculty: Faculty
                switch entity.faculty.name {
                case .facultyOfEconomics:
                    faculty = .facultyOfEconomics
                case .facultyOfInformatics:
                    faculty = .facultyOfInformatics
                case .facultyOfAccounting:
                    faculty = .facultyOfAccounting
                case .facultyOfManagement:
                    faculty = .facultyOfManagement
                }
                
                let classMates = entity.students.map {
                    ClassMate(name: $0.name, email: $0.email)
                }
                
                return Course(
                    ident: entity.course.ident,
                    name: entity.course.name,
                    description: entity.course.description,
                    credits: entity.course.credits,
                    lessons: Set(entity.course.lectures),
                    classRoom: classRoomConverter.mapToDomain(entity.classRoom),
                    faculty: faculty,
                    teachers: Set(entity.teachers.map(self.teacherConverter.mapToDomain)),
                    students: Set(classMates)
                )
            }
        )
    }
}
