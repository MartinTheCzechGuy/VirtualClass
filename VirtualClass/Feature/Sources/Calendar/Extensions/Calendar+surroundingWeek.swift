//
//  Calendar+surroundingWeek.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Foundation

extension Calendar {
    func surroundingWeek(for date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: -3, to: date)!
    }
}
