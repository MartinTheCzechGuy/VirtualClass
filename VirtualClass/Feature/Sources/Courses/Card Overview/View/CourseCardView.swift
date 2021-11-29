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
    
    init(
        ident: String,
        name: String,
        room: String,
        nextClass: String
    ) {
        self.name = name
        self.ident = ident
        self.nextClass = nextClass
        self.room = room
    }
    
    var body: some View {
        
        ZStack {
            Color(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, opacity: 1)
            
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
