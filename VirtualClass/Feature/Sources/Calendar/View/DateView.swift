//
//  DateView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SharedFeatures
import SwiftUI

struct DateView: View {
    
    private let day: String
    private let date: String
    @Binding var isSelected: Bool
    
    init(day: String, date: String, isSelected: Binding<Bool>) {
        self.day = day
        self.date = date
        self._isSelected = isSelected
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(day)
                .fontWeight(.bold)
            
            Text(date)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .foregroundColor(isSelected ? .white : .black)
        .background(isSelected ? Color.golden : Color.white)
        .clipShape(Capsule())
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(day: "Mon", date: "28", isSelected: .constant(true))
    }
}
