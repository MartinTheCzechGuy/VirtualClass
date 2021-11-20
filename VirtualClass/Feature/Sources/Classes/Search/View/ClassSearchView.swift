//
//  ClassSearchView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

public struct ClassSearchView: View {
    
    @ObservedObject var viewModel: ClassSearchViewModel
        
    public init(viewModel: ClassSearchViewModel) {
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
                        
            ForEach($viewModel.searchResult) { $classData in
                HStack {
                    Toggle(isOn: $classData.isSelected) {
                        Text("\(classData.ident) - \(classData.name)")
                    }
                    .toggleStyle(CheckToggleStyle())
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .frame(width: 300, alignment: .center)
                .background(Color.gray)
                .cornerRadius(16)
            }
            .background(Color.white)
            
            Spacer(minLength: 0)
            
            Button(
                action: { viewModel.addSelectedTapSubject.send() },
                label: {
                    Text("Add selected")
                }
            )
                .buttonStyle(AppGoldenButtonStyle())
        }
        .onAppear {
            viewModel.reloadDataSubject.send()
        }
        .padding()
        .alert(isPresented: $viewModel.showError) { () -> Alert in
            Alert(
                title: Text("The class name \(viewModel.searchedCourse) not found. Please try a different name or ident."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
