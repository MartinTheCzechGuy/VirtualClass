//
//  CalendarViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation

#warning("TODO - kdyby si chtel tahat udalosti z kalendare v telefonu, je na to framework EventKit")

public final class CalendarViewModel: ObservableObject {
    
    @Published var sevenDaysInterval: [Day] = []
    @Published var selectedDay: Date = {
        
        return Date()
    }()
    @Published var events: [Event] = []
    
    let dayCapsuleTap = PassthroughSubject<Day, Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    private var bag: Set<AnyCancellable> = []
    
    public init() {
        let dayChangeTap = dayCapsuleTap
            .compactMap { !$0.isSelected ? $0.wholeDate : nil }
            .prepend(Date())
            .share()
        
        dayChangeTap
            .compactMap { [weak self] date -> [Day]? in
                guard let self = self else { return nil }
                
                return self.sevenDaysInterval(from: date)
            }
            .assign(to: \.sevenDaysInterval, on: self)
            .store(in: &bag)
        
        dayChangeTap
            .compactMap { [weak self] date -> [Event]? in
                guard let self = self else { return nil }
                
                return self.events(on: date)
            }
            .assign(to: \.events, on: self)
            .store(in: &bag)
    }
    
    private func events(on date: Date) -> [Event] {
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return []
        } else {
            return [
                .init(time: Date(), room: "Room", className: "Matematika", ident: "43MRER"),
                .init(time: Date(), room: "Room 2", className: "Matematika II.", ident: "55MRER")
            ]
        }
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

struct Day: Identifiable {
    let id = UUID().uuidString
    let day: String
    let date: String
    let wholeDate: Date
    var isSelected: Bool
}

extension Day: Equatable {}

struct Event: Identifiable {
    let id = UUID().uuidString
    let time: Date
    let room: String
    let className: String
    let ident: String
}
