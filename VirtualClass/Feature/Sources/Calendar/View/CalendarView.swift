//
//  CalendarView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

public struct CalendarView: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    
    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        withAnimation {
                            viewModel.goBackTap.send()
                        }
                    }
                
                Spacer(minLength: 0)
            }
            .padding()
            
            HStack {
#warning("TODO - zatim to nech bez scrollbaru, datumy se budou menit jenom tim jak jak se posouvas o jednotlivy dny.")
                ForEach($viewModel.sevenDaysInterval) { $date in
                    DateView(
                        day: date.day,
                        date: date.date,
                        isSelected: $date.isSelected
                    )
                        .onTapGesture {
                            withAnimation {
                                viewModel.dayCapsuleTap.send(date)
                            }
                        }
                }
            }
            
            Divider()
            
            if viewModel.events.isEmpty {
                Spacer(minLength: 0)
                Text("No events for today! 🎉")
                    .fontWeight(.bold)
                Spacer(minLength: 0)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    ForEach(viewModel.events) { event in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(event.time, style: .time)
                            
                            Text(event.className)
                                .fontWeight(.bold)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.golden.cornerRadius(8))
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CalendarVIew_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarView(viewModel: .init())
                .previewDevice("iPhone 13")
            CalendarView(viewModel: .init())
                .previewDevice("iPhone 8")
        }
    }
}
