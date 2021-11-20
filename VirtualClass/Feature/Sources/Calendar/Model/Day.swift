//
//  Day.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Foundation

struct Day: Identifiable {
    let id = UUID().uuidString
    let day: String
    let date: String
    let wholeDate: Date
    var isSelected: Bool
}

extension Day: Equatable {}
