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
                try CoursesStudiedBy(
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
    
    func createOrUpdate(domainModel: Student) -> Result<Void, DatabaseError> {
        .success(())
    }
    
    func update(_ domainModel: Student) -> AnyPublisher<Void, DatabaseError> {
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
        databaseConnection!.readPublisher { db -> StudentWithCoursesEntity? in
            let request = StudentEntity
                .filter(id: id)
                .including(required: StudentEntity.activecourses)
                .including(
                    required: StudentEntity.completedCourses
                        .including(required: CourseEntity.faculty)
                        .including(required: CourseEntity.classRoom)
                        .including(required: CourseEntity.teachers)
                        .including(required: CourseEntity.students)
                )
            
            return try StudentWithCoursesEntity.fetchOne(db, request)
        }
        .tryMap { [weak self] entity in
            guard let self = self, let entity = entity else {
                throw DatabaseError(cause: .objectConversionError, underlyingError: nil)
            }
            
            return Student(
                id: entity.student.id,
                name: entity.student.name,
                email: entity.student.email,
                activeCourses: self.mapToDomain(entity.activeCourses),
                completedCourses: self.mapToDomain(entity.completedCourses)
            )
        }
        .mapError { DatabaseError(cause: .savingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func load(withEmail email: String) -> AnyPublisher<Student?, DatabaseError> {
        databaseConnection!.readPublisher { db -> StudentWithCoursesEntity? in
            let request = StudentEntity
                .filter(Column("email") == email)
                .including(required: StudentEntity.activecourses)
                .including(
                    required: StudentEntity.completedCourses
                        .including(required: CourseEntity.faculty)
                        .including(required: CourseEntity.classRoom)
                        .including(required: CourseEntity.teachers)
                        .including(required: CourseEntity.students)
                )
            
            return try StudentWithCoursesEntity.fetchOne(db, request)
        }
        .tryMap { [weak self] entity in
            guard let self = self, let entity = entity else {
                throw DatabaseError(cause: .objectConversionError, underlyingError: nil)
            }
            
            return Student(
                id: entity.student.id,
                name: entity.student.name,
                email: entity.student.email,
                activeCourses: self.mapToDomain(entity.activeCourses),
                completedCourses: self.mapToDomain(entity.completedCourses)
            )
        }
        .mapError { DatabaseError(cause: .savingEntityError, underlyingError: $0) }
        .eraseToAnyPublisher()
    }
    
    func loadStudents() -> AnyPublisher<[Student], DatabaseError> {
        databaseConnection!.readPublisher { db -> [StudentWithCoursesEntity] in
            let request = StudentEntity
                .including(required: StudentEntity.activecourses)
                .including(
                    required: StudentEntity.completedCourses
                        .including(required: CourseEntity.faculty)
                        .including(required: CourseEntity.classRoom)
                        .including(required: CourseEntity.teachers)
                        .including(required: CourseEntity.students)
                )
            
            return try StudentWithCoursesEntity.fetchAll(db, request)
        }
        .mapElement { entity in
            Student(
                id: entity.student.id,
                name: entity.student.name,
                email: entity.student.email,
                activeCourses: self.mapToDomain(entity.activeCourses),
                completedCourses: self.mapToDomain(entity.completedCourses)
            )
        }
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
