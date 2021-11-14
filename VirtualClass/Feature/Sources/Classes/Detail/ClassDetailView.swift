//
//  ClassDetailView.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import SwiftUI

struct ClassDetailView: View {
    
    @ObservedObject var viewModel: ClassDetailViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
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
                
                Text(viewModel.selectedClass.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 10) {
                Text(viewModel.selectedClass.ident)
                    .fontWeight(.semibold)
                
                Divider()
                
                ClassDetailBodyView(
                    classData: ClassBasicData(
                        about: viewModel.selectedClass.description,
                        lecturer: "",
                        lessons: "",
                        credits: 6
                    )
                )
                
                VStack {
                    Spacer(minLength: 0)
                    
                    Button(
                        action: { print("pressed completed") },
                        label: {
                            Text("Mark as completed")
                        }
                    )
                        .buttonStyle(AppGoldenButtonStyle())
                    
                    Button(
                        action: { print("pressed remove") },
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
