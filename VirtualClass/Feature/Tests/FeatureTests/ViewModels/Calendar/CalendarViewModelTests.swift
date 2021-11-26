//
//  CalendarViewModelTests.swift
//
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK
import XCTest

@testable import Calendar

final class CalendarViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_load_lectures_success() {
        let lectures: [Lecture] = [
            Lecture(
                classIdent: "ident",
                className: "name",
                classRoomName: "room",
                date: Date()
            ),
            Lecture(
                classIdent: "ident2",
                className: "name 2",
                classRoomName: "room 2",
                date: Date() + 20000
            )
        ]
        let lecturesPublisher = Just(lectures)
            .setFailureType(to: GetLecturesError.self)
            .eraseToAnyPublisher()
        let getLecturesUseCase = GetLecturesUseCaseStub(result: lecturesPublisher)

        let sut = CalendarViewModel(getLecturesUseCase: getLecturesUseCase)

        let expectation = expectation(description: "Lectures should have been loaded")
        expectation.expectedFulfillmentCount = 4

        sut.$events
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.$sevenDaysInterval
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.dayCapsuleTap.send(Day(day: "", date: "", wholeDate: Date(), isSelected: true))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_load_lectures_error() {
        let lecturesPublisher = Fail<[Lecture], GetLecturesError>(error: GetLecturesError(cause: .errorLoadingCourses))
            .eraseToAnyPublisher()
        let getLecturesUseCase = GetLecturesUseCaseStub(result: lecturesPublisher)

        let sut = CalendarViewModel(getLecturesUseCase: getLecturesUseCase)

        let expectation = expectation(description: "Error should have been propagated")
        expectation.expectedFulfillmentCount = 2
        
        sut.$errorLoadingLectures
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.$events
            .dropFirst()
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.dayCapsuleTap.send(Day(day: "", date: "", wholeDate: Date(), isSelected: true))

        waitForExpectations(timeout: 0.1)
    }
    
    func test_seven_day_interval_calculated_correctly() {
        let dayTapped = Day(
            day: "day",
            date: "12.3.2021",
            wholeDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            isSelected: false
        )
                
        let lecturesPublisher = Empty<[Lecture], GetLecturesError>()
            .eraseToAnyPublisher()
        let getLecturesUseCase = GetLecturesUseCaseStub(result: lecturesPublisher)

        let sut = CalendarViewModel(getLecturesUseCase: getLecturesUseCase)

        let expectation = expectation(description: "Dates should have been adjusted correctly, so that the selected day is in the middle.")
        
        var numberOfCalls = 0
        
                
        sut.$sevenDaysInterval
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { daysInterval in
                    switch numberOfCalls {
                    case 0:
                        XCTAssertEqual(daysInterval.count, 0)
                    case 1:
                        XCTAssertEqual(daysInterval.count, 7)
                        XCTAssertTrue(daysInterval[3].wholeDate.timeIntervalSince1970 - Date().timeIntervalSince1970 < 0.001)
                    case 2:
                        XCTAssertEqual(daysInterval.count, 7)
                        XCTAssertEqual(daysInterval[3].wholeDate, dayTapped.wholeDate)
                        expectation.fulfill()
                    default:
                        XCTFail()
                    }
                    
                    numberOfCalls += 1
                }
            )
            .store(in: &bag)
        
        sut.dayCapsuleTap.send(dayTapped)

        waitForExpectations(timeout: 0.1)
    }
}
