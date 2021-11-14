//
//  Class.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

struct Class: Identifiable {
    let id = UUID()
    let name: String
    let ident: String
    let description: String
    let nextClass: Date
    let room: String
    let faculty: String
    let currentlyStudied: Bool
}

extension Class: Hashable { }
