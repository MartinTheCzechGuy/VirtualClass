//
//  StudentRepositoryTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK
import Database

final class StudentRepositoryTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_create_student_profile() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                createResult: Just(())
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have create new student")
        
        sut.create(name: "name", email: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_creating_student_profile() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                createResult: Fail<Void, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have received an error")

        sut.create(name: "name", email: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_update_student_profile() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                updateResult: Just(())
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let student = GenericUserProfile(
            id: UUID(),
            name: "",
            email: ""
        )
        
        let expectation = expectation(description: "Should have update the profile")
        
        sut.update(student)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_updating_student_profile() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                updateResult: Fail<Void, DatabaseError>(error: .init(cause: .deletingEntityError)).eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let student = GenericUserProfile(
            id: UUID(),
            name: "",
            email: ""
        )
        
        let expectation = expectation(description: "Should have received an error")
        
        sut.update(student)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_student_profile_by_id() {
        let student = Student(
            id: UUID(),
            name: "name",
            email: "email",
            activeCourses: [
                Course(
                    ident: "active ident",
                    name: "name",
                    description: "desc",
                    credits: 6,
                    lessons: [Date() + 20000],
                    classRoom: ClassRoom(id: UUID(), name: "class room 2"),
                    faculty: .facultyOfInformatics,
                    teachers: [
                        Teacher(id: UUID(), name: "teacher name")
                    ],
                    students: [
                        ClassMate(name: "class mate", email: "email")
                    ]
                )
            ],
            completedCourses: [
                Course(
                    ident: "completed ident",
                    name: "name",
                    description: "desc",
                    credits: 4,
                    lessons: [Date()],
                    classRoom: ClassRoom(id: UUID(), name: "class room"),
                    faculty: .facultyOfAccounting,
                    teachers: [
                        Teacher(id: UUID(), name: "another teacher")
                    ],
                    students: [
                        ClassMate(name: "class mate", email: "email")
                    ]
                )
            ]
        )
        
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadByIdResult: Just(student)
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
        
        let expectation = expectation(description: "Should have load the student profile")
        
        sut.load(userWithID: UUID())
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    
                    XCTFail()
                },
                receiveValue: { result in
                    guard let result = result else {
                        XCTFail()
                        
                        return
                    }
                    
                    XCTAssertEqual(result.id, student.id)
                    XCTAssertEqual(result.name, student.name)
                    XCTAssertEqual(result.email, student.email)
                    
                    XCTAssertEqual(result.activeCourses.count, student.activeCourses.count)
                    XCTAssertEqual(result.completedCourses.count, student.completedCourses.count)
                    
                    XCTAssertEqual(result.activeCourses.first?.ident, student.activeCourses.first?.ident)
                    XCTAssertEqual(result.activeCourses.first?.name, student.activeCourses.first?.name)
                    XCTAssertEqual(result.activeCourses.first?.description, student.activeCourses.first?.description)
                    XCTAssertEqual(result.activeCourses.first?.credits, student.activeCourses.first?.credits)
                    XCTAssertEqual(result.activeCourses.first?.lessons.first, student.activeCourses.first?.lessons.first)
                    XCTAssertEqual(result.activeCourses.first?.classRoom.id, student.activeCourses.first?.classRoom.id)
                    XCTAssertEqual(student.activeCourses.first?.faculty, .facultyOfInformatics)
                    XCTAssertEqual(result.activeCourses.first?.teachers.first?.id, student.activeCourses.first?.teachers.first?.id)
                    
                    XCTAssertEqual(result.completedCourses.first?.ident, student.completedCourses.first?.ident)
                    XCTAssertEqual(result.completedCourses.first?.name, student.completedCourses.first?.name)
                    XCTAssertEqual(result.completedCourses.first?.description, student.completedCourses.first?.description)
                    XCTAssertEqual(result.completedCourses.first?.credits, student.completedCourses.first?.credits)
                    XCTAssertEqual(result.completedCourses.first?.lessons.first, student.completedCourses.first?.lessons.first)
                    XCTAssertEqual(result.completedCourses.first?.classRoom.id, student.completedCourses.first?.classRoom.id)
                    XCTAssertEqual(student.completedCourses.first?.faculty, .facultyOfAccounting)
                    XCTAssertEqual(result.completedCourses.first?.teachers.first?.id, student.completedCourses.first?.teachers.first?.id)

                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_loading_student_profile() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadByIdResult: Fail<Student?, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
        
        let expectation = expectation(description: "Should have received an error")
        
        sut.load(userWithID: UUID())
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { student in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_student_profile_by_email() {
        let student = Student(
            id: UUID(),
            name: "name",
            email: "email",
            activeCourses: [
                Course(
                    ident: "active ident",
                    name: "name",
                    description: "desc",
                    credits: 6,
                    lessons: [Date() + 20000],
                    classRoom: ClassRoom(id: UUID(), name: "class room 2"),
                    faculty: .facultyOfInformatics,
                    teachers: [
                        Teacher(id: UUID(), name: "teacher name")
                    ],
                    students: [
                        ClassMate(name: "class mate", email: "email")
                    ]
                )
            ],
            completedCourses: [
                Course(
                    ident: "completed ident",
                    name: "name",
                    description: "desc",
                    credits: 4,
                    lessons: [Date()],
                    classRoom: ClassRoom(id: UUID(), name: "class room"),
                    faculty: .facultyOfAccounting,
                    teachers: [
                        Teacher(id: UUID(), name: "another teacher")
                    ],
                    students: [
                        ClassMate(name: "class mate", email: "email")
                    ]
                )
            ]
        )
        
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadByEmailResult: Just(student)
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
        
        let expectation = expectation(description: "Should have load the student profile")
        
        sut.load(userWithEmail: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    
                    XCTFail()
                },
                receiveValue: { result in
                    guard let result = result else {
                        XCTFail()
                        
                        return
                    }
                    
                    XCTAssertEqual(result.id, student.id)
                    XCTAssertEqual(result.name, student.name)
                    XCTAssertEqual(result.email, student.email)
                    
                    XCTAssertEqual(result.activeCourses.count, student.activeCourses.count)
                    XCTAssertEqual(result.completedCourses.count, student.completedCourses.count)
                    
                    XCTAssertEqual(result.activeCourses.first?.ident, student.activeCourses.first?.ident)
                    XCTAssertEqual(result.activeCourses.first?.name, student.activeCourses.first?.name)
                    XCTAssertEqual(result.activeCourses.first?.description, student.activeCourses.first?.description)
                    XCTAssertEqual(result.activeCourses.first?.credits, student.activeCourses.first?.credits)
                    XCTAssertEqual(result.activeCourses.first?.lessons.first, student.activeCourses.first?.lessons.first)
                    XCTAssertEqual(result.activeCourses.first?.classRoom.id, student.activeCourses.first?.classRoom.id)
                    XCTAssertEqual(result.activeCourses.first?.faculty, .facultyOfInformatics)
                    XCTAssertEqual(result.activeCourses.first?.teachers.first?.id, student.activeCourses.first?.teachers.first?.id)
                    
                    XCTAssertEqual(result.completedCourses.first?.ident, student.completedCourses.first?.ident)
                    XCTAssertEqual(result.completedCourses.first?.name, student.completedCourses.first?.name)
                    XCTAssertEqual(result.completedCourses.first?.description, student.completedCourses.first?.description)
                    XCTAssertEqual(result.completedCourses.first?.credits, student.completedCourses.first?.credits)
                    XCTAssertEqual(result.completedCourses.first?.lessons.first, student.completedCourses.first?.lessons.first)
                    XCTAssertEqual(result.completedCourses.first?.classRoom.id, student.completedCourses.first?.classRoom.id)
                    XCTAssertEqual(result.completedCourses.first?.faculty, .facultyOfAccounting)
                    XCTAssertEqual(result.completedCourses.first?.teachers.first?.id, student.completedCourses.first?.teachers.first?.id)

                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_loading_student_profile_by_email() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadByEmailResult: Fail<Student?, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
        
        let expectation = expectation(description: "Should have received an error")
        
        sut.load(userWithEmail: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { student in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_all_students() {
        let students: [Student] = [
            Student(
                id: UUID(),
                name: "name",
                email: "email",
                activeCourses: [
                    Course(
                        ident: "active ident",
                        name: "name",
                        description: "desc",
                        credits: 6,
                        lessons: [Date() + 20000],
                        classRoom: ClassRoom(id: UUID(), name: "class room 2"),
                        faculty: .facultyOfInformatics,
                        teachers: [
                            Teacher(id: UUID(), name: "teacher name")
                        ],
                        students: [
                            ClassMate(name: "class mate", email: "email")
                        ]
                    )
                ],
                completedCourses: [
                    Course(
                        ident: "completed ident",
                        name: "name",
                        description: "desc",
                        credits: 4,
                        lessons: [Date()],
                        classRoom: ClassRoom(id: UUID(), name: "class room"),
                        faculty: .facultyOfAccounting,
                        teachers: [
                            Teacher(id: UUID(), name: "another teacher")
                        ],
                        students: [
                            ClassMate(name: "class mate", email: "email")
                        ]
                    )
                ]
            )
        ]
        
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadStudentsResult: Just(students)
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
        
        let expectation = expectation(description: "Should have load all student profiles")
        
        sut.loadAll()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }
                    
                    XCTFail()
                },
                receiveValue: { results in
                                        
                    XCTAssertEqual(results.first?.id, students.first?.id)
                    XCTAssertEqual(results.first?.name, students.first?.name)
                    XCTAssertEqual(results.first?.email, students.first?.email)
                    
                    XCTAssertEqual(results.first?.activeCourses.count, students.first?.activeCourses.count)
                    XCTAssertEqual(results.first?.completedCourses.count, students.first?.completedCourses.count)
                    
                    XCTAssertEqual(results.first?.activeCourses.first?.ident, students.first?.activeCourses.first?.ident)
                    XCTAssertEqual(results.first?.activeCourses.first?.name, students.first?.activeCourses.first?.name)
                    XCTAssertEqual(results.first?.activeCourses.first?.description, students.first?.activeCourses.first?.description)
                    XCTAssertEqual(results.first?.activeCourses.first?.credits, students.first?.activeCourses.first?.credits)
                    XCTAssertEqual(results.first?.activeCourses.first?.lessons.first, students.first?.activeCourses.first?.lessons.first)
                    XCTAssertEqual(results.first?.activeCourses.first?.classRoom.id, students.first?.activeCourses.first?.classRoom.id)
                    XCTAssertEqual(results.first?.activeCourses.first?.faculty, .facultyOfInformatics)
                    XCTAssertEqual(results.first?.activeCourses.first?.teachers.first?.id, students.first?.activeCourses.first?.teachers.first?.id)
                    
                    XCTAssertEqual(results.first?.completedCourses.first?.ident, students.first?.completedCourses.first?.ident)
                    XCTAssertEqual(results.first?.completedCourses.first?.name, students.first?.completedCourses.first?.name)
                    XCTAssertEqual(results.first?.completedCourses.first?.description, students.first?.completedCourses.first?.description)
                    XCTAssertEqual(results.first?.completedCourses.first?.credits, students.first?.completedCourses.first?.credits)
                    XCTAssertEqual(results.first?.completedCourses.first?.lessons.first, students.first?.completedCourses.first?.lessons.first)
                    XCTAssertEqual(results.first?.completedCourses.first?.classRoom.id, students.first?.completedCourses.first?.classRoom.id)
                    XCTAssertEqual(results.first?.completedCourses.first?.faculty, .facultyOfAccounting)
                    XCTAssertEqual(results.first?.completedCourses.first?.teachers.first?.id, students.first?.completedCourses.first?.teachers.first?.id)

                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_loading_all_students() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadStudentsResult: Fail<[Student], DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
        
        let expectation = expectation(description: "Should have received an error")
        
        sut.loadAll()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { student in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_remove_active_course() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                removeCourseResult: Just(())
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have remove student")
        
        sut.remove(courseIdent: "ident", forUserWithEmail: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_removing_active_course() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                removeCourseResult: Fail<Void, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have received an error")

        sut.remove(courseIdent: "ident", forUserWithEmail: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_mark_course_complete() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                markCompleteResult: Just(())
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have marked the course complete")
        
        sut.markComplete(courseIdent: "ident", forUserWithEmail: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_marking_course_complete() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                markCompleteResult: Fail<Void, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have received an error")

        sut.markComplete(courseIdent: "ident", forUserWithEmail: "email")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_all_courses() {
        let courses: Set<Course> = [
            Course(
                ident: "ident",
                name: "name",
                description: "desc",
                credits: 5,
                lessons: [Date()],
                classRoom: ClassRoom(id: UUID(), name: "name"),
                faculty: .facultyOfAccounting,
                teachers: [
                    Teacher(id: UUID(), name: "name")
                ],
                students: [
                    ClassMate(name: "name", email: "email")
                ]
            )
        ]
        
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadCoursesResult: Just(courses)
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have load all courses")
        
        sut.activeCourses()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { genericCourses in                    
                    XCTAssertEqual(genericCourses.first?.id, courses.first?.id)
                    XCTAssertEqual(genericCourses.first?.name, courses.first?.name)
                    XCTAssertEqual(genericCourses.first?.description, courses.first?.description)
                    XCTAssertEqual(genericCourses.first?.credits, courses.first?.credits)
                    XCTAssertEqual(genericCourses.first?.lessons.first, courses.first?.lessons.first)
                    XCTAssertEqual(genericCourses.first?.classRoom.id, courses.first?.classRoom.id)
                    XCTAssertEqual(genericCourses.first?.faculty, .facultyOfAccounting)
                    XCTAssertEqual(genericCourses.first?.teachers.first?.id, courses.first?.teachers.first?.id)
                    
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_all_courses_error() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                loadCoursesResult: Fail<Set<Course>, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have received an error")

        sut.activeCourses()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_active_courses() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                addCoursesAmongActiveResult: Just(())
                    .setFailureType(to: DatabaseError.self)
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have added the course")
        
        sut.addCourses([], forStudentWithEmail: "ident")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_error_adding_course_to_active() {
        let database = StudentDBRepositoryStub(
            results: .mock(
                addCoursesAmongActiveResult: Fail<Void, DatabaseError>(error: .init(cause: .deletingEntityError))
                    .eraseToAnyPublisher()
            )
        )
        
        let sut = StudentRepository(database: database)
           
        let expectation = expectation(description: "Should have received an error")

        sut.addCourses([], forStudentWithEmail: "ident")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        XCTFail()
                        return
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
