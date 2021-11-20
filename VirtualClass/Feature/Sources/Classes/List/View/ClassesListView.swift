//
//  ClassListView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI
import UserSDK
import InstanceProvider

extension Set where Element == Date {
    var asClassDetailModel: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM, HH:mm"
        
        return map(dateFormatter.string)
    }
}

extension Set where Element == GenericTeacher {
    var asClassDetailModel: [String] {
        map(\.name)
    }
}

public struct ClassListView: View {
    
    @ObservedObject var viewModel: ClassListViewModel
    
    private let instanceProvider: InstanceProvider
    
    public init(
        instanceProvider: InstanceProvider,
        viewModel: ClassListViewModel
    ) {
        self.instanceProvider = instanceProvider
        self.viewModel = viewModel
    }
        
    public var body: some View {
        NavigationView {
            List(viewModel.studiedClasses) { classData in
                NavigationLink(
                    destination: {
                        CourseDetailView(
                            viewModel: CourseDetailViewModel(
                                removeCourseFromStudiedUseCase: instanceProvider.resolve(RemoveCourseFromStudiedUseCaseType.self),
                                markCourseCompleteUseCase: instanceProvider.resolve(MarkCourseCompleteUseCaseType.self),
                                courseDetail:
                                    CourseDetailModel(
                                        ident: classData.ident,
                                        name: classData.name,
                                        description: classData.description,
                                        lecturers: classData.teachers.asClassDetailModel,
                                        lessons: classData.lessons.asClassDetailModel,
                                        credits: classData.credits
                                    )
                            )
                        )
                    }, label: {
                        Text(classData.name)
                    }
                )
            }
            .navigationTitle("My Classes")
            .navigationBarItems(leading:
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
            )
        }
    }
}
