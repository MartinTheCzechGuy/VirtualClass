//
//  ClassDetailBodyView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

struct ClassBasicData {
    let about: String
    let lecturer: String
    let lessons: String
    let credits: Int
}

struct ClassDetailBodyView: View {
    
    private let classData: ClassBasicData
    
    init(classData: ClassBasicData) {
        self.classData = classData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("About: \(classData.about)")
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .font(.body)
                .padding()
            
            Text("Lecturer: ")
                .font(.body)
                .padding()
            
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
