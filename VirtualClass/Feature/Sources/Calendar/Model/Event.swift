//
//  Event.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Foundation

struct Event: Identifiable {
    let id = UUID().uuidString
    let time: Date
    let room: String
    let className: String
    let ident: String
}
