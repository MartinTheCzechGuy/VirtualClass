//
//  CoursesCardsOverviewView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI
import InstanceProvider

public struct CoursesCardsOverviewView: View {
        
    @ObservedObject var viewModel: CourseCardsOverviewViewModel
        
    init(viewModel: CourseCardsOverviewViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            if let error = viewModel.errorLoadingData {
                Text(error)
                    .fontWeight(.bold)
            } else {
                VStack {
                    Text("Classes overview")
                        .font(.title.bold())
                        .padding()
                    
                    Divider()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                            ForEach(viewModel.studiedClasses) { data in
                                ClassCardView(
                                    name: data.name,
                                    ident: data.ident,
                                    nextClass: data.lessons.closestDate ?? "",
                                    room: data.classRoom.name,
                                    background: .classCardBlue
                                )
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.classCardTapSubject.send(data)
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            
            VStack {
                Spacer(minLength: 0 )
                
                Button(action: {
                    viewModel.adddClassSubject.send()
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .font(.largeTitle)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.white)
                        .background(Color.golden)
                        .clipShape(Circle())
                }
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            viewModel.reloadData.send()
        }
    }
}

extension Set where Element == Date {
    var closestDate: String? {
        guard let closestDate = self.sorted().first else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM, HH:mm"
        
        return dateFormatter.string(from: closestDate)
    }
}
