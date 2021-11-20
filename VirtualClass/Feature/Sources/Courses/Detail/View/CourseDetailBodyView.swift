//
//  CourseDetailBodyView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

struct CourseDetailBodyView: View {
    
    private let description: String
    private let lecturers: [String]
    private let lessons: [String]
    private let credits: String
    
    init(
        description: String,
        lecturers: [String],
        lessons: [String],
        credits: Int
    ) {
        self.description = description
        self.lecturers = lecturers
        self.lessons = lessons
        self.credits = String(credits)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(description)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .font(.body)
                .padding()
            
            HStack {
                Text("Lecturers: ")
                    .font(.body)
                    .padding()
                
                VStack {
                    ForEach(lecturers, id: \.self) { lecturer in
                        Text(lecturer)
                    }
                }
            }
            
            Text("Lessons: ")
                .font(.body)
                .padding()
            
            Text("Credits: ")
                .font(.body)
                .padding()
        }
        .padding(.horizontal)
    }
}
