//
//  Lecture.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Foundation

public struct Lecture {
    public let classIdent: String
    public let className: String
    public let classRoomName: String
    public let date: Date
    
    public init(
        classIdent: String,
        className: String,
        classRoomName: String,
        date: Date
    ) {
        self.classIdent = classIdent
        self.className = className
        self.classRoomName = classRoomName
        self.date = date
    }
}
