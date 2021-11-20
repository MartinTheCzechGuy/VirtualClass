//
//  CourseCardView.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import SwiftUI

struct CourseCardView: View {
    
    private let name: String
    private let ident: String
    private let nextClass: String
    private let room: String
    private let background: Color
    
    init(
        name: String,
        ident: String,
        nextClass: String,
        room: String,
        background: Color
    ) {
        self.name = name
        self.ident = ident
        self.nextClass = nextClass
        self.room = room
        self.background = background
    }
    
    var body: some View {
        
        ZStack {
//            LinearGradient(
//                colors: [
//                    background,
//                    .white
//                ],
//                startPoint: .bottomLeading,
//                endPoint: .topTrailing
//            )
            background
                .cornerRadius(15)
            
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
    }
}
