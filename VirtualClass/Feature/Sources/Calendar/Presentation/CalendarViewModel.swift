//
//  CalendarViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation
import UserSDK

public final class CalendarViewModel: ObservableObject {
    
    // MARK: - View Model to View
    
    @Published var sevenDaysInterval: [Day] = []
    @Published var events: [Event] = []
    @Published var errorLoadingLectures = false
    
    // MARK: - View to View Model
    
    let dayCapsuleTap = PassthroughSubject<Day, Never>()
    
    // MARK: - Private
    
    private let getLecturesUseCase: GetLecturesUseCaseType
    private var bag: Set<AnyCancellable> = []
    
    init(getLecturesUseCase: GetLecturesUseCaseType) {
        self.getLecturesUseCase = getLecturesUseCase
        
        setupBindings()
    }
    
    private func setupBindings() {
        let dayChangeTap = dayCapsuleTap
            .compactMap { !$0.isSelected ? $0.wholeDate : nil }
            .prepend(Date())
            .share()
        
        #warning("TODO BUG - ta hodnota z dayChangeTap se nasharuje a ten prepend sem NEpritece")
        let lecturesOnTheDate = dayChangeTap
            .compactMap { [weak self] date -> Result<[Lecture], UserRepositoryError>? in
                self?.getLecturesUseCase.lectures(on: date)
            }
            .share()
        
        dayChangeTap
            .compactMap { [weak self] date -> [Day]? in
                self?.sevenDaysInterval(from: date)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.sevenDaysInterval, on: self)
            .store(in: &bag)
        
        lecturesOnTheDate
            .compactMap(\.failure)
            .map { _ in true }
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorLoadingLectures, on: self)
            .store(in: &bag)
        
        lecturesOnTheDate
            .compactMap(\.success)
            .map { lectures in
                lectures
                    .map { lecture in
                        Event(time: lecture.date, room: lecture.classRoomName, className: lecture.className, ident: lecture.classIdent)
                    }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.events, on: self)
            .store(in: &bag)
    }
    
    private func sevenDaysInterval(from date: Date) -> [Day] {
        let calendar = Calendar.current
        let sevenDaysIntervalStart = calendar.surroundingWeek(for: date)
        let dateFormatter = DateFormatter()
        
        var weekdays: [Day] = []
        
        for index in 0..<7 {
            guard let wholeDate = calendar.date(byAdding: .day, value: index, to: sevenDaysIntervalStart) else {
                return []
            }
            
            dateFormatter.dateFormat = "EEE"
            let day = dateFormatter.string(from: wholeDate)
            dateFormatter.dateFormat = "dd"
            let date = dateFormatter.string(from: wholeDate)
            
            weekdays.append(Day(day: day, date: date, wholeDate: wholeDate, isSelected: index == 3))
        }
        
        return weekdays
    }
}
