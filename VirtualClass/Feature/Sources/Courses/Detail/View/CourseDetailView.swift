//
//  CourseDetailView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

struct CourseDetailView: View {
    
    @ObservedObject private var viewModel: CourseDetailViewModel
    
    init(viewModel: CourseDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        withAnimation {
                            viewModel.goBackSubject.send()
                        }
                    }
                
                Spacer(minLength: 0)
            }
            .padding()
            
            VStack(spacing: 10) {
                Text(viewModel.courseDetail.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(viewModel.courseDetail.ident)
                    .fontWeight(.semibold)
                
                Divider()
                
                CourseDetailBodyView(
                    description: viewModel.courseDetail.description,
                    lecturers: viewModel.courseDetail.lecturers,
                    lessons: viewModel.courseDetail.lessons,
                    credits: viewModel.courseDetail.credits
                )
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                VStack {
                    Spacer(minLength: 0)
                    
                    Button(
                        action: { viewModel.markCourseCompleteTap.send(viewModel.courseDetail.ident) },
                        label: {
                            Text("Mark as completed")
                        }
                    )
                        .buttonStyle(AppGoldenButtonStyle())
                    
                    Button(
                        action: { viewModel.removeCourseTap.send(viewModel.courseDetail.ident) },
                        label: {
                            Text("Remove class")
                        }
                    )
                        .buttonStyle(AppRedButtonStyle())
                    
                    Spacer()
                        .frame(height: 20)
                }
            }
            
        }
    }
}
