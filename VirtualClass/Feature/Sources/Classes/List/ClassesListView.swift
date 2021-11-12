//
//  ClassListView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

public struct ClassListView: View {
    
    @ObservedObject var viewModel: ClassListViewModel
    
    public init(viewModel: ClassListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            List(viewModel.studiedClasses) { classData in
                NavigationLink(destination: ClassDetailView(viewModel: .init(selectedClass: classData))) {
                    Text(classData.name)
                }
            }
            .navigationTitle("My Classes")
        }
    }
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView(viewModel: .init())
    }
}
