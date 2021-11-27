//
//  CourseDBRepositoryTests.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import XCTest
@testable import Database

final class CourseDBRepositoryTests: XCTestCase {
    
    func testSaveGenericPassword() {
        let databaseInteractor = DatabaseInteractorMock(
            dbManager: DatabaseManagerMock(),
            databaseSetup: SQLDBSetupStub()
        )
        let sut = CourseDBRepository(
            databaseInteractor: databaseInteractor,
            classRoomConverter: ClassRoomConverter.live(),
            teacherConverter: TeacherConverter.live()
        )
        
        XCTAssertTrue(true)
    }
}
