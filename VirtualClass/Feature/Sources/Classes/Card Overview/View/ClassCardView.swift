//
//  ClassCardView.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import SwiftUI

struct ClassCardView: View {
    
    private let name: String
    private let ident: String
    private let nextClass: String
    private let room: String
    private let background: Color
    
    init(
        name: String,
        ident: String,
        nextClass: Date,
        room: String,
        background: Color
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM HH:mm"
        
        self.name = name
        self.ident = ident
        self.nextClass = dateFormatter.string(from: nextClass)
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

struct ClassCardView_Previews: PreviewProvider {
    static var previews: some View {
        ClassCardView(name: "Matematika pro Ekonomy", ident: "4MT432", nextClass: Date() + 10000, room: "4NB434Q", background: .classCardBlue)
    }
}
