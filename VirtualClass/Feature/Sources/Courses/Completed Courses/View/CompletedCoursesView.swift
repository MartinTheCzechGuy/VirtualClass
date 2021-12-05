//
//  CompletedCoursesView.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import SwiftUI

public struct CompletedCoursesView: View {
    
    @ObservedObject private var viewModel: CompletedCoursesViewModel
    
    init(viewModel: CompletedCoursesViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        withAnimation {
                            viewModel.goBackTapSubject.send()
                        }
                    }
                
                Spacer(minLength: 0)
            }
            .padding()
            
            Text("Successfully completed courses")
            
            Divider()
            
            Spacer()
                .frame(height: 40)
                        
            ForEach(viewModel.completedCourses) { courseData in
                HStack {
                    Text("\(courseData.ident) - \(courseData.name)")
                        .font(.subheadline)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
            }
            
            Spacer(minLength: 0)
        }
        .onAppear {
            viewModel.reloadDataSubject.send()
        }
        .padding()
        .alert(isPresented: $viewModel.showError) { () -> Alert in
            Alert(
                title: Text("Error loading data 👻. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
