//
//  CourseSearchView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct CourseSearchView: View {
    
    @ObservedObject private var viewModel: CourseSearchViewModel
        
    public init(viewModel: CourseSearchViewModel) {
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
            
            HStack {
                TextField("Enter class ident...", text: $viewModel.searchedCourse)
                Image(systemName: "magnifyingglass")
            }
            .padding(10)
            .background(Color.golden)
            .cornerRadius(8)
            
            Spacer()
                .frame(height: 40)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10) {
                    ForEach($viewModel.searchResult) { $classData in
                        HStack {
                            Toggle(isOn: $classData.isSelected) {
                                Text("\(classData.ident) - \(classData.name)")
                            }
                            .toggleStyle(CheckToggleStyle())
                            
                            Spacer(minLength: 0)
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    }
               
                
                    Spacer(minLength: 0)
                
                    Button(
                        action: { viewModel.addSelectedTapSubject.send() },
                        label: {
                            Text("Add selected")
                        }
                    )
                        .buttonStyle(AppGoldenButtonStyle())
                }
            }
        }
        .onAppear {
            viewModel.reloadDataSubject.send()
        }
        .padding()
        .ignoresSafeArea(.container, edges: .bottom)
        .alert(item: $viewModel.showError) { errorMessage in
            Alert(
                title: Text(errorMessage.rawValue),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
