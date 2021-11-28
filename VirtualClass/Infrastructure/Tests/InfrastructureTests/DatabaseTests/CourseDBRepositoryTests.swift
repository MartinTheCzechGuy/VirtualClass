//
//  CourseDBRepositoryTests.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import XCTest
@testable import Database

final class CourseDBRepositoryTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    // MARK: - Saving
    
    func test_save_student() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let domainStudent = Student(
            id: UUID(),
            name: "Student Franta",
            email: "franta@student.cz",
            activeCourses: [],
            completedCourses: []
        )
        
        let expectation = expectation(description: "Student should have been saved.")
        
        sut.create(domainModel: domainStudent)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_save_student_with_courses() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let domainStudent = Student(
            id: UUID(),
            name: "Student Franta",
            email: "franta@student.cz",
            activeCourses: [
                Course(
                    ident: "2INF401",
                    name: "",
                    description: "",
                    credits: 6,
                    lessons: [],
                    classRoom: ClassRoom(id: UUID(), name: "class room 1"),
                    faculty: .facultyOfInformatics,
                    teachers: [
                        Teacher(id: UUID(), name: "Teacher Karolina")
                    ],
                    students: [
                        ClassMate(name: "Classmate Jarda", email: "jarda@student.cz")
                    ]
                )
            ],
            completedCourses: [
                Course(
                    ident: "1MG109",
                    name: "",
                    description: "",
                    credits: 3,
                    lessons: [
                        Date(),
                        Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                        Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                    ],
                    classRoom: ClassRoom(id: UUID(), name: "class room 2"),
                    faculty: .facultyOfManagement,
                    teachers: [
                        Teacher(id: UUID(), name: "Teacher Honza")
                    ],
                    students: [
                        ClassMate(name: "Classmate Nikol", email: "nikol@student.cz")
                    ]
                )
            ]
        )
        
        let expectation = expectation(description: "Student should have been saved.")
        
        sut.create(domainModel: domainStudent)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: - Fetching
    
    func test_fetch_student_by_id() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let domainStudent = Student(
            id: UUID(),
            name: "Student Franta",
            email: "franta@student.cz",
            activeCourses: [],
            completedCourses: []
        )
        
        let expectation1 = expectation(description: "Student should have been saved.")
        
        sut.create(domainModel: domainStudent)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Student should have been fetched.")
        
        sut.load(withID: domainStudent.id)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { student in
                    XCTAssertEqual(student?.name, domainStudent.name)
                    XCTAssertEqual(student?.email, domainStudent.email)
                    XCTAssertEqual(student?.activeCourses.count, domainStudent.activeCourses.count)
                    XCTAssertEqual(student?.completedCourses.count, domainStudent.completedCourses.count)

                    expectation2.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetch_student_by_email() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let domainStudent = Student(
            id: UUID(),
            name: "Student Franta",
            email: "franta@student.cz",
            activeCourses: [],
            completedCourses: []
        )
        
        let expectation1 = expectation(description: "Student should have been saved.")
        
        sut.create(domainModel: domainStudent)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Student should have been fetched.")
        
        sut.load(withEmail: domainStudent.email)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { student in
                    XCTAssertEqual(student?.name, domainStudent.name)
                    XCTAssertEqual(student?.email, domainStudent.email)
                    XCTAssertEqual(student?.activeCourses.count, domainStudent.activeCourses.count)
                    XCTAssertEqual(student?.completedCourses.count, domainStudent.completedCourses.count)

                    expectation2.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetch_students() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let expectation = expectation(description: "Students should have been fetched.")
        
        sut.loadStudents()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    XCTAssertEqual($0.count, 8)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_fetch_courses() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let expectation = expectation(description: "Courses should have been fetched.")
        
        sut.loadCourses()
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    XCTAssertEqual($0.count, 8)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: - Delete
    
    func test_delete_student() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let expectation1 = expectation(description: "Student should be stored.")
        var studentId: UUID!
        
        sut.load(withEmail: "joan@student.cz")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    XCTAssertNotNil($0)
                    studentId = $0?.id
                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Student should be deleted.")
        
        sut.delete(studentWithID: studentId)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation2.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation3 = expectation(description: "Student should not be stored.")
        
        sut.load(withEmail: "joan@student.cz")
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    XCTAssertNil($0)
                    expectation3.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: - Update
    
    func test_update_student() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let domainStudent = Student(
            id: UUID(),
            name: "Student Franta",
            email: "franta@student.cz",
            activeCourses: [],
            completedCourses: []
        )
        
        let newName = "Student Karel"
        let newEmail = "karel@student.cz"
        
        let expectation1 = expectation(description: "Student should have been saved.")
        
        sut.create(domainModel: domainStudent)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Student should have been updated.")
        
        sut.update(UserProfile(id: domainStudent.id, name: newName, email: newEmail))
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: {
                    expectation2.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation3 = expectation(description: "Student should have values updated.")
        
        sut.load(withID: domainStudent.id )
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { student in
                    XCTAssertNotNil(student)
                    XCTAssertEqual(student?.name, newName)
                    XCTAssertEqual(student?.email, newEmail)
                    
                    expectation3.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }

    
    // MARK: - Update course associations
    
    func test_add_course_among_actives() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let prefilledStudentEmail = "joan@student.cz"
        let courseToBeAddedIdent = "1MG109"
        var initialNumberOfActiveCourses: Int!
        
        let expectation1 = expectation(description: "Initial state should have been loaded")
        
        sut.load(withEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    XCTAssertNotNil(joan)
                    XCTAssertNil(joan?.activeCourses.first(where: { $0.ident == courseToBeAddedIdent }))
                    initialNumberOfActiveCourses = joan?.activeCourses.count
                    
                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Course should have been added")
        
        sut.addCoursesAmongActive(idents: [courseToBeAddedIdent], forStudentWithEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    expectation2.fulfill()
                }
            )
            .store(in: &bag)

        waitForExpectations(timeout: 0.1)
        
        let expectation3 = expectation(description: "Course should be present among actives")
        
        sut.load(withEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    XCTAssertNotNil(joan)
                    XCTAssertNotNil(joan?.activeCourses.first(where: { $0.ident == courseToBeAddedIdent }))
                    XCTAssertEqual(joan?.activeCourses.count, initialNumberOfActiveCourses + 1)
                    
                    expectation3.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_mark_course_complete() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let prefilledStudentEmail = "joan@student.cz"
        var courseToBeCompletedIdent: String!
        var initialNumberOfActiveCourses: Int!
        var initialNumberOfCompletedCourses: Int!

        let expectation1 = expectation(description: "Initial state should have been loaded")
        
        sut.load(withEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    XCTAssertNotNil(joan)
                    XCTAssertFalse(joan!.activeCourses.isEmpty)
                    courseToBeCompletedIdent = joan!.activeCourses.first?.ident
                    initialNumberOfActiveCourses = joan!.activeCourses.count
                    initialNumberOfCompletedCourses = joan!.completedCourses.count

                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Course should have been marked complete")
        
        sut.markComplete(courseIdent: courseToBeCompletedIdent, forUserWithEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    expectation2.fulfill()
                }
            )
            .store(in: &bag)

        waitForExpectations(timeout: 0.1)
        
        let expectation3 = expectation(description: "Course should be present among completed")
        
        sut.load(withEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    XCTAssertNotNil(joan)
                    XCTAssertEqual(joan?.activeCourses.count, initialNumberOfActiveCourses - 1)
                    XCTAssertEqual(joan?.completedCourses.count, initialNumberOfCompletedCourses + 1)
                    XCTAssertNotNil(joan?.completedCourses.first(where: { $0.ident == courseToBeCompletedIdent } ))

                    expectation3.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_remove_course_from_actives() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        let prefilledStudentEmail = "joan@student.cz"
        var courseToBeRemovedIdent: String!
        var initialNumberOfActiveCourses: Int!
        
        let expectation1 = expectation(description: "Initial state should have been loaded")
        
        sut.load(withEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    XCTAssertNotNil(joan)
                    XCTAssertFalse(joan!.activeCourses.isEmpty)
                    courseToBeRemovedIdent = joan!.activeCourses.first?.ident
                    initialNumberOfActiveCourses = joan?.activeCourses.count
                    
                    expectation1.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
        
        let expectation2 = expectation(description: "Course should have been removed")
        
        sut.removeCourse(forUserWithEmail: prefilledStudentEmail, courseIdent: courseToBeRemovedIdent)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    expectation2.fulfill()
                }
            )
            .store(in: &bag)

        waitForExpectations(timeout: 0.1)
        
        let expectation3 = expectation(description: "Course should be not present among actives")
        
        sut.load(withEmail: prefilledStudentEmail)
            .sink(
                receiveCompletion: { completion in
                    guard case .failure = completion else {
                        return
                    }

                    XCTFail()
                },
                receiveValue: { joan in
                    XCTAssertNotNil(joan)
                    XCTAssertNil(joan?.activeCourses.first(where: { $0.ident == courseToBeRemovedIdent }))
                    XCTAssertEqual(joan?.activeCourses.count, initialNumberOfActiveCourses - 1)
                    
                    expectation3.fulfill()
                }
            )
            .store(in: &bag)
        
        waitForExpectations(timeout: 0.1)
    }
}
