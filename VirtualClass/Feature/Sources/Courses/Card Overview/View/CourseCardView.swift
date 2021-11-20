//
//  CourseCardView.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import UserSDK
import SwiftUI

struct CourseCardView: View {
    
    private let ident: String
    private let name: String
    private let room: String
    private let nextClass: String
    private let faculty: GenericFaculty
    
    init(
        ident: String,
        name: String,
        room: String,
        nextClass: String,
        faculty: GenericFaculty
    ) {
        self.name = name
        self.ident = ident
        self.nextClass = nextClass
        self.room = room
        self.faculty = faculty
    }
    
    var body: some View {
        
        ZStack {
            faculty.background
            
            VStack(spacing: 10) {
                VStack(alignment: .center, spacing: 10) {
                    Text(name)
                    Text(ident)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Next class: \(nextClass)")
                    Text("Room: \(room)")
                }
            }
            .padding()
        }
        .cornerRadius(15)
    }
}
